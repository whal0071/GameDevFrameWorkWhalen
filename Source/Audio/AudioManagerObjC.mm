//
//  AudioManagerObjC.m
//  GameDevFramework
//
//  Created by Bradley Flood on 12-09-05.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "AudioManagerObjC.h"
#import "AudioConstants.h"
#import "AudioUtils.h"


@interface AudioManagerObjC()

- (void)loadMusic:(NSString *)filename doesRepeat:(BOOL)doesRepeat;
- (void)unloadMusic;

- (void)loadSoundEffect:(NSString *)filename doesRepeat:(BOOL)doesRepeat;
- (void)unloadSoundEffect:(NSString *)filename;
- (void)unloadSoundEffectFromAudioDictionary:(NSMutableDictionary *)audioDictionary;

- (NSMutableDictionary *)getAvailableAudioDictionary;
- (NSMutableDictionary *)getAudioDictionaryForFilename:(NSString *)filename;

- (float)getSoundEffectDurationInSeconds:(NSMutableDictionary *)audioDictionary;
- (float)getSoundEffectElapsedTimeInSeconds:(NSMutableDictionary *)audioDictionary;

- (void)printAudioDictionaryDetails;

- (void)soundEffectCompletionCallback:(NSMutableDictionary *)audioDictionary;

@end


@implementation AudioManagerObjC

@synthesize musicVolume = m_MusicVolume;
@synthesize soundEffectVolume = m_SoundEffectsVolume;

static AudioManagerObjC* audioManagerInstance = nil;
 
+ (AudioManagerObjC *)sharedInstance
{
  @synchronized(self)
  {
    if(audioManagerInstance == nil)
    {
      audioManagerInstance = [[AudioManagerObjC alloc] init];
    }
  }
  
  return audioManagerInstance;
}

- (id)init
{
  if((self=[super init]) != nil)
  {
    //
    m_AudioPlayer = nil;
    
    //Get the device we are going to use for audioFX, using NULL gets the default device.
    ALCdevice* alcDevice = alcOpenDevice(NULL);
    if(alcDevice != NULL) 
    {
      //Use the device we have now got to create a context in which to play our sounds.
      m_OpenALContext = alcCreateContext(alcDevice, 0);
      if(m_OpenALContext != NULL)
      {
        //Make the context we have just created into the active context.
        alcMakeContextCurrent(m_OpenALContext);
          
        //Set the distance model to be used
        alDistanceModel(AL_LINEAR_DISTANCE_CLAMPED);
      
        //Create the music fx sources array, this will be used to keep track of active tracks.
        m_SoundEffectsArray = [[NSMutableArray alloc] initWithCapacity:MAX_AUDIO_SOUND_EFFECTS];
        
        //
        for(int i = 0; i < MAX_AUDIO_SOUND_EFFECTS; i++)
        {
          //
          NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",                         @"Filename",
                                                                                               [NSNumber numberWithInt:-1],  @"SourceId",
                                                                                               [NSNumber numberWithInt:-1],  @"BufferId",
                                                                                               [NSNumber numberWithInt:-1],  @"Format",
                                                                                               [NSNumber numberWithUnsignedInt:0],  @"Size",
                                                                                               [NSNumber numberWithInt:-1],  @"SampleRate",
                                                                                               [NSNumber numberWithBool:NO], @"IsPlaying",
                                                                                               nil];
          
          //
          [m_SoundEffectsArray addObject:dictionary];
          
          //
          [dictionary release];
          dictionary = nil;
        }
      }
    }
    
    //
    m_MusicVolume = DEFAULT_AUDIO_VOLUME;
    m_SoundEffectsVolume = DEFAULT_AUDIO_VOLUME;
  }
  return self;
}

- (void)dealloc
{
  [super dealloc];
}

