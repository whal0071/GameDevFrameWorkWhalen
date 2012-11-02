//
//  MenuSystem.m
//  GameDevFramework
//
//  Created by Bradley Flood on 12-08-27.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "MenuSystem.h"
#import "SplashViewController.h"
#import "MainMenuViewController.h"
#import "GameViewController.h"
#import "AudioManagerObjC.h"
#import "CreditsMenuViewController.h"
#import "HelpMenuViewController.h"
#import "PauseMenuViewController.h"

//Hidden methods, you shouldn't need to modify or call and of these methods
@interface MenuSystem()

- (void)transitionToViewController:(BaseViewController *)viewController callbackOnCompletion:(SEL)callbackOnCompletion;

- (void)loadGameViewControllers;
- (void)loadMenuViewControllers;

- (void)unloadGameViewControllers;
- (void)unloadMenuViewControllers;

@end


@implementation MenuSystem

//Synthesize the main menu property to the main menu member variable, you need to do this for all of your menus
@synthesize mainMenu = m_MainMenuViewController;
@synthesize creditsMenu = m_CreditsMenuViewController;
@synthesize game = m_GameViewController;
@synthesize helpMenu = m_HelpMenuViewController;
@synthesize pauseMenu = m_PauseMenuViewController;

- (void)dealloc
{
  //Unload the menu and game view controllers
  [self unloadMenuViewControllers];
  [self unloadGameViewControllers];
  
  //Set the active view controller to nil
  m_ActiveViewController = nil;
  
  //Release the previous view controllers array and set it to nil
  [m_PreviousViewControllers release];
  m_PreviousViewControllers = nil;

  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  //Allocate and initialize the splash view controller, this is the first view controller presented
  m_SplashViewController = [[SplashViewController alloc] initViewController:self];
  
  //Load the menu view controllers
  [self loadMenuViewControllers];
  
  //Set the SplashViewController as the active view controller
  m_ActiveViewController = m_SplashViewController;
  
  //Allocate and initialize the previous view controllers array
  m_PreviousViewControllers = [[NSMutableArray alloc] init];
  
  //Add the active view controller to the master view
  [self addChildViewController:m_ActiveViewController];
  [[self view] addSubview:[m_ActiveViewController view]];
}

- (void)didReceiveMemoryWarning
{
  //We received a memory warning, purge all unused sound effects
  [[AudioManagerObjC sharedInstance] cleanupSoundEffects];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
  //return UIInterfaceOrientationIsPortrait(aInterfaceOrientation); //Uncomment for portrait orientation
  return UIInterfaceOrientationIsLandscape(aInterfaceOrientation);  //Comment out if you want a portrait orientation
}

- (void)startGame
{
  //Load the game view controllers
  [self loadGameViewControllers];
  
  //Transition to the game view controller
  [self transitionToViewController:m_GameViewController callbackOnCompletion:@selector(unloadMenuViewControllers)];
}

- (void)endGame
{
  //Load the menu view controllers
  [self loadMenuViewControllers];
  
  //Transition back to the main menu view controller
  [self transitionToViewController:m_MainMenuViewController callbackOnCompletion:@selector(unloadGameViewControllers)];
}

- (void)pauseGame
{
  //TODO: Show Pause Menu
  
    
  //TODO: Pause the game
    [self transitionToViewController:(BaseViewController *)self.pauseMenu];
    [self.game pauseGame];
}

- (void)resumeGame
{
  //TODO: Hide Pause Menu
  
    //TODO: Resume the game
    [self transitionToPreviousViewController];
    [self.game resumeGame];
}

- (void)restartGame
{
    [self.game restartGame];
}

- (BaseViewController *)activeViewController
{
  return m_ActiveViewController;
}

- (BaseViewController *)previousViewController
{
  //Safety check the previous view controller array and return the first element in the array
  if([m_PreviousViewControllers count] > 0)
  {
    return [m_PreviousViewControllers objectAtIndex:0];
  }
  
  //If we got here, there aren't anymore view controller to go back to
  return nil;
}

- (void)transitionToViewController:(BaseViewController *)aViewController
{
  [self transitionToViewController:aViewController callbackOnCompletion:nil];
}

