//
//  UITabBarController+MedsTabController.h
//  MedsTracker
//
//  Created by Charles Northup on 3/16/16.
//  Copyright © 2016 RogueNotion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MedsTabController : UITabBarController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
