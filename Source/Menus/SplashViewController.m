//
//  SplashViewController.m
//  GameDevFramework
//
//  Created by Bradley Flood on 12-08-30.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "SplashViewController.h"


@implementation SplashViewController

@synthesize algonquinLogo = m_AlgonquinLogo;

- (void)dealloc
{
  //Release the algonquin logo, and set the pointer to nil
  [m_AlgonquinLogo release];
  m_AlgonquinLogo = nil;
  [super dealloc];
}

- (void)viewWillAppear:(BOOL)aAnimated
{
  //After a delay, tell the Menu System to transition to the Main Menu
  [m_MenuSystem performSelector:@selector(transitionToViewController:) withObject:[m_MenuSystem mainMenu] afterDelay:SPLASH_TRANSITION_DELAY];
  
  [super viewWillAppear:aAnimated];
}

@end
