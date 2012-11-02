//
//  AudioManager.cpp
//  GameDevFramework
//
//  Created by Bradley Flood on 12-09-05.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#include "AudioManager.h"
#include "AudioManagerObjC.h"


namespace AudioManager
{
  void playMusic(const char* aFilename, bool aDoesRepeat)
  {
    NSString *filename = [[NSString alloc] initWithCString:aFilename encoding:NSUTF8StringEncoding];
    [[AudioManagerObjC sharedInstance] playMusic:filename doesRepeat:aDoesRepeat];
    [filename release];
  }
  
  void stopMusic()
  {
    [[AudioManagerObjC sharedInstance] stopMusic];
  }
  
  void pauseMusic()
  {
    [[AudioManagerObjC sharedInstance] pauseMusic];
  }
  
  void resumeMusic()
  {
    [[AudioManagerObjC sharedInstance] resumeMusic];
  }
  
  void setMusicVolume(float aVolume)
  {
    [[AudioManagerObjC sharedInstance] setMusicVolume:aVolume];
  }
  
  float getMusicVolume()
  {
    return [[AudioManagerObjC sharedInstance] musicVolume];
  }
  
  void playSoundEffect(const char* aFilename, bool aDoesRepeat)
  {
    NSString *filename = [[NSString alloc] initWithCString:aFilename encoding:NSUTF8StringEncoding];
    [[AudioManagerObjC sharedInstance] playSoundEffect:filename doesRepeat:aDoesRepeat];
    [filename release];
  }
  
  void stopSoundEffect(const char* aFilename)
  {
    NSString *filename = [[NSString alloc] initWithCString:aFilename encoding:NSUTF8StringEncoding];
    [[AudioManagerObjC sharedInstance] stopSoundEffect:filename];
    [filename release];
  }
  
  void setSoundEffectsVolume(float aVolume)
  {
    [[AudioManagerObjC sharedInstance] setSoundEffectVolume:aVolume];
  }
  
  float getSoundEffectsVolume()
  {
    return [[AudioManagerObjC sharedInstance] soundEffectVolume];
  }
}
  