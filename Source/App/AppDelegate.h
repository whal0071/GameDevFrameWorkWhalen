//
//  AppDelegate.h
//  GameDevFramework
//
//  Created by Bradley Flood on 12-08-27.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *m_Window;
    MenuSystem *m_MenuSystem;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MenuSystem *menuSystem;

@end
