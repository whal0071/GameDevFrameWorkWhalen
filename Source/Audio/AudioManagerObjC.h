//
//  AudioManagerObjC.h
//  GameDevFramework
//
//  Created by Bradley Flood on 12-09-05.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>


@interface AudioManagerObjC : NSObject
{
  AVAudioPlayer *m_AudioPlayer;
  ALCcontext *m_OpenALContext;
  
  NSMutableArray *m_SoundEffectsArray;
  
  float m_MusicVolume;
  float m_SoundEffectsVolume;
}

@property (nonatomic, assign) float musicVolume;
@property (nonatomic, assign) float soundEffectVolume;

+ (AudioManagerObjC *)sharedInstance;

- (void)playMusic:(NSString *)filename;
- (void)playMusic:(NSString *)filename doesRepeat:(BOOL)doesRepeat;
- (void)stopMusic;
- (void)pauseMusic;
- (void)resumeMusic;
- (BOOL)isMusicPlaying;

- (void)playSoundEffect:(NSString *)filename;
- (void)playSoundEffect:(NSString *)filename doesRepeat:(BOOL)doesRepeat;
- (void)stopSoundEffect:(NSString *)filename;
- (void)pauseSoundEffect:(NSString *)filename;
- (void)resumeSoundEffect:(NSString *)filename;
- (BOOL)isSoundEffectPlaying:(NSString *)filename;

- (void)cleanupSoundEffects;

@end
