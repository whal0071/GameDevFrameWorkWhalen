//
//  Game.cpp
//  GameDevFramework
//
//  Created by Bradley Flood on 12-08-30.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#include "Game.h"
#include "GameObject.h"
#include "PhysicsObject.h"
#include "DeviceUtils.h"
#include "MathUtils.h"
#include "PhysicsEditorWrapper.h"

//including GameLayer in the cpp because i forward declare the class in the header
#include "GameLayer.h"


Game* Game::m_Instance = NULL;

Game* Game::getInstance()
{
    //Singleton design pattern ensures that there is only 1 instance of the game
    if(m_Instance == NULL)
    {
        m_Instance = new Game();
    }
    return m_Instance;
}

void Game::cleanupInstance()
{
    if(m_Instance != NULL)
    {
        delete m_Instance;
        m_Instance = NULL;
    }
}

Game::Game() :
m_LoadStep(0),
m_World(NULL)
{
    
}

Game::~Game()
{
    //TODO: Delete objects used in game here
    if(m_EnemyTexture != NULL)
    {
        delete m_EnemyTexture;
        m_EnemyTexture = NULL;
    }
    
    //Delete the debug draw instance
    if(m_DebugDraw != NULL)
    {
        delete m_DebugDraw;
        m_DebugDraw = NULL;
    }
    
    //Delete the Box2D world instance, MAKES SURE this is the last object deleted
    if(m_World != NULL)
    {
        //Destroy all the bodies in the world
        b2Body* body = m_World->GetBodyList();
        while(body != NULL)
        {
            //Destroy the body and get the next body (if there is one)
            b2Body* nextBody = body->GetNext();
            destroyPhysicsBody(body);
            body = nextBody;
        }
        
        //Finally delete the world
        delete m_World;
        m_World = NULL;
    }
}

void Game::load()
{
    switch(m_LoadStep)
    {
        case GAME_LOAD_STEP_REQUIRED:
        {
            //TODO: Load game content required for future load steps here
            
            //sets the background colour to grey.
            OpenGLRenderer::getInstance()->setBackgroundColor(OpenGLColorGray());
            
            m_EnemyTexture = new OpenGLTexture("Enemy");
            
            m_TouchLocationX = 0.0f;
            m_TouchLocationY = 0.0f;
            
            //Loading our game layer.
            m_GameLayer = new GameLayer();
        }
            break;
            
        case GAME_LOAD_BOX2D:
        {
            //Define the gravity vector.
            b2Vec2 gravity;
            gravity.Set(GAME_GRAVITY_X, GAME_GRAVITY_Y);
            
            //Construct the Box2d world object, which will holds and simulates the rigid bodies
            m_World = new b2World(gravity);
            m_World->SetContinuousPhysics(GAME_PHYSICS_CONTINUOUS_SIMULATION);
            
            //Set the world's contact listner
            m_World->SetContactListener(this);
            
#if DEBUG
            //Create the debug draw for Box2d
            m_DebugDraw = new b2DebugDraw(b2Helper::box2dRatio());
            
            //Set the debug draw flags
            uint32 flags = 0;
            flags += b2Draw::e_shapeBit;
            flags += b2Draw::e_jointBit;
            flags += b2Draw::e_centerOfMassBit;
            m_DebugDraw->SetFlags(flags);
            
            //Set the Box2d world debug draw instance
            m_World->SetDebugDraw(m_DebugDraw);
#endif
            
            //Define the ground body.
            b2BodyDef groundBodyDef;
            groundBodyDef.position.Set(0, 0); // bottom-left corner
            
            //Call the body factory which allocates memory for the ground body
            //from a pool and creates the ground box shape (also from a pool).
            //The body is also added to the world.
            b2Body* groundBody = m_World->CreateBody(&groundBodyDef);
            
            //Define the ground box shape.
            b2EdgeShape groundBox;
            groundBox.Set(b2Vec2(0,0), b2Vec2(b2Helper::screenSpaceToBox2dSpace(DeviceUtils::getScreenResolutionWidth()),0));
            groundBody->CreateFixture(&groundBox,0);
            
            //Load the sprite physics shapes
            PhysicsEditorCpp::addShapesFromPlist(GAME_PHYSICS_EDITOR_FILENAME);
        }
            break;
            
            //TODO: Load additional game content here, add additional steps in the GameConstants.h enum
            
        case GAME_LOAD_STEP_FINAL:
        {
            reset();
        }
            break;
            
        default:
        {
            
        }
            break;
    }
    
    m_LoadStep++;
}

