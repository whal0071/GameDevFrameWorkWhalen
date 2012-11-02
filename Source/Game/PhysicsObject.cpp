//
//  PhysicsObject.cpp
//  GameDevFramework
//
//  Created by Bradley Flood on 2012-10-05.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#include "PhysicsObject.h"
#include "MathUtils.h"
#include "PhysicsEditorWrapper.h"

PhysicsObject::PhysicsObject() : GameObject(),
  m_PhysicsBody(NULL)
{

}

PhysicsObject::~PhysicsObject()
{
  if(m_PhysicsBody != NULL)
  {
    Game::getInstance()->destroyPhysicsBody(m_PhysicsBody);
    m_PhysicsBody = NULL;
  }
}

void PhysicsObject::update(double aDelta)
{
  GameObject::update(aDelta);
}

void PhysicsObject::paint()
{
  if(m_Texture != NULL)
  {
    OpenGLRenderer::getInstance()->drawTexture(m_Texture, getX(), getY(), getAngle());
  }
}

void PhysicsObject::reset()
{
  setPosition(0.0f, 0.0f);
  setAngle(0.0f);
}

void PhysicsObject::setX(float aX)
{
  GameObject::setX(aX);
  if(m_PhysicsBody != NULL)
  {
    m_PhysicsBody->SetAwake(true);
    m_PhysicsBody->SetTransform(b2Vec2(b2Helper::screenSpaceToBox2dSpace(m_X), m_PhysicsBody->GetPosition().y), m_PhysicsBody->GetAngle());
  }
}

void PhysicsObject::setY(float aY)
{
  GameObject::setY(aY);
  if(m_PhysicsBody != NULL)
  {
    m_PhysicsBody->SetAwake(true);
    m_PhysicsBody->SetTransform(b2Vec2(m_PhysicsBody->GetPosition().x, b2Helper::screenSpaceToBox2dSpace(m_Y)), m_PhysicsBody->GetAngle());
  }
}

void PhysicsObject::setAngle(float aAngle)
{
  if(m_PhysicsBody != NULL)
  {
    m_PhysicsBody->SetAwake(true);
    m_PhysicsBody->SetTransform(b2Vec2(m_PhysicsBody->GetPosition().x, m_PhysicsBody->GetPosition().y), MathUtils::degressToRadians(aAngle));
  }
}

float PhysicsObject::getX()
{
  if(m_PhysicsBody != NULL)
  {
    return b2Helper::box2dSpaceToScreenSpace(m_PhysicsBody->GetPosition().x);
  }
  
  return GameObject::getX();
}

float PhysicsObject::getY()
{
  if(m_PhysicsBody != NULL)
  {
    return b2Helper::box2dSpaceToScreenSpace(m_PhysicsBody->GetPosition().y);
  }
  
  return GameObject::getY();
}

float PhysicsObject::getAngle()
{
  if(m_PhysicsBody != NULL)
  {
    return MathUtils::radiansToDegrees(m_PhysicsBody->GetAngle());
  }
  
  return 0.0f;
}
