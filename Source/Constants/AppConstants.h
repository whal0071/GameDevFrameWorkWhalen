//
//  AppConstants.h
//  GameDevFramework
//
//  Created by Bradley Flood on 12-08-30.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#ifndef APP_CONSTANTS_H
#define APP_CONSTANTS_H

enum
{
	TOUCH_EVENT_BEGAN = 0,
  TOUCH_EVENT_ENDED,
  TOUCH_EVENT_MOVED,
  TOUCH_EVENT_CANCELED
};
typedef unsigned int TouchEvent;

enum
{
	FRAMES_PER_SECOND_60 = 1,
	FRAMES_PER_SECOND_30 = 2
};
typedef unsigned int FramePerSecond;

extern const FramePerSecond TARGET_FRAMES_PER_SECOND;

#endif
