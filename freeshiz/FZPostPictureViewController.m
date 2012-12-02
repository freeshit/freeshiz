//
//  FZPostPictureViewController.m
//  freeshiz
//
//  Created by Zac Bowling on 12/1/12.
//  Copyright (c) 2012 freeshiz. All rights reserved.
//

#import "FZPostPictureViewController.h"
#import "FZAppDelegate.h"
#import "FZPostDetailViewController.h"

@interface FZPostPictureViewController () <FPPickerDelegate> {
}
@property (strong, nonatomic) NSMutableDictionary *currentItem;

@property (nonatomic, retain) UIImageView *image;
- (IBAction)pickerModalAction: (id) sender;
-(IBAction)postItem:(id)sender;
-(NSMutableURLRequest*)postItemURLRequest;
@end

@implementation FZPostPictureViewController {
	NSURL *_remoteURL;
}

@synthesize imageView=_imageView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPost:)];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

}

- (IBAction)picture:(id)sender{
    /*
     * Create the object
     */
    FPPickerController *fpController = [[FPPickerController alloc] init];
    
    /*
     * Set the delegate
     */
    fpController.fpdelegate = self;
    
    /*
     * Ask for specific data types. (Optional) Default is all files.
     */
    fpController.dataTypes = [NSArray arrayWithObjects:@"image/*", nil];
    //fpController.dataTypes = [NSArray arrayWithObjects:@"image/*", @"video/quicktime", nil];
    
    /*
     * Select and order the sources (Optional) Default is all sources
     */
    //fpController.sourceNames = [[NSArray alloc] initWithObjects: FPSourceCamera, nil];
    
    /*
     * Display it.
     */
	
  	[self presentViewController:fpController animated:NO completion:NULL];
	
	//    [self presentModalViewController:fpController animated:YES];
}


-(IBAction)next:(id)sender
{
	FZPostDetailViewController *detailController = [[FZPostDetailViewController alloc] init];
	if ([_remoteURL isKindOfClass:[NSURL class]]) {
		detailController.remoteImageURL = [_remoteURL absoluteString];
	} else {
		detailController.remoteImageURL = [_remoteURL description];
	}
	
	
	[self.navigationController pushViewController:detailController animated:YES];
}

-(BOOL)isItemComplete
{
	return (_imageView.image != nil);
}
- (void)cancelPost:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FPPickerControllerDelegate Methods

- (void)FPPickerController:(FPPickerController *)picker didPickMediaWithInfo:(NSDictionary *)info {
	
}

- (void)FPPickerController:(FPPickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSLog(@"FILE CHOSEN: %@", info);
    
    //[info objectForKey:@"FPPickerControllerOriginalImage"];
	
	_imageView.image = [info objectForKey:@"FPPickerControllerOriginalImage"];
	_remoteURL = [info objectForKey:@"FPPickerControllerRemoteURL"];
	[self dismissViewControllerAnimated:YES completion:NULL];
	if (_imageView.image != nil) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(next:)];
	}
	else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (void)FPPickerControllerDidCancel:(FPPickerController *)picker
{
    //NSLog(@"FP Cancelled Open");
	[self dismissViewControllerAnimated:YES completion:NULL];
	if (_imageView.image != nil) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(next:)];
	}
	else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}



@end