void Game::update(double aDelta)
{
    //While the game is loading, the load method will be called once per update
    if(isLoading() == true)
    {
        load();
        return;
    }
    
    //Step the Box2D world this update cycle
    if(m_World != NULL)
    {
        m_World->Step(aDelta, GAME_PHYSICS_VELOCITY_ITERATIONS, GAME_PHYSICS_POSITION_ITERATIONS);
    }
    
    m_GameLayer->update(aDelta);
    
    //TODO: Add Game logic here
}

void Game::paint()
{
    //TODO: Render you game logic here
    m_GameLayer->paint();
    
    
    //Asks the OpenGLRenderer class to give us its single static instance (singleton)
    //With that instance we will be drawing a circle
    //coordinates in x (from left) y (from bottom) and radius
    OpenGLRenderer::getInstance()->drawCircle(100, 100, 50);
    
    //changes the line width to 5
    OpenGLRenderer::getInstance()->setLineWidth(5.0f);
    
    //Stores openglrenderer to a variable so we don't have to keep typing it.
    OpenGLRenderer *glRenderer = OpenGLRenderer::getInstance();
    
    //the fourth parameter chooses the number of verticies/segments (3 will make a triangle)
    //the fifth parameter chooses whether or not the shape will be filled.
    //(We can see that typing glRenderer instead of OpenGLRenderer::getInstance() will now do the same thing)
    glRenderer->drawCircle(250, 250, 50, 9, false);
    
    //Changes the background colour - to prevent flicker, this should be done inside the load function
    //glRenderer->setBackgroundColor(OpenGLColorGray());
    
    //Resets the line width
    OpenGLRenderer::getInstance()->resetLineWidth();
    //Will get the line width
    //OpenGLRenderer::getInstance()->getLineWidth();
    
    glRenderer->drawLine(50, 50, 300, 200);
    
    glRenderer->setForegroundColor(OpenGLColorBlue());
    glRenderer->drawRectangle(150, 150, 10, 20);
    
    glRenderer->setForegroundColor(OpenGLColorRGB(255, 0, 255));
    glRenderer->setPointSize(10);
    glRenderer->drawPoint(200, 200);
    glRenderer->resetPointSize();
    
    glRenderer->drawTexture(m_EnemyTexture, m_TouchLocationX - (m_EnemyTexture->getTextureWidth() / 2), m_TouchLocationY - (m_EnemyTexture->getTextureHeight() / 2));
    
    
#if DEBUG
    if(m_World != NULL)
    {
        m_World->DrawDebugData();
    }
#endif
}

void Game::touchEvent(TouchEvent aTouchEvent, float aLocationX, float aLocationY)
{
    //TODO: Handle touch events here
    
    //Create a switch with a cascading case (i.e. no breaks to make things smoother) to handle touch events and potebntially take two commands at once (i.e. touch began and moved)
    switch (aTouchEvent)
    {
        case TOUCH_EVENT_BEGAN:
            //break;  //We are cascading began and moved
        case TOUCH_EVENT_MOVED:
            m_TouchLocationX = aLocationX;
            m_TouchLocationY = aLocationY;
            break;
        case TOUCH_EVENT_CANCELED:
            break;
        case TOUCH_EVENT_ENDED:
            break;
            
        default:
            break;
    }
}

void Game::reset()
{
    //TODO: Reset all game content here
}

void Game::setGravity(b2Vec2 aGravity)
{
    m_World->SetGravity(aGravity);
}

b2Vec2 Game::getGravity()
{
    return m_World->GetGravity();
}

b2Body* Game::createPhysicsBody(const b2BodyDef* aBodyDefinition)
{
    return m_World->CreateBody(aBodyDefinition);
}

void Game::destroyPhysicsBody(b2Body* aBody)
{
    //Safety check that aBody isn't NULL
    if(aBody != NULL)
    {
        //Destroy all the fixtures attached to the body
        b2Fixture* fixture = aBody->GetFixtureList();
        while(fixture != NULL)
        {
            b2Fixture* nextFixture = fixture->GetNext();
            aBody->DestroyFixture(fixture);
            fixture = nextFixture;
        }
        
        //Destroy the body
        m_World->DestroyBody(aBody);
    }
}

bool Game::isLoading()
{
    return loadStep() < GAME_LOAD_STEP_COUNT;
}

int Game::loadStep()
{
    return m_LoadStep;
}

void Game::BeginContact(b2Contact* aContact)
{
    //TODO: Handle collision here
}

void Game::EndContact(b2Contact* aContact)
{
    //TODO: Handle collision here
}
