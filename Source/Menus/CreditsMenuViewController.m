//
//  CreditsMenuViewController.m
//  GameDevFramework
//
//  Created by Walter Whalen on 12-09-26.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "CreditsMenuViewController.h"

@interface CreditsMenuViewController ()

@end

@implementation CreditsMenuViewController

@synthesize creditsTitle = m_CreditsTitle;
@synthesize creditsRole = m_CreditsRole;
@synthesize creditsName = m_CreditsName;
@synthesize backButton = m_BackButton;
@synthesize sexyCustomButton = m_SexyCustomButton;

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
-(IBAction)sexyCustomButtonTouchUpInside:(id)sender
{
    UIImage *powderToastMan = [UIImage imageNamed:@"PowderToastMan.jpg"];
    
    [m_SexyCustomButton setBackgroundImage:powderToastMan forState:UIControlStateHighlighted];
}

- (NSUInteger)transitionOptions
{
    return UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve;
}

@end
