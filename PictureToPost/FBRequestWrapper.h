//
//  FBRequestWrapper.h
//  Facebook Demo
//
//  Created by Andy Yanok on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

#define FB_APP_ID @"348552985214110"
#define FB_API_KEY @"348552985214110"
#define FB_APP_SECRET @"55916a792fa85520d4b8325eadaeb2a9"

@interface FBRequestWrapper : NSObject <FBRequestDelegate, FBSessionDelegate> 
{
	Facebook *facebook;
	BOOL isLoggedIn;
}

@property (nonatomic, assign) BOOL isLoggedIn;

+ (id) defaultManager;
- (void) setIsLoggedIn:(BOOL) _loggedIn;
- (void) FBSessionBegin:(id<FBSessionDelegate>) _delegate;
- (void) FBLogout;
- (void) getFBRequestWithGraphPath:(NSString*) _path andDelegate:(id) _delegate;
- (void) sendFBRequestWithGraphPath:(NSString*) _path params:(NSMutableDictionary*) _params andDelegate:(id) _delegate;

@end