- (void)loadMusic:(NSString *)aFilename doesRepeat:(BOOL)aDoesRepeat
{
  //Safety check the audio player, if there is already music loaded, unload it first
  if(m_AudioPlayer != nil)
  {
    [self unloadMusic];
  }

  //Get the path for the filename, always of type mp3
  NSString *path = [[NSBundle mainBundle] pathForResource:aFilename ofType:@"mp3"];
  NSURL *patlUrl = [[NSURL alloc] initFileURLWithPath:path];
  NSError *error = nil;

  //Allocate the music player with the file path
  m_AudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:patlUrl error:&error];
  [m_AudioPlayer setVolume:m_MusicVolume];
  
  //Set the wether the music loops or not
  [m_AudioPlayer setNumberOfLoops:aDoesRepeat == YES ? -1 : 0];
    
  //Release the pathUrl, it's no longer needed
  [patlUrl release];
}

- (void)unloadMusic
{
  //If the music is playing, stop the music
  if([self isMusicPlaying] == YES)
  {
    [self stopMusic];
  }
  
  //Release the audio player and set the pointer to nil
  [m_AudioPlayer release];
  m_AudioPlayer = nil;
}

- (void)playMusic:(NSString *)aFilename
{
  [self playMusic:aFilename doesRepeat:YES];
}

- (void)playMusic:(NSString *)aFilename doesRepeat:(BOOL)aDoesRepeat
{  
  //Load the music file
  [self loadMusic:aFilename doesRepeat:aDoesRepeat];
  
  //Begin playing the music
  [self resumeMusic];
}

- (void)stopMusic
{
  [m_AudioPlayer stop];
  [m_AudioPlayer setCurrentTime:0.0];
}

- (void)pauseMusic
{
  [m_AudioPlayer pause];
}

- (void)resumeMusic
{
  [m_AudioPlayer play];
}

- (BOOL)isMusicPlaying
{
  if(m_AudioPlayer != nil)
  {
    return [m_AudioPlayer isPlaying];
  }
  return NO;
}

- (void)setMusicVolume:(float)aMusicVolume
{
  //Safety check the music volume level
  m_MusicVolume = fmaxf(fminf(aMusicVolume, MAX_AUDIO_VOLUME), MIN_AUDIO_VOLUME);
  
  //Set the audio player's volume
  [m_AudioPlayer setVolume:m_MusicVolume];
}

- (void)loadSoundEffect:(NSString *)aFilename doesRepeat:(BOOL)aDoesRepeat
{
  //
  void* audioData = NULL;
  unsigned int audioDataSize;
  int  audioDataFormat;
  int audioDataSampleRate;
  NSMutableDictionary *audioDictionary = [self getAvailableAudioDictionary];
  
  //
  if(audioDictionary == nil)
  {
    return;
  }

  //Load the audio data
  AudioUtils::loadAudioData([aFilename cStringUsingEncoding:NSUTF8StringEncoding], &audioData, &audioDataSize, &audioDataFormat, &audioDataSampleRate);

  //Safety check the audio data
  if(audioData != NULL)
  {
    //
    ALuint sourceId;
    ALuint bufferId;
    
    //Generate an OpenAL source id
    if(alGetError() == AL_NO_ERROR)
    {
      alGenSources(1, &sourceId);
    }
    
    //Generate a buffer within OpenAL for this sound
    if(alGetError() == AL_NO_ERROR)
    {
      alGenBuffers(1, &bufferId);
    }
    
    //Specify the data to be copied into the openAL buffer
    if(alGetError() == AL_NO_ERROR)
    {
      alBufferData(bufferId, audioDataFormat, audioData, audioDataSize, audioDataSampleRate);
    }
    
    //
    if(alGetError() == AL_NO_ERROR)
    {
      //
      [audioDictionary setObject:aFilename forKey:@"Filename"];
      [audioDictionary setObject:[NSNumber numberWithInt:sourceId] forKey:@"SourceId"];
      [audioDictionary setObject:[NSNumber numberWithInt:bufferId] forKey:@"BufferId"];
      [audioDictionary setObject:[NSNumber numberWithInt:audioDataFormat] forKey:@"Format"];
      [audioDictionary setObject:[NSNumber numberWithUnsignedInt:audioDataSize] forKey:@"Size"];
      [audioDictionary setObject:[NSNumber numberWithInt:audioDataSampleRate] forKey:@"SampleRate"];
      
      //Make sure that the source is clean by resetting the buffer assigned to the source to 0
      alSourcei(sourceId, AL_BUFFER, 0);
      
      //Attach the buffer to the source.
      alSourcei(sourceId, AL_BUFFER, bufferId);
    
      //Set the pitch and gain of the source.
      alSourcef(sourceId, AL_PITCH, 1.0f);
      alSourcef(sourceId, AL_GAIN, m_SoundEffectsVolume);
    
      //Set the looping value
      alSourcei(sourceId, AL_LOOPING, aDoesRepeat);
     
      //Set the source location- just using left and right panning
      float sourcePosAL[] = {0.0f, 0.0f, 0.0f};
      alSourcefv(sourceId, AL_POSITION, sourcePosAL);
    }
    
    //Lastly free the audio data
    free(audioData);
    audioData = NULL;
  }
}

