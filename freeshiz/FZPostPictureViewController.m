//
//  FZPostPictureViewController.m
//  freeshiz
//
//  Created by Zac Bowling on 12/1/12.
//  Copyright (c) 2012 freeshiz. All rights reserved.
//

#import "FZPostPictureViewController.h"
#import "FZAppDelegate.h"
@interface FZPostPictureViewController () <FPPickerDelegate, NSURLConnectionDelegate>  {
}
@property (strong, nonatomic) NSMutableDictionary *currentItem;

@property (nonatomic, retain) UIImageView *image;
- (IBAction)pickerModalAction: (id) sender;
-(IBAction)postItem:(id)sender;
-(NSMutableURLRequest*)postItemURLRequest;
@end

@implementation FZPostPictureViewController

@synthesize image;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPost:)];
		self.currentItem = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	//[self pickerModalAction:self];
	
}




- (IBAction)pickerModalAction: (id) sender {
    
    
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
    fpController.sourceNames = [[NSArray alloc] initWithObjects: FPSourceCamera, nil];
    
    /*
     * Display it.
     */
	
  	[self presentViewController:fpController animated:YES completion:NULL];
	
	//    [self presentModalViewController:fpController animated:YES];
}


-(IBAction)postItem:(id)sender
{
		
	
	if(![self isItemComplete])
	{
		//display modal
		return;
	}
	
	FZAppDelegate *delegate = (FZAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSNumber *latitude = [NSNumber numberWithDouble:delegate.currentLocation.coordinate.latitude];
	NSNumber *longitude = [NSNumber numberWithDouble:delegate.currentLocation.coordinate.longitude];
	
	NSMutableDictionary *item = [@{} mutableCopy];
	item[@"image_url"] = remoteURL;
	item[@"description"] = @"wattup";
	item[@"lat"] = latitude;
	item[@"lon"] = longitude;
	
	NSMutableURLRequest *request = [self postItemURLRequest:item];
	// create the connection with the request
	// and start loading the data
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		//TODO handler response
	}];

	
}

-(BOOL)isItemComplete
{
	return (image.image != nil);
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
    NSLog(@"FILE CHOSEN: %@", info);
    
    [info objectForKey:@"FPPickerControllerOriginalImage"];
	
	image.image = [info objectForKey:@"FPPickerControllerOriginalImage"];
	remoteURL = [NSString stringWithFormat:@"%@/convert?dl=false&height=100&width=100&fit=crop", [info objectForKey:@"FPPickerControllerRemoteURL"]];
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)FPPickerControllerDidCancel:(FPPickerController *)picker
{
    NSLog(@"FP Cancelled Open");
	[self dismissViewControllerAnimated:YES completion:NULL];
}

-(NSMutableURLRequest*)postItemURLRequest:(NSDictionary *)item
{
	//networkStatus update
	//activity indicator start animation
	//
	
	NSString *sourceURL = @"https://freeshit.firebaseio.com/items.json";
	
	//convert object to data
	NSData* jsonData = [NSJSONSerialization dataWithJSONObject:item
													   options:NSJSONWritingPrettyPrinted error:nil];
	
	
	
    NSURL *url = [NSURL URLWithString: sourceURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: jsonData];
	
    //[request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
	
    return request;
	
}

@end
