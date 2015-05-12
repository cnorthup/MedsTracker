//
//  NewPillViewController.h
//  MedsTracker
//
//  Created by Charles Northup on 5/12/15.
//  Copyright (c) 2015 RogueNotion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Medication.h"

@interface NewPillViewController : UIViewController

@property (strong, nonatomic) Medication* detailItem;

@end