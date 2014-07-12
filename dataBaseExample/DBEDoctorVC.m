//
//  DBEDoctorVC.m
//  dataBaseExample
//
//  Created by Chip Cox on 7/11/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "DBEDoctorVC.h"
#import "Doctor.h"

@interface DBEDoctorVC ()

@end

@implementation DBEDoctorVC

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
}

// Add a doctor
- (IBAction)addItem:(UIBarButtonItem *)sender {
    // the document was created in super viewdidload so we can get the context from it here.
    NSManagedObjectContext *context = self.document.managedObjectContext;
    // create an empty entity for doctor.  It's kind of like doing an alloc on it.  There isn't anything
    // in it, it's just space waiting for data.
    Doctor *doctor = [NSEntityDescription insertNewObjectForEntityForName:@"Doctor" inManagedObjectContext:context];
    // now fill it with data from the form.
    doctor.drName=self.nameField.text;
    doctor.officePhone=self.phoneField.text;
    
    // save it.  It's like a commit to me.
    [self.document saveToURL:self.url forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if(success)[self documentIsReady];
        if(!success) NSLog(@"Couldn't create document %@",self.url);
    }];
    
    // clear off data entry fields in preparation for next doctor.
    self.nameField.text=@"";
    self.phoneField.text=@"";
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[DBETableViewController class]] ){
        // send the document over so we can get our context.
        DBETableViewController *tvc = (DBETableViewController *) segue.destinationViewController;
        tvc.document = self.document;
    }
}

@end
