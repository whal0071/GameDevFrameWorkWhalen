//
//  PauseMenuViewController.h
//  GameDevFramework
//
//  Created by Walter Whalen on 12-10-04.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "BaseViewController.h"

@interface PauseMenuViewController : BaseViewController
{
    UIButton *m_ResumeButton;
    UIButton *m_RestartButton;
    UIButton *m_BackToMenuButton;
}
@property (nonatomic, retain) IBOutlet UIButton *resumeButton;
@property (nonatomic, retain) IBOutlet UIButton *restartButton;
@property (nonatomic, retain) IBOutlet UIButton *backToMenuButton;

-(IBAction)resumeButtonTouchUpInside:(id)sender;
-(IBAction)restartButtonTouchUpInside:(id)sender;
-(IBAction)backToMenuButtonTouchUpInside:(id)sender;


@end
