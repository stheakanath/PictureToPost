//
//  ViewController.m
//  PictureToPost
//
//  Created by Sony Theakanath on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/CGImageProperties.h>
#import "UIImage+Resize.h"

@interface ViewController ()

@end


@implementation ViewController

@synthesize txtCaption, imageView, vImagePreview, vImage, stillImageOutput;

-(void)takeandsendpicture2
{
    [self.txtCaption resignFirstResponder];
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in stillImageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) { break; }
	}
    
	[stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
		 CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
		 if (exifAttachments)
		 {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
		 }
         else
             NSLog(@"no attachments");
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
          UIImage *j = [[UIImage alloc] initWithData:imageData];
        
         UIImage *finishedimage = [j resizedImage:CGSizeMake(240,321) interpolationQuality:1];
         self.vImage.image = finishedimage;
         //we will release this object when it is finished posting
         FBFeedPost *post = [[FBFeedPost alloc] initWithPhoto:finishedimage name:nil];
         [post publishPostWithDelegate:self];
    
         IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
         display.type = NotificationDisplayTypeLoading;
         display.tag = NOTIFICATION_DISPLAY_TAG;
         [display setNotificationText:@"Posting Photo..."];
         [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:0.0];
         [display release];
     }
     ];
}

-(IBAction) takeandsendpicture {
    [self performSelectorInBackground:@selector(takeandsendpicture2) withObject:nil];
}
#pragma mark -
#pragma mark FBFeedPostDelegate

- (void) failedToPublishPost:(FBFeedPost*) _post {
    
	UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
	
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Failed To Post"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
	[display release];
	
	//release the alloc'd post
	[_post release];
}

- (void) finishedPublishingPost:(FBFeedPost*) _post {
    
	UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
	
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Finished Posting"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
	[display release];
	
	//release the alloc'd post
	[_post release];
}

-(void) viewDidAppear:(BOOL)animated
{
	AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetMedium;
    
	CALayer *viewLayer = self.vImagePreview.layer;
	NSLog(@"viewLayer = %@", viewLayer);
    
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
	captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
	[self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
	[session startRunning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
	[txtCaption release];
	[imageView release];
    [super dealloc];
}

@end
