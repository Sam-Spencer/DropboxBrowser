//
//  DBBViewController.m
//  DropboxBrowser
//
//  Created by iRare Media on 12/26/12.
//  Copyright (c) 2013 iRare Media. All rights reserved.
//

#import "DBBViewController.h"


@interface DBBViewController ()
@end



@implementation DBBViewController

@synthesize clearDocsBtn, navBar, imgView;


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    [navBar setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];

    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [imgView setImage:[UIImage imageNamed:@"Background-568h"]];
    } else {
        [imgView setImage:[UIImage imageNamed:@"Background"]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    if (![[DBSession sharedSession] isLinked]) {
		[[DBSession sharedSession] linkFromController:self];
	}
    clearDocsBtn.hidden = NO;
}

- (void)viewDidUnload {
    [self setClearDocsBtn:nil];
    [self setNavBar:nil];
    [self setImgView:nil];

    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)browseDropbox:(id)sender {
    DropboxBrowserViewController *db = [[DropboxBrowserViewController alloc] init];
    [db setupAllowedFileTypes:[NSMutableArray arrayWithObjects:@"pdf", nil]];
    [self performSegueWithIdentifier:@"showDropboxBrowser" sender:self];
}


#pragma mark - DropboxBrowserDelegate

- (void)dropboxBrowser:(DropboxBrowserViewController *)browser downloadedFile:(NSString *)fileName {
    NSLog(@"Downloaded %@", fileName);
}

- (void)dropboxBrowser:(DropboxBrowserViewController *)browser failedToDownloadFile:(NSString *)fileName {
    NSLog(@"Failed to download %@", fileName);
}

- (void)dropboxBrowser:(DropboxBrowserViewController *)browser fileConflictError:(NSDictionary *)conflict {
    DBMetadata *file = [conflict objectForKey:@"file"];
    NSString *errorMessage = [conflict objectForKey:@"message"];
    NSLog(@"Conflict error with %@\n%@ last modified on %@\nError: %@", file.filename, file.filename, file.lastModifiedDate, errorMessage);
}

- (void)dropboxBrowserDismissed:(DropboxBrowserViewController *)browser {
}


#pragma mark - Documents

- (IBAction)clearDocs:(id)sender {
    dispatch_queue_t delete = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(delete, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];

        for (NSString *filename in fileArray)  {
            [fileMgr removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            clearDocsBtn.titleLabel.text = @"Cleared Docs";
            clearDocsBtn.hidden = YES;
        });
    });
}


@end
