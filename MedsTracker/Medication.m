//
//  Medication.m
//  MedsTracker
//
//  Created by Charles Northup on 5/12/15.
//  Copyright (c) 2015 RogueNotion. All rights reserved.
//

#import "Medication.h"


@implementation Medication

@dynamic lastTaken;
@dynamic name;
@dynamic pillsLeft;
@dynamic barcode;
@dynamic dosage;

// needs alot of work, most likely throwing these out
@dynamic timeSeperatingDoses;
@dynamic nextPillTime;
@dynamic timeBetweenReminder;
@dynamic timesPerDay;

@dynamic timeTakePillArray;
@dynamic takenPillsArray;



-(void)justTookPills
{
    [self setLastTaken:[self getDateWithCurrentTimeZone:[NSDate new]]];
}

- (NSDate*)getDateWithCurrentTimeZone:(NSDate*)date
{
    NSTimeInterval timeZoneSeconds = [[NSTimeZone systemTimeZone] secondsFromGMT];
    NSDate *dateInLocalTimezone = [date dateByAddingTimeInterval:timeZoneSeconds];
    return dateInLocalTimezone;
}



@end
