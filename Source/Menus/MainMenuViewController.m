//
//  MainMenuViewController.m
//  GameDevFramework
//
//  Created by Bradley Flood on 2012-09-06.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "MainMenuViewController.h"

@implementation MainMenuViewController

@synthesize creditsButton = m_CreditsButton;
@synthesize playButton = m_playButton;
@synthesize helpButton = m_helpButton;
@synthesize gameCentreButton = m_gameCentreButton;

- (void)viewDidLoad
{
  [super viewDidLoad];
    //after this point, the view from the XIB (interface builder file) are loaded
    
    
    //we're going to change our buttons here, because its in our 'viewdidload' that
    //our button is loaded [our view is loaded]
    
    //we are going to use UIFonts factory methodcalled viewdidload
    //UIFont *pocket = [UIFont fontWithName:@"pocket"  size:20];
    
    //setting the font using the setter method
    //[m_playButton.titleLabel setFont:pocket];
    
    //setting the font similar to how its done in c#
    //m_playButton.titleLabel.font = metalLord;
    
    //[m_playButton titleLabel].font = pocket;
    
    //[[m_playButton titleLabel] setFont:pocket];
    
}

- (NSUInteger)transitionOptions
{
  return UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve;
}

-(IBAction)creditsButtonTouchUpInside:(id)sender;
{
    [m_MenuSystem transitionToViewController:(BaseViewController *)m_MenuSystem.creditsMenu];
}
-(IBAction)playButtonTouchUpInside:(id)sender;
{
    [m_MenuSystem startGame];
}
-(IBAction)helpButtonTouchUpInside:(id)sender
{
    [m_MenuSystem transitionToViewController:(BaseViewController *)m_MenuSystem.helpMenu];
}


@end
