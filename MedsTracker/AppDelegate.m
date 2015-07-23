//
//  AppDelegate.m
//  MedsTracker
//
//  Created by Charles Northup on 5/12/15.
//  Copyright (c) 2015 RogueNotion. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "Medication.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self scheduleNotification];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSLog(@"tomorrow mid %@", [self tomorrowMidnightDateGMT]);
    NSLog(@"today mid %@", [self todayMidnightDateGMT]);


}

-(NSDate*)tomorrowMidnightDateGMT
{
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 1;
    NSDate* selectedDate = [NSDate new];
    NSDate *newDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                   toDate: selectedDate
                                                                  options:0];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* newDateComponents = [calendar components:( NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay ) fromDate:newDate];
    newDateComponents.second = 0;
    [newDateComponents setHour:0];
    newDateComponents.minute = 0;
    
    NSDate* gmtMidnight = [[NSCalendar currentCalendar] dateFromComponents:newDateComponents];
    return gmtMidnight;
}

-(NSDate*)todayMidnightDateGMT
{
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 0;
    NSDate* selectedDate = [NSDate new];
    NSDate *newDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                   toDate: selectedDate
                                                                  options:0];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* newDateComponents = [calendar components:( NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay ) fromDate:newDate];
    newDateComponents.second = 0;
    [newDateComponents setHour:0];
    newDateComponents.minute = 0;
    
    NSDate* gmtMidnight = [[NSCalendar currentCalendar] dateFromComponents:newDateComponents];
    return gmtMidnight;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

- (void)scheduleNotification
{
    //NSLog(@"%@", self.managedObjectContext);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medication" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    NSError *error = nil;
    [aFetchedResultsController performFetch:&error];

    for (Medication* med in [aFetchedResultsController fetchedObjects])
    {
        for (int x = 0; x < med.timeTakePillArray.count; x++)
        {
            double timeInteveral = [[med.timeTakePillArray objectAtIndex:x] doubleValue];
            if ([self checkIfTimeHasAlreadyPassed:timeInteveral] == YES)
            {
                if ([med.takenPillsArray objectAtIndex:x] == YES)
                {
                    NSLog(@"took this pill today");
                    return;
                }
                else
                {
                    UILocalNotification *locNot = [[UILocalNotification alloc] init];
                    locNot.alertAction = @"Scan";
                    locNot.hasAction = YES;
                    locNot.alertBody = [NSString stringWithFormat:@"Time to take %@", med.name];
                    locNot.timeZone = [NSTimeZone systemTimeZone];
                    locNot.fireDate = [NSDate dateWithTimeInterval:(timeInteveral) sinceDate:[self todayMidnightDateGMT]];
                    locNot.alertTitle = @"Medication";
                    locNot.soundName = UILocalNotificationDefaultSoundName;
                    [[UIApplication sharedApplication] scheduleLocalNotification: locNot];
                    
                }
            }
            else
            {
                UILocalNotification *locNot = [[UILocalNotification alloc] init];
                locNot.alertAction = @"Scan";
                locNot.hasAction = YES;
                locNot.alertBody = [NSString stringWithFormat:@"Time to take %@", med.name];
                locNot.timeZone = [NSTimeZone systemTimeZone];
                locNot.fireDate = [NSDate dateWithTimeInterval:(timeInteveral) sinceDate:[self todayMidnightDateGMT]];
                locNot.alertTitle = @"Medication";
                locNot.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification: locNot];
                
                UILocalNotification *locNotTomorrow = [[UILocalNotification alloc] init];
                locNotTomorrow.alertAction = @"Scan";
                locNotTomorrow.hasAction = YES;
                locNotTomorrow.alertBody = [NSString stringWithFormat:@"Time to take %@", med.name];
                locNotTomorrow.timeZone = [NSTimeZone systemTimeZone];
                locNotTomorrow.fireDate = [NSDate dateWithTimeInterval:(timeInteveral) sinceDate:[self tomorrowMidnightDateGMT]];
                locNotTomorrow.alertTitle = @"Medication";
                locNotTomorrow.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification: locNotTomorrow];
                
                
            }
        }

    }
}

-(BOOL)checkIfTimeHasAlreadyPassed:(double)timeInteverval
{
    NSDate* medicineTime = [[self todayMidnightDateGMT] dateByAddingTimeInterval:timeInteverval];
    NSDate* now = [NSDate new];
    if ([medicineTime compare:now] == NSOrderedDescending) {
        NSLog(@"MedicineTime is later than now");
        return YES;
    } else if ([medicineTime compare:now] == NSOrderedAscending) {
        NSLog(@"medicineTime is earlier than now");
        return NO;
    } else {
        NSLog(@"dates are the same");
        return YES;
    }
}


-(NSDate*)addTimeToDate:(NSDate*)date seconds:(NSInteger*)seconds hours:(NSInteger*)hours days:(NSInteger*)days
{
    NSDate* newDate = date;
    return newDate;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.james.MedsTracker" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MedsTracker" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MedsTracker.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
