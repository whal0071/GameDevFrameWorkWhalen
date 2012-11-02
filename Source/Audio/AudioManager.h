//
//  AudioManager.h
//  GameDevFramework
//
//  Created by Bradley Flood on 12-09-05.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#ifndef AUDIO_MANAGER_H
#define AUDIO_MANAGER_H

namespace AudioManager
{
  void playMusic(const char* filename, bool doesRepeat = true);
  void stopMusic();
  void pauseMusic();
  void resumeMusic();
  
  void setMusicVolume(float volume);
  float getMusicVolume();
  
  void playSoundEffect(const char* filename, bool doesRepeat = false);
  void stopSoundEffect(const char* filename);
  
  void setSoundEffectsVolume(float volume);
  float getSoundEffectsVolume();
}

#endif
