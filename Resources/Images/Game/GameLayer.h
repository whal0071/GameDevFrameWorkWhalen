//
//  GameLayer.h
//  GameDevFramework
//
//  Created by Walter Whalen on 12-11-01.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#ifndef __GameDevFramework__GameLayer__
#define __GameDevFramework__GameLayer__

#include <iostream>
#include "GameObject.h"

class GameLayer: public GameObject
{
    //verbs -what i want my class to do
    //draw
    //update
public:
    GameLayer();
    ~GameLayer();
    
    //creating our overriding methods
    //virtual so that our subclasses can overrride them
    
    virtual void update(float delta);
    virtual void paint();
    virtual const char* getType();
    
    //nouns - what i want my class to have
    //have a location
    //have a texture
protected:
    OpenGLTexture *m_FollowingParallaxTexture;
    
    OpenGLTexture *m_ParallaxTextures[2];
    //vector<OpenGLTexture *>m_ParallaxTextures;
    //OpenGLTexture **m_ParallaxTextures;
    
    // TODO: include extra location variables if necessary
    
    
};

#endif
