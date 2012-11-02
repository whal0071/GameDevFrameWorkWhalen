//
//  CreditsMenuViewController.h
//  GameDevFramework
//
//  Created by Walter Whalen on 12-09-26.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "BaseViewController.h"

@interface CreditsMenuViewController : BaseViewController
{
    UILabel *m_CreditsTitle;
    UILabel *m_CreditsRole;
    UILabel *m_CreditsName;
    
    UIButton *m_BackButton;
    UIButton *m_SexyCustomButton;
}

//Properties gives you getters and setters.
@property (nonatomic, retain) IBOutlet UILabel *creditsTitle;
@property (nonatomic, retain) IBOutlet UILabel *creditsRole;
@property (nonatomic, retain) IBOutlet UILabel *creditsName;

@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *sexyCustomButton;

//void function (paameter1, parameter 2)

//IBAction is something you do, handles an event
- (IBAction)sexyCustomButtonTouchUpInside:(id)sender;
                   

@end
