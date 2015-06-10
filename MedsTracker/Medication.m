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
@dynamic timeBetweenDoses;
@dynamic dosage;


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
