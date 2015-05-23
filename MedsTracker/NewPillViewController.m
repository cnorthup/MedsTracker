//
//  NewPillViewController.m
//  MedsTracker
//
//  Created by Charles Northup on 5/12/15.
//  Copyright (c) 2015 RogueNotion. All rights reserved.
//

#import "NewPillViewController.h"
#import "MTBBarcodeScanner.h"

@interface NewPillViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *medicationNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pillsLeftTextField;
@property (weak, nonatomic) IBOutlet UILabel *scannedIndicator;
@property (strong, nonatomic)MTBBarcodeScanner* scanner;
@property (strong, nonatomic) id barcodeData;

@end

@implementation NewPillViewController

-(void)viewDidLoad
{
    self.medicationNameTextField.delegate = self;
    self.pillsLeftTextField.delegate = self;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeTextInput)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    self.scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.view];
    self.scannedIndicator.backgroundColor = [UIColor redColor];
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target:self action:@selector(cancelMedication)];
    self.navigationItem.leftBarButtonItem = deleteButton;
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveMedication)];
    self.navigationItem.rightBarButtonItem = createButton;

    
}

-(void)closeTextInput
{
    for (UITextField* text in self.view.subviews)
    {
        [text resignFirstResponder];
    }
}

- (IBAction)scanBarcodeButton:(id)sender
{
    [self.view endEditing:YES];
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success){
        if (success)
        {
            [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                NSLog(@"Found code: %@", code.stringValue);
                self.barcodeData = code.stringValue;
                self.scannedIndicator.backgroundColor = [UIColor greenColor];
                [self.scanner stopScanning];
            }];
            
        } else {
            // The user denied access to the camera
        }
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



-(void)cancelMedication
{
    [self performSegueWithIdentifier:@"cancelMedication" sender:self];
}

-(void)saveMedication
{
    if ((![self.barcodeData isEqualToString:@""])&&(![self.medicationNameTextField.text isEqualToString:@""])&&(![self.pillsLeftTextField.text isEqualToString:@""]))
    {
        if (self.pillsLeftTextField.text.intValue == 0)
        {
            UIAlertView* zeroPills = [[UIAlertView alloc] initWithTitle:@"Unable To Save" message:@"The number of pills left can not be zero." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [zeroPills show];
        }
        else
        {
            [self.detailItem setPillsLeft:[NSNumber numberWithInteger:self.pillsLeftTextField.text.integerValue]];
            [self.detailItem setName:self.medicationNameTextField.text];
            [self.detailItem setBarcode:self.barcodeData];
            [self performSegueWithIdentifier:@"saveMedication" sender:self];
        }
        
    }
    else
    {
        UIAlertView* notFilledOut = [[UIAlertView alloc] initWithTitle:@"Unable To Save" message:@"One or more of the fields is incomplete. To continue please fill out the miss requirements." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [notFilledOut show];
    }

}


@end