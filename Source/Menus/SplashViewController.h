//
//  SplashViewController.h
//  GameDevFramework
//
//  Created by Bradley Flood on 12-08-30.
//  Copyright (c) 2012 Algonquin College. All rights reserved.
//

#import "BaseViewController.h"


@interface SplashViewController : BaseViewController
{
  UIImageView* m_AlgonquinLogo;
}

@property (nonatomic, retain) IBOutlet UIImageView *algonquinLogo;

@end
