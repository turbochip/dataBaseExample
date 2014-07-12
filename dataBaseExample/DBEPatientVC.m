//
//  DBEPatientVC.m
//  dataBaseExample
//
//  Created by Chip Cox on 7/11/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "DBEPatientVC.h"
#import "Person.h"


@interface DBEPatientVC () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic,strong) NSArray *doctorsResults;
@property (nonatomic,strong) NSMutableArray *doctors;
@property (weak, nonatomic) IBOutlet UIPickerView *doctorPV;
@property (nonatomic,strong) NSString *selectedDoctor;
@end

@implementation DBEPatientVC

// setup any setters and getters.
-(NSMutableArray *) doctors
{
    if(!_doctors) _doctors=[[NSMutableArray alloc] init];
    return _doctors;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // have to set the datasource and delegate for the picker view
    self.doctorPV.dataSource=self;
    self.doctorPV.delegate=self;
}

// The add item button on the patient scene was pressed.
// now I'm not being well behaved here, I'm not checking to see if one already exists, or anything like that
// I'm just going ahead like we know what we are doing.
- (IBAction)addItem:(UIBarButtonItem *)sender {
    // we setup our document back in the super viewdidload so we can get it's context here
    NSManagedObjectContext *context = self.document.managedObjectContext;
    
    // create a new Person record.  There isn't anything in it, and it isn't written to the database.
    // it's kind of like alloc for an array or something.
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    
    // now add values to the fields in the empty person entity we created.
    person.name=self.nameField.text;
    person.phone=self.phoneField.text;
    person.physician=[self.doctorsResults objectAtIndex:[self.doctorPV selectedRowInComponent:0]];
    
    // I'm doing a save of the document here even though technically we don't have to.  I see it kind of like a commit.
    // it's a good idea to do one at the end of each logical transaction just so you don't end up locking things up.
    // it may not matter with coredata, but it will with real databases.
    [self.document saveToURL:self.url forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if(success)[self documentIsReady];    // I have no idea why he didn't do this with an else in the lecture and it buggs me.
        if(!success) NSLog(@"Couldn't create document %@",self.url);
    }];
    
    // just resetting my data entry fields.
    self.nameField.text=@"";
    self.phoneField.text=@"";
    [self.doctorPV selectRow:0 inComponent:0 animated:YES];
}

// our save is done.
- (void) documentIsReady
{
    [super documentIsReady];
    // in here i'm building my array of doctors to populate my pickerview control.
    NSLog(@"Preparing to fetch doctors");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Doctor"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"drName" ascending:YES]];
    NSManagedObjectContext *context = self.document.managedObjectContext;
    NSError *error;
    self.doctorsResults = [context executeFetchRequest:request error:&error];
    for (Doctor *dr in self.doctorsResults){
        [self.doctors addObject:dr.drName];
    }
    
    // because viewdidload is called before the query completes, I don't have this information in time
    // for it to show up on the screen when it loads so we have to do a reloadallcomponents on the pickerview
    // to get the choices to show up in it.
    [self.doctorPV reloadAllComponents];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[DBETableViewController class]] ){
        // the only thing I need to send over is the document so I have my context in the next view.
        DBETableViewController *tvc = (DBETableViewController *) segue.destinationViewController;
        tvc.document = self.document;
    }
}

// picker view seems to be just basically a tableview strapped to the outside of a wheel. So these
// methods should look pretty familiar.

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"there are %d doctors",[self.doctors count]);
    return [self.doctors count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"Row %d has dr %@",row,[self.doctors objectAtIndex:row]);
    return [self.doctors objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.selectedDoctor = [self.doctors objectAtIndex:row];
    NSLog(@"the doctor selected was %@",self.selectedDoctor);
}

@end
