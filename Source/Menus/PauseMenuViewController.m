//
//  PauseMenuViewController.m
//  GameDevFramework
//
//  Created by Walter Whalen on 12-10-04.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "PauseMenuViewController.h"

@interface PauseMenuViewController ()

@end

@implementation PauseMenuViewController

@synthesize resumeButton = m_ResumeButton;
@synthesize restartButton = m_RestartButton;
@synthesize backToMenuButton = m_BackToMenuButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)resumeButtonTouchUpInside:(id)sender;
{
    //transition back to the previous view controller in this case
    [m_MenuSystem transitionToPreviousViewController];
}
-(IBAction)restartButtonTouchUpInside:(id)sender;
{
    [m_MenuSystem startGame];
}
-(IBAction)backToMenuButtonTouchUpInside:(id)sender;
{
    [m_MenuSystem endGame];
}



@end
