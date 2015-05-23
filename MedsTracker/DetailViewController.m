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



@interface DetailViewController ()

@property (strong, nonatomic) Medication* medication;
@property (weak, nonatomic) IBOutlet UIImageView *takenPillImageView;
@property (strong, nonatomic)MTBBarcodeScanner* scanner;
@property (strong, nonatomic) AVMetadataMachineReadableCodeObject* barcodeData;
@property (strong, nonatomic) NSDate* scanDate;
@property (weak, nonatomic) IBOutlet UILabel *pillsLeftLabel;



@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"name"] description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title =
    self.scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.view];
    self.medication = self.detailItem;
    NSLog(@"%@", self.medication);
    [self updateDetailView];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

-(void)updateDetailView
{
    NSDate* now = [NSDate new];
    double time = (([now timeIntervalSinceDate:self.medication.lastTaken]/60)/60);
    self.title = self.medication.name;
    if (time >= 12) {
        [UIView animateWithDuration:0.25 animations:^{
            self.takenPillImageView.backgroundColor = [UIColor redColor];
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.takenPillImageView.backgroundColor = [UIColor greenColor];
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
                [self checkBarcode:code];
                [self.scanner stopScanning];
            }];
            
        } else {
            // The user denied access to the camera
        }
    }];
}

-(void)checkBarcode:(AVMetadataMachineReadableCodeObject*)barcode
{
    
    if ([barcode.stringValue isEqualToString:self.medication.barcode]) {
        NSLog(@"%@", self.medication.lastTaken);
        int pills = self.medication.pillsLeft.intValue - 1;
        [self.medication setPillsLeft:[NSNumber numberWithInt:pills]];
        [self.medication setLastTaken:[NSDate new]];
        NSLog(@"updated");
        [self.source updateMedication:self];
        [self updateDetailView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
