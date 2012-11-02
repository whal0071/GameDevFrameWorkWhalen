//
//  HelpMenuViewController.h
//  GameDevFramework
//
//  Created by Walter Whalen on 12-10-10.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "BaseViewController.h"

@interface HelpMenuViewController : BaseViewController
{
    UIButton *m_BackButton;

}

@property (nonatomic, retain) IBOutlet UIButton *backButton;

-(IBAction)backButtonTouchUpInside:(id)sender;

@end
