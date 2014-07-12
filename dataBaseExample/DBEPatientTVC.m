//
//  DBEPatientTVC.m
//  dataBaseExample
//
//  Created by Chip Cox on 7/11/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "DBEPatientTVC.h"
#import "Person.h"

@interface DBEPatientTVC ()
@end

@implementation DBEPatientTVC

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
    // make a request from entity Person
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    // no predicate to give me everybody
    // sort by name
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    // get our context from the document that was passed in via the segue.
    NSManagedObjectContext *context = self.document.managedObjectContext;
    NSError *error;
    // do it.
    self.people = [context executeFetchRequest:request error:&error];
    
    // just for fun, lets see what we got out.
    NSLog(@"people count =%d",self.people.count);
    int i=0;
    for(Person *p in self.people)
        NSLog(@"people[%d]=%@, %@",i++,p.name,p.phone);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// build our table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    
    // Configure the cell...
    // Remember what is returned from the query is an array of NSManagedObjects.
    // So I'm initializing a pointer of the type of NSManagedObject I'm working with so I
    // can reference the elements with dot notation.
    Person *person=[self.people objectAtIndex:indexPath.row];
    cell.textLabel.text=person.name;
    cell.detailTextLabel.text=person.phone;
    
    return cell;
}

@end
