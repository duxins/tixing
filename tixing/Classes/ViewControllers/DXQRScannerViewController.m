//
//  DXQRScannerViewController.m
//  tixing
//
//  Created by Du Xin on 11/15/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXQRScannerViewController.h"
#import "DXQRScannerMaskView.h"

@import AVFoundation;

@interface DXQRScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, weak) IBOutlet DXQRScannerMaskView *maskView;
@property (nonatomic, weak) IBOutlet UIView *loadingView;
@end

@implementation DXQRScannerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  self.loadingView.hidden = YES;
  [self start];
}

- (void)start
{
  NSError *error;
  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
  
  if (!input){
    DDLogError(@"%@", error.localizedDescription);
    return;
  }
  
  AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
  [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
  
  self.captureSession = [[AVCaptureSession alloc]init];
  [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
  [self.captureSession addInput:input];
  [self.captureSession addOutput:output];
  
  output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
  
  AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
  previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  [self.view.layer insertSublayer:previewLayer atIndex:0];
  previewLayer.frame = self.view.bounds;
  [self.captureSession startRunning];
  

}

#pragma mark -
#pragma mark Actions
- (IBAction)goBack{
  [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
  if (metadataObjects.count == 0) return;
  [self.captureSession stopRunning];
  
  AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects firstObject];
  NSString *code = metadataObject.stringValue;
  
  DDLogDebug(@"QR Code: %@", code);
  
  if (self.successBlock) {
    self.successBlock(code);
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UI
- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

@end