- (void)unloadSoundEffect:(NSString *)aFilename
{
  //
  NSMutableDictionary *audioDictionary = [self getAudioDictionaryForFilename:aFilename];

  //
  [self unloadSoundEffectFromAudioDictionary:audioDictionary];
}

- (void)unloadSoundEffectFromAudioDictionary:(NSMutableDictionary *)aAudioDictionary
{
  //
  NSString *filename = [aAudioDictionary objectForKey:@"Filename"];

  //
  if([self isSoundEffectPlaying:filename] == YES)
  {
    [self stopSoundEffect:filename];
  }

  ALuint sourceId = [[aAudioDictionary objectForKey:@"SourceId"] intValue];
  ALuint bufferId = [[aAudioDictionary objectForKey:@"BufferId"] intValue];
  
  //Unbind the source id from the audio buffer
  alSourcei(sourceId, AL_BUFFER, 0);

  //
  if(alGetError() == AL_NO_ERROR)
  {
    alDeleteBuffers(1, &bufferId);
  }
  
  //
  if(alGetError() == AL_NO_ERROR)
  {
    alDeleteSources(1, &sourceId);
  }
  
  //
  [aAudioDictionary setObject:@"" forKey:@"Filename"];
  [aAudioDictionary setObject:[NSNumber numberWithInt:-1] forKey:@"SourceId"];
  [aAudioDictionary setObject:[NSNumber numberWithInt:-1] forKey:@"BufferId"];
  [aAudioDictionary setObject:[NSNumber numberWithInt:-1] forKey:@"Format"];
  [aAudioDictionary setObject:[NSNumber numberWithUnsignedInt:0] forKey:@"Size"];
  [aAudioDictionary setObject:[NSNumber numberWithInt:-1] forKey:@"SampleRate"];
  [aAudioDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"IsPlaying"];
}

- (void)playSoundEffect:(NSString *)aFilename
{
  [self playSoundEffect:aFilename doesRepeat:NO];
}

- (void)playSoundEffect:(NSString *)aFilename doesRepeat:(BOOL)aDoesRepeat
{
  //Load the music file
  [self loadSoundEffect:aFilename doesRepeat:aDoesRepeat];
  
  //Begin playing the music
  [self resumeSoundEffect:aFilename];
}

- (void)stopSoundEffect:(NSString *)aFilename
{
  //
  NSMutableDictionary *audioDictionary = [self getAudioDictionaryForFilename:aFilename];
  
  //
  if(audioDictionary != nil)
  {
    //
    ALuint sourceId = [[audioDictionary objectForKey:@"SourceId"] intValue];
    alSourceStop(sourceId);
    alSourceRewind(sourceId);
    
    //
    [audioDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"IsPlaying"];
  }
}

- (void)pauseSoundEffect:(NSString *)aFilename
{
  //
  NSMutableDictionary *audioDictionary = [self getAudioDictionaryForFilename:aFilename];
  
  //
  if(audioDictionary != nil)
  {
    //
    ALuint sourceId = [[audioDictionary objectForKey:@"SourceId"] intValue];
    alSourcePause(sourceId);
    
    //
    [audioDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"IsPlaying"];
  }
}

