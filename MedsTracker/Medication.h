//
//  Medication.h
//  MedsTracker
//
//  Created by Charles Northup on 5/12/15.
//  Copyright (c) 2015 RogueNotion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Medication : NSManagedObject

@property (nonatomic, retain) NSDate * lastTaken;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pillsLeft;
@property (nonatomic, retain) id barcode;
@property (nonatomic) double dosage;


@property (nonatomic, retain) id timeSeperatingDoses;
@property (nonatomic, retain) NSDate* nextPillTime;
@property (nonatomic) double timeBetweenReminder;
@property (nonatomic) double timesPerDay;

@property (nonatomic, retain) NSArray* timeTakePillArray;
@property (nonatomic, retain) NSArray* takenPillsArray;




@end

@interface Medication (CoreDataGeneratedAccessors)

- (void)setLastTaken:(NSDate *)lastTaken;
- (void)setName:(NSString *)name;
- (void)setPillsLeft:(NSNumber *)pillsLeft;
- (void)setBarcode:(id)barcode;
- (void)setDosage:(double)dosage;
- (void)setPillTimes:(id)pillTimes;
- (void)setNextPillTime:(NSDate *)nextPillTime;
- (void)setTimeBetweenReminder:(double)timeBetweenReminder;


- (void)justTookPills;
- (NSDate*)getDateWithCurrentTimeZone:(NSDate*)date;


@end