//
//  PhysicsObject.h
//  GameDevFramework
//
//  Created by Bradley Flood on 2012-10-05.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#ifndef PHYSICS_OBJECT_H
#define PHYSICS_OBJECT_H

#include "GameObject.h"
#include "Box2D.h"
#include "PhysicsEditorWrapper.h"


class PhysicsObject : public GameObject
{
public:
  PhysicsObject();
  virtual ~PhysicsObject();

  virtual const char* getType() = 0;
  
  virtual void update(double delta);
  virtual void paint();
  
  virtual void reset();
  
  virtual void setX(float x);
  virtual void setY(float y);
  virtual void setAngle(float angle);
  
  virtual float getX();
  virtual float getY();
  virtual float getAngle();
  
protected:
  b2Body* m_PhysicsBody;
};

#endif
