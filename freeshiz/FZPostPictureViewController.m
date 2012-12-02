//
//  FZPostPictureViewController.m
//  freeshiz
//
//  Created by Zac Bowling on 12/1/12.
//  Copyright (c) 2012 freeshiz. All rights reserved.
//

#import "FZPostPictureViewController.h"

@interface FZPostPictureViewController () {
}
@property (strong, nonatomic) NSMutableDictionary *currentItem;
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

  NSNumber *latitude = [NSNumber numberWithFloat:1.0];
  NSNumber *longitude = [NSNumber numberWithFloat:1.0];

  [self.currentItem setObject:remoteURL forKey:@"image_url"];
  [self.currentItem setObject:@"wattup" forKey:@"description"];
  [self.currentItem setObject:latitude forKey:@"lat"];
  [self.currentItem setObject:longitude forKey:@"lon"];
  



  NSMutableURLRequest *request = [self postItemURLRequest];
  // create the connection with the request
        // and start loading the data
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
//        if (theConnection) {
//            _receivedData = [[NSMutableData data] retain];
//        } else {
//            NSLog(@"connection failed");
//        }
  
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

-(NSMutableURLRequest*)postItemURLRequest
{
	//networkStatus update
	//activity indicator start animation
	//
	
	NSString *sourceURL = @"https://freeshit.firebaseio.com/items.json";
 
//convert object to data
NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self.currentItem
  options:NSJSONWritingPrettyPrinted error:nil];
  
  
  
    NSURL *url = [NSURL URLWithString: sourceURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: jsonData];

    //[request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];

    return request;
   
}






- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
 
    // It can be called multiple times,s for example in the case of a
    // redirect, so each time we reset the data.
 
    // receivedData is an instance variable declared elsewhere.
  

    [receivedData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    // receivedData is declared as a method instance elsewhere
 
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
//                          SCAppDelegate *appDelegate = (SCAppDelegate*)[UIApplication sharedApplication].delegate;

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
 NSString *myString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
  NSLog(@"%@", myString);


}



@end
