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
    NSDate* now = [NSDate new];
    double time = (([now timeIntervalSinceDate:self.medication.lastTaken]/60)/60);
    self.title = self.medication.name;
    NSLog(@"%f", time);
    if (time >= 12) {
        self.takenPillImageView.backgroundColor = [UIColor redColor];
    }
    else
    {
        self.takenPillImageView.backgroundColor = [UIColor greenColor];
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
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
        [self.medication setLastTaken:[NSDate new]];
        NSLog(@"updated");
        [self.source updateMedication:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