- (void)resumeSoundEffect:(NSString *)aFilename
{
  //
  NSMutableDictionary *audioDictionary = [self getAudioDictionaryForFilename:aFilename];
  
  //
  if(audioDictionary != nil)
  {
    //
    ALuint sourceId = [[audioDictionary objectForKey:@"SourceId"] intValue];
    alSourcePlay(sourceId);
    
    //
    [audioDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"IsPlaying"];
    
    //
    ALint doesRepeat;
    alGetSourcei(sourceId, AL_LOOPING, &doesRepeat);
    
    //
    if((bool)doesRepeat == false)
    {
      NSTimeInterval delay = [self getSoundEffectDurationInSeconds:audioDictionary] - [self getSoundEffectElapsedTimeInSeconds:audioDictionary];
      [self performSelector:@selector(soundEffectCompletionCallback:) withObject:audioDictionary afterDelay:delay];
    }
  }
}

- (BOOL)isSoundEffectPlaying:(NSString *)aFilename
{
  NSMutableDictionary *audioDictionary = [self getAudioDictionaryForFilename:aFilename];
  if(audioDictionary != nil)
  {
    BOOL isPlaying = [[audioDictionary objectForKey:@"IsPlaying"] boolValue];
    return isPlaying;
  }
  return NO;
}

- (void)setSoundEffectVolume:(float)aSoundEffectVolume
{
  //Safety check the sound effect volume level
  m_SoundEffectsVolume = m_MusicVolume = fmaxf(fminf(aSoundEffectVolume, MAX_AUDIO_VOLUME), MIN_AUDIO_VOLUME);;
  
  //Cycle through each sound effect and set the new volume level
  for(int i = 0; i < MAX_AUDIO_SOUND_EFFECTS; i++)
  {
    NSMutableDictionary *audioDictionary = [m_SoundEffectsArray objectAtIndex:i];
    
    //Get the filename from the audio dictionary
    NSString *filename = [audioDictionary objectForKey:@"Filename"];
    
    //Safety check the filename
    if(filename != nil && [filename isEqualToString:@""] == NO)
    {
      //Get the source id from the audio dictionary
      int sourceId = [[audioDictionary objectForKey:@"SourceId"] intValue];
      if(sourceId != -1)
      {
        //Set the sound effects volume
        alSourcef(sourceId, AL_GAIN, m_SoundEffectsVolume);
      }
    }
  }
}

- (void)cleanupSoundEffects
{
  //
  for(int i = 0; i < MAX_AUDIO_SOUND_EFFECTS; i++)
  {
    NSMutableDictionary *audioDictionary = [m_SoundEffectsArray objectAtIndex:i];
    
    //Get the filename from the audio dictionary
    NSString *filename = [audioDictionary objectForKey:@"Filename"];
    
    //If the sound effect isn't playing unload it, and return the audio dictionary
    if([self isSoundEffectPlaying:filename] == NO)
    {
      [self unloadSoundEffectFromAudioDictionary:audioDictionary];
    }
  }
}

- (NSMutableDictionary *)getAvailableAudioDictionary
{
  //Cycle through each sound effect and set the new volume level
  for(int i = 0; i < MAX_AUDIO_SOUND_EFFECTS; i++)
  {
    NSMutableDictionary *audioDictionary = [m_SoundEffectsArray objectAtIndex:i];
    
    //Get the filename from the audio dictionary
    NSString *filename = [audioDictionary objectForKey:@"Filename"];
    
    //Safety check the filename
    if(filename == nil || [filename isEqualToString:@""] == YES)
    {
      return audioDictionary;
    }
  }
  
  //If we got here, it's because all the audio effect slots are taken, cycle through
  //and find one that isn't playing, then unload it and return the audio dictionary
  for(int i = 0; i < MAX_AUDIO_SOUND_EFFECTS; i++)
  {
    NSMutableDictionary *audioDictionary = [m_SoundEffectsArray objectAtIndex:i];
    
    //Get the filename from the audio dictionary
    NSString *filename = [audioDictionary objectForKey:@"Filename"];
    
    //If the sound effect isn't playing unload it, and return the audio dictionary
    if([self isSoundEffectPlaying:filename] == NO)
    {
      [self unloadSoundEffectFromAudioDictionary:audioDictionary];
      return audioDictionary;
    }
  }
  
  //If we got here, every sound effect slot is currently playing
  return nil;
}

