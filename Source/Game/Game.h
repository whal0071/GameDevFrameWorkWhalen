//
//  Game.h
//  GameDevFramework
//
//  Created by Bradley Flood on 12-08-30.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#ifndef GAME_H
#define GAME_H

#include "Constants.h"
#include "OpenGL.h"
#include "Box2D.h"

class GameLayer;

class Game : public b2ContactListener
{
public:
    //Singleton instance methods
    static Game* getInstance();
    static void cleanupInstance();
    
    //Update, paint and touch event (lifecycle) methods
    void update(double delta);
    void paint();
    void touchEvent(TouchEvent touchEvent, float locationX, float locationY);
    
    //Reset methods
    void reset();
    
    //Conveniance methods to get and set the world's gravity
    void setGravity(b2Vec2 gravity);
    b2Vec2 getGravity();
    
    //
    b2Body* createPhysicsBody(const b2BodyDef* bodyDefinition);
    void destroyPhysicsBody(b2Body* body);
    
    //Loading methods
    bool isLoading();
    int loadStep();
    
private:
    //Private constructor and destructor ensures the singleton instance
    Game();
    ~Game();
    
    //Load method, called once every load step
    void load();
    
    //Collision callback methods
    void BeginContact(b2Contact* contact);
    void EndContact(b2Contact* contact);
    
    //Singleton instance static member variable
    static Game* m_Instance;
    
    //Load step member variable
    int m_LoadStep;
    
    //Box2D world pointer
    b2World* m_World;
    
    //Game Layer
    GameLayer *m_GameLayer;
    
    //Box2D debug draw pointer
    b2DebugDraw* m_DebugDraw;
    
    //Creating our temporary texture (remove after class!)
    OpenGLTexture *m_EnemyTexture;
    
    //variables that I can store my touch locations in.
    float m_TouchLocationX;
    float m_TouchLocationY;
};

#endif
