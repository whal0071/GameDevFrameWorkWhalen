//
//  GameLayer.cpp
//  GameDevFramework
//
//  Created by Walter Whalen on 12-11-01.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#include "GameLayer.h"

GameLayer::GameLayer()
{
    m_X = 0.0f;
    m_Y = 0.0f;
    //m_FollowingParallaxTexture = NULL;
    
    m_ParallaxTextures[0] = new OpenGLTexture("Back1");
    m_ParallaxTextures[1] = new OpenGLTexture("Back2");
    
    m_Texture = m_ParallaxTextures[0];
    m_FollowingParallaxTexture = m_ParallaxTextures[1];
    
}

GameLayer::~GameLayer()
{
    /*delete m_FollowingParallaxTexture;
    m_FollowingParallaxTexture = NULL;
    
    delete m_Texture;
    m_Texture = NULL;*/
    
    int sizeOfTextureArray = sizeof(m_ParallaxTextures);
    int sizeOfDataType = sizeof(OpenGLTexture *);
    
    int numberOfElements = sizeOfTextureArray / sizeOfDataType;
    
    for (int i = 0; i <numberOfElements; i++)
    {
        if(m_ParallaxTextures[i] != NULL)
        {
            //delete memory if it exists
            delete m_ParallaxTextures[i];
            //set it to NULL so that we dont try and delete it again
            m_ParallaxTextures[i] = NULL;
        }
    }
}

void GameLayer:: update(float delta)
{
    //change the textures location along the screen
    m_X -= 5.0f;
    
    /*TODO: checking to see if we need to change the location
     of the second texture*/
    if(m_X + m_Texture->getTextureWidth() <=0)
    {
        m_X += m_Texture->getTextureWidth();
        
        int sizeOfTextureArray = sizeof(m_ParallaxTextures);
        int sizeOfDataType = sizeof(OpenGLTexture *);
        
        int numberOfElements = sizeOfTextureArray / sizeOfDataType;
        
        //switch the textures
        m_Texture = m_FollowingParallaxTexture;
        m_FollowingParallaxTexture = m_ParallaxTextures[rand() % numberOfElements];
    }
}

void GameLayer:: paint()
{
    OpenGLRenderer::getInstance()->drawTexture(m_Texture, m_X, m_Y);
    OpenGLRenderer::getInstance()->drawTexture(m_FollowingParallaxTexture, m_X + m_Texture->getTextureWidth(), m_Y);
}

const char* GameLayer::getType()
{
    return "GameLayer";
}