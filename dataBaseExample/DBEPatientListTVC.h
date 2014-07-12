//
//  DBEPatientListTVC.h
//  dataBaseExample
//
//  Created by Chip Cox on 7/12/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "DBETableViewController.h"
#import "Doctor.h"

@interface DBEPatientListTVC : DBETableViewController
@property (nonatomic,strong) Doctor *dr;
@end
