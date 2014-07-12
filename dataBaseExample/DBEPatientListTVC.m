//
//  DBEPatientListTVC.m
//  dataBaseExample
//
//  Created by Chip Cox on 7/12/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "DBEPatientListTVC.h"
#import "Person.h"
#import "Doctor.h"

@interface DBEPatientListTVC ()
@property (nonatomic,strong) NSMutableArray *pat;
@end

@implementation DBEPatientListTVC

-(NSMutableArray *) pat
{
    if(!_pat) _pat=[[NSMutableArray alloc] init];
    return _pat;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// This one was a pain in the backside
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //we want to get a list of the dr's patients here.
    // from what I could find, it seems we have to get the list of the dr's patients
    // rather than the list of people that have the dr we are looking for.
    // apparently this is more efficient.  I miss Oracle.
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Doctor"];
    // I'm looking for the dr by name.
    request.predicate = [NSPredicate predicateWithFormat:@"drName=%@",self.dr.drName];
    // There should only be 1 dr with that name so I'm not bothering sorting.  Even if there
    // is more than one with that name, sorting identical things doesn't make sense.
    
    // get our context like we've been doing from the document we passed over in the segue.
    NSManagedObjectContext *context = self.document.managedObjectContext;
    NSError *error;
    // do it
    self.people = [context executeFetchRequest:request error:&error];
    
    // Ok here is where it gets really screwy.
    // people only returns 1 row since we only have 1 doctor by that name.  That makes sense sort of.
    NSLog(@"people count =%d",self.people.count);
    
    // I'm leaving the nslog's in here just to show the datastructure
    int i=0;
    // this one here is from the doctor's point of view
    for(Doctor *p in self.people){
        NSLog(@"DR %d = %@ people[%d]=%@, %@",i,p.drName, i,[p.patient valueForKey:@"name"],[p.patient valueForKey:@"phone"]);
        i++;
    }
    
    // this nslog goes down to the patient and shows it from their point of view
    for(Person *p in [self.people valueForKey:@"patient"])
        NSLog(@"p=%d, %@",[[p valueForKey:@"name"] count],[p valueForKey:@"name"]);
    
    // since there is only one dr returned I'm going to get it out of the array by referencing array index 0
    Doctor *drs=[self.people objectAtIndex:0];
    NSLog(@"drs=%@",drs.drName);
    // now I'm going to build an array by using allobjects from the set returned by drs.patient
    // the mutableCopy is just because I made self.pat a mutablearray
    self.pat=[[drs.patient allObjects] mutableCopy];
    for(Person *p in self.pat)
        NSLog(@"person=%@",p.name);
    
    // so now pat is an array of my patients of the dr.
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.pat.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientListCell" forIndexPath:indexPath];
    
    // set p to be the person element at the row index for the pat array
    Person *p=[self.pat objectAtIndex:indexPath.row];
    // now I can fill in the text and subtitle real easy.
    cell.textLabel.text=p.name;
    cell.detailTextLabel.text=p.phone;
    
    return cell;
}

@end
