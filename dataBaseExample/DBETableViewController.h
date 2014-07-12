//
//  DBETableViewController.h
//  dataBaseExample
//
//  Created by Chip Cox on 7/11/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "Doctor.h"

@interface DBETableViewController : UITableViewController
@property (nonatomic,strong) UIManagedDocument *document;
@property (nonatomic,strong) NSArray *people;

@end
