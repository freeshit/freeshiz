//
//  FZSearchTabController.m
//  freeshiz
//
//  Created by Zac Bowling on 12/1/12.
//  Copyright (c) 2012 freeshiz. All rights reserved.
//

#import "FZSearchTabController.h"
#import "FZSearchMapViewController.h"
#import "FZPostPictureViewController.h"

@interface FZSearchTabController()

@property (nonatomic, strong) UINavigationController *mapNavigationController;
@property (nonatomic, strong) FZSearchMapViewController *mapController;
@property (nonatomic, strong) UINavigationController *listNavigationController;
@property (nonatomic, strong) UITableViewController *listController;

@end

@implementation FZSearchTabController

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
		
		_listController = [[UITableViewController alloc] initWithNibName:nil bundle:nil];
		_listController.navigationItem.title = @"freeshiz";
		_listController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(post:)];
		_listNavigationController = [[UINavigationController alloc] initWithRootViewController:_listController];
		_listNavigationController.tabBarItem.title = @"List";
		
		
		self.viewControllers = [NSArray arrayWithObjects:_mapNavigationController, _listNavigationController, nil];
		
    }
    return self;
}

- (void)post:(id)sender {

	FZPostPictureViewController *_postViewController = [[FZPostPictureViewController alloc] initWithNibName:nil bundle:nil];
	
	UINavigationController *postNavigationController = [[UINavigationController alloc] initWithRootViewController:_postViewController];
	
	[self presentViewController:postNavigationController animated:YES completion:NULL];
}


@end
