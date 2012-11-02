//
//  MainMenuViewController.h
//  GameDevFramework
//
//  Created by Bradley Flood on 2012-09-06.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "BaseViewController.h"


@interface MainMenuViewController : BaseViewController
{
    UIButton *m_CreditsButton;
    UIButton *m_playButton;
    UIButton *m_helpButton;
    UIButton *m_gameCentreButton;
}

@property (nonatomic, retain) IBOutlet UIButton *creditsButton;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *helpButton;
@property (nonatomic, retain) IBOutlet UIButton *gameCentreButton;


-(IBAction)creditsButtonTouchUpInside:(id)sender;
-(IBAction)playButtonTouchUpInside:(id)sender;
-(IBAction)helpButtonTouchUpInside:(id)sender;
-(IBAction)gameCentreButtonTouchUpInside:(id)sender;
@end
