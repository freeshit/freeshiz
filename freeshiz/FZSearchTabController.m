//
//  FZSearchTabController.m
//  freeshiz
//
//  Created by Zac Bowling on 12/1/12.
//  Copyright (c) 2012 freeshiz. All rights reserved.
//

#import "FZSearchTabController.h"
#import "FZSearchMapViewController.h"
#import "FZSearchListViewController.h"
#import "FZPostPictureViewController.h"
#import "FZAppDelegate.h"


NSString * const FZSearchResponseNotification = @"FZSearchResponseNotification";

@interface FZSearchTabController()

@property (nonatomic, strong) UINavigationController *mapNavigationController;
@property (nonatomic, strong) FZSearchMapViewController *mapController;
@property (nonatomic, strong) UINavigationController *listNavigationController;
@property (nonatomic, strong) UITableViewController *listController;

@end

@implementation FZSearchTabController {
	NSTimer *_timer;
}

@synthesize mapController=_mapController;
@synthesize mapNavigationController=_mapNavigationController;
@synthesize listController=_listController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		_mapController = [[FZSearchMapViewController alloc] initWithNibName:@"FZSearchMapViewController" bundle:nil];
		_mapController.navigationItem.title = @"freeshiz";
		_mapController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(post:)];
		_mapNavigationController = [[UINavigationController alloc] initWithRootViewController:_mapController];
		_mapNavigationController.tabBarItem.title = @"Map";
		_mapNavigationController.tabBarItem.image = [UIImage imageNamed:@"73-radar"];
		
		_listController = [[FZSearchListViewController alloc] initWithStyle:UITableViewStylePlain];
		_listController.navigationItem.title = @"freeshiz";
		_listController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(post:)];
		_listNavigationController = [[UINavigationController alloc] initWithRootViewController:_listController];
		_listNavigationController.tabBarItem.title = @"List";
		_listNavigationController.tabBarItem.image = [UIImage imageNamed:@"162-receipt"];
		
		
		self.viewControllers = [NSArray arrayWithObjects:_mapNavigationController, _listNavigationController, nil];
		//_timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)post:(id)sender {
	FZPostPictureViewController *_postViewController = [[FZPostPictureViewController alloc] initWithNibName:nil bundle:nil];
	
	UINavigationController *postNavigationController = [[UINavigationController alloc] initWithRootViewController:_postViewController];

	[self presentViewController:postNavigationController animated:YES completion:NULL];

}

- (void)tick:(id)sender {
	[self search:nil];
}

- (void)search:(NSString *)query {
	if (!query) {
		query = @"";
	}
	
	FZAppDelegate *delegate = (FZAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (!delegate.currentLocation) {
		return;
	}
	
	NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/items.json?query=%@&lat=%f&lon&=%f",FZServerURLPrefix,[query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], delegate.currentLocation.coordinate.latitude,delegate.currentLocation.coordinate.longitude]];
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:requestURL];
	
	[NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		if (!data) {
			//todo handle error
			NSLog(@"http error %@",error);
			return;
		}
		NSError *jsonError =nil;
		NSArray *queryData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
		
		if (!queryData) {
			//TODO handle error;
			NSLog(@"jsonError error %@",jsonError);
			return;
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:FZSearchResponseNotification object:self userInfo:@{@"results":queryData,@"query":query}];
				
	}];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self search:nil];
}


@end
