//
//  ViewController.h
//  PictureToPost
//
//  Created by Sony Theakanath on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBFeedPost.h"
#import "IFNNotificationDisplay.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <FBFeedPostDelegate>
{
    IBOutlet UITextView *txtCaption;
    IBOutlet UILabel *time;
	IBOutlet UIImageView *imageView;
}

@property (nonatomic, retain) IBOutlet UITextView *txtCaption;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UIView *vImagePreview;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, retain) IBOutlet UIImageView *vImage;

-(IBAction) takeandsendpicture;

@end
