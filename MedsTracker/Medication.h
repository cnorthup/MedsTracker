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


@end

@interface Medication (CoreDataGeneratedAccessors)

- (void)setLastTaken:(NSDate *)lastTaken;
- (void)setName:(NSString *)name;
- (void)setPillsLeft:(NSNumber *)pillsLeft;
- (void)setBarcode:(id)barcode;


@end