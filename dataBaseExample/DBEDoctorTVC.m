//
//  DBEDoctorTVC.m
//  dataBaseExample
//
//  Created by Chip Cox on 7/11/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "DBEDoctorTVC.h"
#import "Doctor.h"
#import "DBEPatientListTVC.h"

@interface DBEDoctorTVC ()

@end

@implementation DBEDoctorTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Make a request of the doctor entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Doctor"];
    // no predicate so give me all of them
    // I could have subclassed this if I had made the entity name a variable and the sort key a variable
    // or used the same names for my attributes in my coredata entities.  Oh well.
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"drName" ascending:YES]];
    // get the context from our document we passed in with the segue.
    NSManagedObjectContext *context = self.document.managedObjectContext;
    NSError *error;
    // do it
    self.people = [context executeFetchRequest:request error:&error];
    
    // just for fun, lets see what we got
    NSLog(@"people count =%d",self.people.count);
    int i=0;
    for(Doctor *p in self.people)
        NSLog(@"people[%d]=%@, %@",i++,p.drName,p.officePhone);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorCell" forIndexPath:indexPath];
    
    // Configure the cell...
    // Remember what is returned from the query is an array of NSManagedObjects.
    // So I'm initializing a pointer of the type of NSManagedObject I'm working with so I
    // can reference the elements with dot notation.
    Doctor *person=[self.people objectAtIndex:indexPath.row];
    cell.textLabel.text=person.drName;
    cell.detailTextLabel.text=person.officePhone;
    
    return cell;
}

// ok here is a wrinkle we didn't have with patients.  With dr's there is another list we
// can get to of their patients
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[DBEPatientListTVC class]] ){
        DBEPatientListTVC *tvc = (DBEPatientListTVC *) segue.destinationViewController;
        // This is to get the index of the cell that we were on when we clicked the info accessory.
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Doctor *dr = [self.people objectAtIndex:indexPath.row];
        // ok we are going to send over the dr object and the document.
        tvc.dr = dr;
        tvc.document=self.document;
    }
}


@end
