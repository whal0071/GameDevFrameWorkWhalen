//
//  GameViewController.h
//  GameDevFramework
//
//  Created by Bradley Flood on 12-08-30.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "BaseViewController.h"


@class EAGLContext;
@class CADisplayLink;
@class OpenGLView;

@interface GameViewController : BaseViewController
{
    EAGLContext *m_OpenGLContext;
    OpenGLView *m_OpenGLView;
    CADisplayLink *m_DisplayLink;
    
    UIButton *m_PauseButton;
    BOOL m_IsPaused;
}

@property (nonatomic, retain) IBOutlet OpenGLView *openGLView;
@property (nonatomic, retain) IBOutlet UIButton *pauseButton;

- (void)gameLoop;
- (void)invalidateGameLoop;
- (void)pause;
- (void)resume;
- (void)reset;

- (IBAction)pauseAction:(id)sender;

-(void)pauseGame;
-(void)resumeGame;
-(void)restartGame;

//function/method declaration for an IBAction
-(IBAction)pauseButtonTouchUpInside:(id)sender;

@end
