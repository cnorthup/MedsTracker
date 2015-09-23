//
//  DetailViewController.m
//  MedsTracker
//
//  Created by Charles Northup on 5/12/15.
//  Copyright (c) 2015 RogueNotion. All rights reserved.
//

#import "DetailViewController.h"
#import "Medication.h"
#import "MTBBarcodeScanner.h"



@interface DetailViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) Medication* medication;
@property (weak, nonatomic) IBOutlet UIImageView *takenPillImageView;
@property (strong, nonatomic)MTBBarcodeScanner* scanner;
@property (strong, nonatomic) AVMetadataMachineReadableCodeObject* barcodeData;
@property (strong, nonatomic) NSDate* scanDate;
@property (weak, nonatomic) IBOutlet UILabel *pillsLeftLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *numberOfPillsUserTakes;
@property (nonatomic) NSInteger numberPillsTaking;
@property (nonatomic) BOOL editing;
@property (weak, nonatomic) IBOutlet UITextField *pillTextField;
@property (strong, nonatomic) NSString* barcodeString;



@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        [self configureView];
    }
}

- (void)configureView {
    if (self.detailItem) {
        //self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"name"] description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editPill:)];
    self.navigationItem.rightBarButtonItem = editButton;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeTextInput)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    self.editing = false;
    self.pillTextField.hidden = YES;
    self.barcodeString = self.medication.barcode;
    self.numberOfPillsUserTakes.layer.borderColor = [UIColor grayColor].CGColor;
    self.numberOfPillsUserTakes.layer.borderWidth = 1.0;
    [self.numberOfPillsUserTakes.layer setCornerRadius:10.0];
    self.numberPillsTaking = 1;
    self.scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.view];
    self.medication = self.detailItem;
    NSLog(@"%@", self.medication);
    [self updateDetailView];
    [self configureView];
}

-(void)editPill:(UIBarButtonItem*)sender
{
    self.editing =! self.editing;
    
    if (self.editing == true)
    {
        [sender setStyle:UIBarButtonItemStyleDone];
        [sender setTitle:@"Done"];
        self.pillTextField.text = [NSString stringWithFormat:@"%@", self.medication.pillsLeft];
        self.pillTextField.hidden = NO;
    }
    else
    {
        [sender setStyle:UIBarButtonItemStylePlain];
        [sender setTitle:@"Edit"];
        self.pillTextField.hidden = YES;
        [self updatePill];
    }
    NSLog(@"edit");
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.medication.pillsLeft.integerValue;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.numberPillsTaking = (long)row + 1;
    NSLog(@"%ld", (long)self.numberPillsTaking);
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    long x = row + 1;
    return [NSString stringWithFormat:@"%ld", (long)x];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)closeTextInput
{
    for (UITextField* text in self.view.subviews)
    {
        [text resignFirstResponder];
    }
}

-(void)updatePill
{
    [self.medication setPillsLeft:[NSNumber numberWithInt:self.pillTextField.text.intValue]];
    [self.medication setBarcode:self.barcodeString];
    [self.source updateMedication:self];
    [self closeTextInput];
    [self updateDetailView];
}


-(void)updateDetailView
{
    NSDate* now = [NSDate new];
    double time = (([now timeIntervalSinceDate:self.medication.lastTaken]/60)/60);
    self.title = self.medication.name;
    if (time >= 12) {
        [UIView animateWithDuration:0.25 animations:^{
            self.takenPillImageView.backgroundColor = [UIColor redColor];
            self.takenPillImageView.image = [UIImage imageNamed:@"takePic"];
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.takenPillImageView.backgroundColor = [UIColor greenColor];
            self.takenPillImageView.image = [UIImage imageNamed:@"tookPic"];

        }];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.pillsLeftLabel.alpha = 0.0;
        self.pillsLeftLabel.text = [NSString stringWithFormat:@"%d", self.medication.pillsLeft.intValue];
        [self.pillsLeftLabel sizeToFit];
        self.pillsLeftLabel.alpha = 1.0;
    }];

}



- (IBAction)scanPillButton:(id)sender
{
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                NSLog(@"Found code: %@", code.stringValue);
                self.barcodeData = code;
                if (self.editing == true)
                {
                    self.barcodeString = code.stringValue;
                }
                else
                {
                    [self checkBarcode:code];
                }
                [self.scanner stopScanning];
            }];
            
        } else
        {
            //let the user know that i need to use camera
        }
    }];
}



-(void)checkBarcode:(AVMetadataMachineReadableCodeObject*)barcode
{
    
    if ([barcode.stringValue isEqualToString:self.medication.barcode]) {
        NSLog(@"%@", self.medication.lastTaken);
        int pills = self.medication.pillsLeft.intValue - (int)self.numberPillsTaking;
        [self.medication setPillsLeft:[NSNumber numberWithInt:pills]];
        [self.medication justTookPills];
        [self.source updateMedication:self];
        [self updateDetailView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
