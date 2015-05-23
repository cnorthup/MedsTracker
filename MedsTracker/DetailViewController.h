//
//  DetailViewController.h
//  MedsTracker
//
//  Created by Charles Northup on 5/12/15.
//  Copyright (c) 2015 RogueNotion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
//#import <CoreData/CoreData.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) MasterViewController* source;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

