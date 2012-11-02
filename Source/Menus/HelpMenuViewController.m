//
//  HelpMenuViewController.m
//  GameDevFramework
//
//  Created by Walter Whalen on 12-10-10.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "HelpMenuViewController.h"

@interface HelpMenuViewController ()

@end

@implementation HelpMenuViewController

@synthesize backButton = m_BackButton;

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
-(IBAction)backButtonTouchUpInside:(id)sender
{
    
}
- (NSUInteger)transitionOptions
{
    return UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve;
}

@end
