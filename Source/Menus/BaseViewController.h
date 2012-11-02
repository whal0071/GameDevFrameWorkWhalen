//
//  BaseViewController.h
//  GameDevFramework
//
//  Created by Bradley Flood on 12-08-30.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "MenuConstants.h"


//Every menu should inherit from this class, it allows the menu system to handle menu transitions
@interface BaseViewController : UIViewController
{
  MenuSystem *m_MenuSystem;
}

//Initialization method, takes one parameter of type MenuSystem*
- (id)initViewController:(MenuSystem *)menuSystem;

//Calling this method will return to the previous ViewController (if there is one)
- (IBAction)backAction:(id)sender;

//Override these methods for cutom transisiton duration and options
- (NSTimeInterval)transitionDuration;
- (NSUInteger)transitionOptions;

@end
