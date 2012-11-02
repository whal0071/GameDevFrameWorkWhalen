//
//  GameViewController.m
//  GameDevFramework
//
//  Created by Bradley Flood on 12-08-30.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "GameViewController.h"
#import "Game.h"
#import "OpenGLView.h"
#import "OpenGLRenderer.h"
#import "Constants.h"
#import "AudioManagerObjC.h"
#import "DeviceUtils.h"
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>


@interface GameViewController()

- (void)handleTouchEvent:(UITouch *)aTouch event:(TouchEvent)aTouchEvent;

@end


@implementation GameViewController

@synthesize openGLView = m_OpenGLView;
@synthesize pauseButton = m_PauseButton;

- (id)initViewController:(MenuSystem *)aMenuSystem
{
    if((self = [super initViewController:aMenuSystem]) != nil)
    {
        //Create the OpenGL context, initializing it with desired rendering API
        m_OpenGLContext = [[EAGLContext alloc] initWithAPI:OPENGL_RENDERING_API];
        if(m_OpenGLContext == nil || [EAGLContext setCurrentContext:m_OpenGLContext] == NO)
        {
            [self release];
            return nil;
        }
    }
    return self;
}

- (void)dealloc
{

  //Cleanup the Game's instance
  Game::cleanupInstance();
  
  //Cleanup the Loading screen
  //LoadingScreen::cleanupInstance();

  //Cleanup the OpenGLRender instance
  OpenGLRenderer::cleanupInstance();

  //Release the CADisplayLink
  [m_DisplayLink release];

  //Release the rest of the objects
  [m_OpenGLContext release];
  [m_OpenGLView release];
  [super dealloc];
}

- (void)viewDidLoad
{
    //Set the OpenGL view's context, this allows us to draw to the screen with OpenGL
    [m_OpenGLView setOpenGLContext:m_OpenGLContext];
    
    SEL gameLoopSelector = @selector(gameLoop);
    /*
     This method create a display link for us. It requires an object (id - Target)
     that we will be calling a selectore (SEL- Selector:)on.A selector is a
     method that we can store/pass around as a variable.
     
     We are creating a display linbk because it will loop after a given time, and call the function
     as often as desired, thus creating our game loop.
     */
    
    m_DisplayLink = [[CADisplayLink displayLinkWithTarget:self selector:gameLoopSelector] retain];
    
    //[m_DisplayLink retain];
    
    //setting the interval so that it will update once every frame.(1/60 seconds)
    
    //m_DisplayLink.frameInterval = 1;
    //[m_DisplayLink setFrameInterval:1];
    
    [m_DisplayLink setFrameInterval:TARGET_FRAMES_PER_SECOND];
    
    m_IsPaused = NO;
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)aAnimated
{
    //Add to the run loop so that the system loop will handle the display link for
    //us. We do this when the viw is ready to appear so that the game only runs when the view is visible
    //NSRunLoop
    
    [m_DisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [super viewWillAppear:aAnimated];
}

-(void)viewWillDisappear:(BOOL)aAnimated
{
    [m_DisplayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [super viewWillDisappear:aAnimated];
}

- (void)invalidateGameLoop
{
    //invalidate the display link, releases the target for us (GameViewController) so
    //that it doesnt hang around in memory
    
    [m_DisplayLink invalidate];
    [m_DisplayLink release];
    m_DisplayLink = nil;
    
}

-(void)pauseGame
{
    m_IsPaused = YES;
}

-(void)resumeGame
{
    m_IsPaused = NO;
}

-(void)restartGame
{
    m_IsPaused = NO;
}

-(IBAction)pauseButtonTouchUpInside:(id)sender;
{
    [m_MenuSystem pauseGame];
}

- (void)pause
{
  m_IsPaused = YES;
}

- (void)resume
{
  m_IsPaused = NO;
}

- (void)reset
{
  Game::getInstance()->reset();
}

- (IBAction)pauseAction:(id)sender
{
  [m_MenuSystem pauseGame];
}

- (void)gameLoop
{
  if(m_IsPaused == NO)
  {
    //Calculate the delta time
    int interval = [m_DisplayLink frameInterval];
    double duration = [m_DisplayLink duration];
    double delta = duration * interval;
    
    //Update the game
    Game::getInstance()->update(delta);
    
    //If loading, update the loading screen
    if(Game::getInstance()->isLoading() == true)
    {
      //LoadingScreen::getInstance()->update(delta);
    }
    
    //Clear the OpenGL buffer
    OpenGLRenderer::getInstance()->clear();
    
    //Begin drawing to OpenGL
    [m_OpenGLView beginDraw];
    
    //If the game is loading, draw the loading screen, otherwise draw the game
    if(Game::getInstance()->isLoading() == true)
    {
      //LoadingScreen::getInstance()->paint();
    }
    else
    {
      Game::getInstance()->paint();
    }
    
    //Finish OpenGL drawing
    [m_OpenGLView endDraw];
  }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self handleTouchEvent:[touches anyObject] event:TOUCH_EVENT_BEGAN];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self handleTouchEvent:[touches anyObject] event:TOUCH_EVENT_ENDED];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self handleTouchEvent:[touches anyObject] event:TOUCH_EVENT_CANCELED];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self handleTouchEvent:[touches anyObject] event:TOUCH_EVENT_MOVED];
}

- (void)handleTouchEvent:(UITouch *)aTouch event:(TouchEvent)aTouchEvent
{
  if(m_IsPaused == NO)
  {  
    CGPoint location = [aTouch locationInView:[self view]];
    location.x *= DeviceUtils::getContentScaleFactor();
    location.y *= DeviceUtils::getContentScaleFactor();
    Game::getInstance()->touchEvent(aTouchEvent, location.x, DeviceUtils::getScreenResolutionHeight() - location.y);
  }
}

@end
