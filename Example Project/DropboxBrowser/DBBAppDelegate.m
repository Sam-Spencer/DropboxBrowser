//
//  DBBAppDelegate.m
//  DropboxBrowser
//
//  Created by iRare Media on 12/26/12.
//  Copyright (c) 2013 iRare Media. All rights reserved.
//

#import "DBBAppDelegate.h"


@interface DBBAppDelegate () <DBSessionDelegate, DBNetworkRequestDelegate>
@property (strong, nonatomic) NSString *relinkUserId;
@end



@implementation DBBAppDelegate

- (BOOL)             application:(UIApplication *)application
   didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString* appKey = @"k78utucwe5gn4qa";
	NSString* appSecret = @"uryb33eg7a21s1q";
	NSString *root = kDBRootDropbox;
    DBSession* session = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
	session.delegate = self;
    [DBSession setSharedSession:session];

	[DBRequest setNetworkRequestDelegate:self];

    return YES;
}

- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation
{
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
        }
        return YES;
    }
    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


#pragma mark - DBSessionDelegate

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId
{
	self.relinkUserId = userId;
	[[[UIAlertView alloc] initWithTitle:@"Dropbox Session Ended"
								message:@"Do you want to relink?"
							   delegate:self
					  cancelButtonTitle:@"Cancel"
					  otherButtonTitles:@"Relink", nil]
	 show];
}

#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
{
	if (index != alertView.cancelButtonIndex) {
		[[DBSession sharedSession] linkUserId:self.relinkUserId fromController:nil];
	}
	self.relinkUserId = nil;
}


#pragma mark - DBNetworkRequestDelegate

static int outstandingRequests;

- (void)networkRequestStarted
{
	outstandingRequests++;
	if (outstandingRequests == 1) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}

- (void)networkRequestStopped
{
	outstandingRequests--;
	if (outstandingRequests == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}


@end