- (void)transitionToViewController:(BaseViewController *)aViewController callbackOnCompletion:(SEL)aCallbackOnCompletion
{
  //Safety check that the aViewController isn't nil and that it isn't the active view controller
  if(aViewController != nil && aViewController != m_ActiveViewController)
  {
    //Add the aViewController as a child to the master view controller
    [self addChildViewController:aViewController];
    [m_ActiveViewController willMoveToParentViewController:nil];

    //Begin the transition
    [self transitionFromViewController:m_ActiveViewController
                      toViewController:aViewController
                              duration:[aViewController transitionDuration]
                               options:[aViewController transitionOptions]
                            animations:^
                            {
                            
                            }
                            completion:^(BOOL finished)
                            {
                              //Remove the previously active view controller from the master view controller
                              [m_ActiveViewController removeFromParentViewController];
                              
                              //If the view controller we are transitioning to is the previous one then,
                              //remove the first view controller from the array
                              if(aViewController == [self previousViewController])
                              {
                                [m_PreviousViewControllers removeObjectAtIndex:0];
                              }
                              else
                              {
                                //If the callbackOnCompletion parameter is nil, add the active view controller
                                //to the previous view controllers array
                                if(aCallbackOnCompletion == nil)
                                {
                                  [m_PreviousViewControllers insertObject:m_ActiveViewController atIndex:0];
                                }
                              }
                              
                              //Purge the previous view controllers, the menu navigation is no longer applicable
                              if(aViewController == m_GameViewController || aViewController == m_MainMenuViewController)
                              {
                                [m_PreviousViewControllers removeAllObjects];
                              }
                              
                              //Set the new active view controller
                              m_ActiveViewController = aViewController;
                              
                              //Notify the new active view controller that it moved to the master view controller
                              [m_ActiveViewController didMoveToParentViewController:self];
                              
                              //If the callback completion selector isn't nil, call it
                              if(aCallbackOnCompletion != nil)
                              {
                                [self performSelector:aCallbackOnCompletion];
                              }
                            }
    ];
  }
}

- (void)transitionToPreviousViewController
{
  [self transitionToViewController:[self previousViewController]];
}

//In the method below, only add the view controllers that will be used in game, such as the game view controller,
//pause view controller, game over view controller, etc
- (void)loadGameViewControllers
{
  //Allocate and load the game view controller
  m_GameViewController = [[GameViewController alloc] initViewController:self];
    
    m_PauseMenuViewController = [[PauseMenuViewController alloc] initViewController:self];
}

//In the method below, only add the view controllers that aren't used in game (and used from the main menu), such
//as the main menu view controller, credits view controller, options view controller, etc
- (void)loadMenuViewControllers
{
  //Allocate and load the main menu view controller
  m_MainMenuViewController = [[MainMenuViewController alloc] initViewController:self];
    
    m_CreditsMenuViewController = [[CreditsMenuViewController alloc] initViewController:self];
    
    m_HelpMenuViewController = [[HelpMenuViewController alloc] initViewController:self];
}

//In the method below, only add the view controllers that were used in game, the view contollers below will be unloaded
//when the user ends the game
- (void)unloadGameViewControllers
{
  //The Game view controller needs to invalidate the game loop before we release it
  [m_GameViewController invalidateGameLoop];
  
  //Release the Game view controller and set it to nil
  [m_GameViewController release];
  m_GameViewController = nil;
    
    [m_PauseMenuViewController release];
    m_PauseMenuViewController = nil;
}

//In the method below, only add the view controllers that weren't used in game (and used from the main menu), the
//view contollers below will be unloaded when the user starts the game
- (void)unloadMenuViewControllers
{
  //Release the Splash view controller and set it to nil
  [m_SplashViewController release];
  m_SplashViewController = nil;

  //Release the Main menu view controller and set it to nil
  [m_MainMenuViewController release];
  m_MainMenuViewController = nil;
    
    [m_CreditsMenuViewController release];
    m_CreditsMenuViewController = nil;
    
    [m_HelpMenuViewController release];
    m_HelpMenuViewController = nil;
}

@end
