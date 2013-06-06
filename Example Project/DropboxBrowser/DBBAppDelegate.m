//
//  DBBAppDelegate.m
//  DropboxBrowser
//
//  Created by iRare Media on 12/26/12.
//  Copyright (c) 2013 iRare Media. All rights reserved.
//

#import "DBBAppDelegate.h"

@implementation DBBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    DBSession* dbSession = [[DBSession alloc] initWithAppKey:@"k78utucwe5gn4qa" appSecret:@"uryb33eg7a21s1q" root:kDBRootDropbox];
    DBSession* dbSession = [[DBSession alloc] initWithAppKey:@"k78utucwe5gn4qa" appSecret:@"uryb33eg7a21s1q" root:kDBRootDropbox];
    [DBSession setSharedSession:dbSession];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
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




@end