- (NSMutableDictionary *)getAudioDictionaryForFilename:(NSString *)aFilename
{
  if(aFilename != nil)
  {
    for(int i = 0; i < MAX_AUDIO_SOUND_EFFECTS; i++)
    {
      NSMutableDictionary *audioDictionary = [m_SoundEffectsArray objectAtIndex:i];
      NSString *filename = [audioDictionary objectForKey:@"Filename"];
      if(filename != nil && [aFilename isEqualToString:filename] == YES)
      {
        return audioDictionary;
      }
    }
  }
  return nil;
}

- (float)getSoundEffectDurationInSeconds:(NSMutableDictionary *)aAudioDictionary
{
	if(aAudioDictionary != nil) 
  {
    int sourceId = [[aAudioDictionary objectForKey:@"SourceId"] intValue];
    int audioFormat = [[aAudioDictionary objectForKey:@"Format"] intValue];
    unsigned int audioDataSize = [[aAudioDictionary objectForKey:@"Size"] unsignedIntValue];
    int audioSampleRate = [[aAudioDictionary objectForKey:@"SampleRate"] intValue];

    if(sourceId != -1)
    {
      float factor = 0.0f;
      switch(audioFormat) 
      {
        case AL_FORMAT_MONO8:
          factor = 1.0f;
          break;
        case AL_FORMAT_MONO16:
          factor = 0.5f;
          break;
        case AL_FORMAT_STEREO8:
          factor = 0.5f;
          break;
        case AL_FORMAT_STEREO16:
          factor = 0.25f;
          break;
      }
      
      return (float)audioDataSize/(float)audioSampleRate * factor;
    }
	} 

  return 0.0f;
}

- (float)getSoundEffectElapsedTimeInSeconds:(NSMutableDictionary *)aAudioDictionary
{
  float seconds = 0.0f;

  //
  if(aAudioDictionary != nil)
  {
    //
    ALuint sourceId = [[aAudioDictionary objectForKey:@"SourceId"] intValue];
    if(sourceId != -1)
    {
      alGetSourcef(sourceId, AL_SEC_OFFSET, &seconds);
    }
  }
  
  return seconds;
}

- (void)printAudioDictionaryDetails
{
  for(int i = 0; i < MAX_AUDIO_SOUND_EFFECTS; i++)
  {
    NSMutableDictionary *audioDictionary = [m_SoundEffectsArray objectAtIndex:i];
    
    NSLog(@"AudioDictionary slot: %i", i);
    NSLog(@"Filename: %@", [audioDictionary objectForKey:@"Filename"]);
    NSLog(@"SourceId: %i", [[audioDictionary objectForKey:@"SourceId"] intValue]);
    NSLog(@"BufferId: %i", [[audioDictionary objectForKey:@"BufferId"] intValue]);
    NSLog(@"Format: %i", [[audioDictionary objectForKey:@"Format"] intValue]);
    NSLog(@"Size: %u", [[audioDictionary objectForKey:@"Size"] unsignedIntValue]);
    NSLog(@"SampleRate: %i", [[audioDictionary objectForKey:@"SampleRate"] intValue]);
    NSLog(@"IsPlaying: %@", [[audioDictionary objectForKey:@"IsPlaying"] boolValue] == YES ? @"YES" : @"NO");
  }
}

- (void)soundEffectCompletionCallback:(NSMutableDictionary *)aAudioDictionary
{
  if(aAudioDictionary != nil)
  {
    [aAudioDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"IsPlaying"];
  }
}

@end
