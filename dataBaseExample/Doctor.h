//
//  Doctor.h
//  dataBaseExample
//
//  Created by Chip Cox on 7/12/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Doctor : NSManagedObject

@property (nonatomic, retain) NSString * drName;
@property (nonatomic, retain) NSString * officePhone;
@property (nonatomic, retain) NSSet *patient;
@end

@interface Doctor (CoreDataGeneratedAccessors)

- (void)addPatientObject:(Person *)value;
- (void)removePatientObject:(Person *)value;
- (void)addPatient:(NSSet *)values;
- (void)removePatient:(NSSet *)values;

@end
