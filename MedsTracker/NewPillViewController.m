//
//  NewPillViewController.m
//  MedsTracker
//
//  Created by Charles Northup on 5/12/15.
//  Copyright (c) 2015 RogueNotion. All rights reserved.
//

#import "NewPillViewController.h"

@interface NewPillViewController ()

@property (weak, nonatomic) IBOutlet UITextField *medicationNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *pillsLeftTextField;


@end

@implementation NewPillViewController

-(void)viewDidLoad
{
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelMedication)];
    self.navigationItem.leftBarButtonItem = deleteButton;
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveMedication)];
    self.navigationItem.rightBarButtonItem = createButton;

    
}

-(void)cancelMedication
{
    [self performSegueWithIdentifier:@"cancelMedication" sender:self];
}

-(void)saveMedication
{
    [self.detailItem setPillsLeft:[NSNumber numberWithInteger:self.pillsLeftTextField.text.integerValue]];
    [self.detailItem setName:self.medicationNameTextField.text];
    [self performSegueWithIdentifier:@"saveMedication" sender:self];
}


@end