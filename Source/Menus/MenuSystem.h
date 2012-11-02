//
//  MenuSystem.h
//  GameDevFramework
//
//  Created by Bradley Flood on 12-08-27.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//


@class BaseViewController;
@class SplashViewController;
@class MainMenuViewController;
@class GameViewController;
@class CreditsMenuViewController;
@class HelpMenuViewController;
@class PauseMenuViewController;

//Menu System handles which view controller is currently on screen and
//handles transitioning to new and previous view controllers
@interface MenuSystem : UIViewController
{
  //Member variables to keep track of the active and previous view controllers
  BaseViewController* m_ActiveViewController;
  NSMutableArray* m_PreviousViewControllers;
  
  //View controllers that are used in game, and any additional view controllers here
  SplashViewController* m_SplashViewController;
  MainMenuViewController* m_MainMenuViewController;
  GameViewController* m_GameViewController;
  CreditsMenuViewController *m_CreditsMenuViewController;
    HelpMenuViewController *m_HelpMenuViewController;
    PauseMenuViewController *m_PauseMenuViewController;
}

//All Menus should have a readonly property, add them below main menu
@property (nonatomic, retain, readonly) MainMenuViewController *mainMenu;
@property (nonatomic, retain, readonly) CreditsMenuViewController *creditsMenu;
@property (nonatomic, retain, readonly) GameViewController *game;
@property (nonatomic, retain, readonly) HelpMenuViewController *helpMenu;
@property (nonatomic, retain, readonly) PauseMenuViewController *pauseMenu;

//Game methods used to start, end, pause and resume the game
- (void)startGame;
- (void)endGame;
- (void)pauseGame;
- (void)resumeGame;

//Active and previous view controller conveniance methods
- (BaseViewController *)activeViewController;
- (BaseViewController *)previousViewController;

//Transition methods
- (void)transitionToViewController:(BaseViewController *)viewController;
- (void)transitionToPreviousViewController;

@end
