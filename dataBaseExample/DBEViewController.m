//
//  DBEViewController.m
//  dataBaseExample
//
//  Created by Chip Cox on 7/11/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "DBEViewController.h"
#import "DBETableViewController.h"
#import "Person.h"

@interface DBEViewController ()
@end

@implementation DBEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Lets check to make sure our file exists and create it if it doesn't.
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory =[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"DBEViewDocument";
    self.url = [documentsDirectory URLByAppendingPathComponent:documentName];
    
    // Setup my document here
    self.document = [[UIManagedDocument alloc] initWithFileURL:self.url];
    // print out the url path just for fun.
    NSLog(@"url=%@",[self.url path]);
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self.url path]];
    if(fileExists){
        // open file
        [self.document openWithCompletionHandler:^(BOOL success) {
            if(success) [self documentIsReady];
        }];
    } else { // create file and open it at the same time.
        [self.document saveToURL:self.url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if(success)
                [self documentIsReady];
            else
                NSLog(@"Couldn't create document %@",self.url);
        }];
    }
    
}

- (void)documentIsReady
{
    if (self.document.documentState == UIDocumentStateNormal) {
        // start using document
        NSLog(@"Document is in Normal State");
    } else {
        NSLog(@"Docuemnt is not in Normal State");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
