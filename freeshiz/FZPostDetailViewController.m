//
//  FZPostDetailViewController.m
//  freeshiz
//
//  Created by Zac Bowling on 12/2/12.
//  Copyright (c) 2012 freeshiz. All rights reserved.
//

#import "FZPostDetailViewController.h"
#import "FZAppDelegate.h"

@interface FZPostDetailViewController ()

@end

@implementation FZPostDetailViewController {
	QRootElement *_root;
	QSection *_postSection;
}

@synthesize remoteImageURL=_remoteImageURL;

- (id)init
{
	QRootElement *root = [[QRootElement alloc] init];
	QSection *postSection = [[QSection alloc] init];
	QEntryElement *titleElement = [[QEntryElement alloc] initWithTitle:@"Title" Value:nil Placeholder:@"title"];
	titleElement.key = @"title";
    QEntryElement *descriptionElement = [[QEntryElement alloc] initWithTitle:nil Value:nil Placeholder:@"description"];
	descriptionElement.key = @"description";
	[postSection addElement:titleElement];
	[postSection addElement:descriptionElement];
	[root addSection:postSection];
	self = [super initWithRoot:root];
    if (self) {
        _root = root;
		_postSection = postSection;
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(post:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)post:(id)sender {
	FZAppDelegate *delegate = (FZAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSNumber *latitude = [NSNumber numberWithDouble:delegate.currentLocation.coordinate.latitude];
	NSNumber *longitude = [NSNumber numberWithDouble:delegate.currentLocation.coordinate.longitude];
	
	
	
	NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
	
	[_postSection fetchValueIntoObject:item];
	
	item[@"image_url"] = _remoteImageURL;
	//item[@"description"] = _description.text;
	item[@"lat"] = latitude;
	item[@"lon"] = longitude;

	

	NSMutableURLRequest *request = [self postItemURLRequest:item];
	// create the connection with the request
	// and start loading the data
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
						   completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
							   
						   }];
	
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
