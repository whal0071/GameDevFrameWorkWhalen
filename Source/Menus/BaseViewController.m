//
//  BaseViewController.m
//  GameDevFramework
//
//  Created by Bradley Flood on 12-08-30.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "BaseViewController.h"



@implementation BaseViewController

- (id)initViewController:(MenuSystem *)aMenuSystem
{
  if((self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]]) != nil)
  {
    m_MenuSystem = aMenuSystem;
  }
  
  return self;
}

- (void)dealloc
{
  m_MenuSystem = nil;
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)aAnimated
{
  [super viewWillAppear:aAnimated];
}

- (void)viewWillDisappear:(BOOL)aAnimated
{
  [super viewWillDisappear:aAnimated];
}

- (IBAction)backAction:(id)aSender
{
  [m_MenuSystem transitionToPreviousViewController];
}

- (NSTimeInterval)transitionDuration
{
  return DEFAULT_TRANSITION_DURATION;
}

- (NSUInteger)transitionOptions
{
  return UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone;
}

@end
