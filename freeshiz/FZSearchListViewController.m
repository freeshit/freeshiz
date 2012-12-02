//
//  FZSearchListViewController.m
//  freeshiz
//
//  Created by Zac Bowling on 12/1/12.
//  Copyright (c) 2012 freeshiz. All rights reserved.
//

#import "FZSearchListViewController.h"
#import "FZSearchListViewCell.h"
#import "FZDetailViewController.h"
#import "FZAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface FZSearchListViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@end

@implementation FZSearchListViewController {
	NSArray *_results;
	UISearchBar *_searchBar;
	UISearchDisplayController *_searchController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		_results = @[];
		[[NSNotificationCenter defaultCenter] addObserverForName:FZSearchResponseNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			_results = note.userInfo[@"results"];
			[self.tableView reloadData];
		}];
		
		_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		_searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.tableHeaderView = _searchBar;
	
	
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FZSearchListViewCell";
    UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
	
	if ([_results isKindOfClass:[NSDictionary class]]){
		_results = [(NSDictionary *)_results allValues];
	}
	
	NSDictionary *row = _results[indexPath.row];
	
	cell.imageView.image = [UIImage imageNamed:@"13-target"];
    NSString *imageurl = [NSString stringWithFormat:@"%@/convert?w=%f&h=%f&fit=crop",row[@"image_url"],60.0*self.tableView.contentScaleFactor,60*self.tableView.contentScaleFactor];
	;
	if ([imageurl length] > 0){
		[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageurl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
			if (data) {
				cell.imageView.image = [UIImage imageWithData:data scale:self.tableView.contentScaleFactor];
				[cell setNeedsLayout];
			}
		}];
	}
	
    cell.textLabel.text = row[@"description"];
	
	FZAppDelegate *delegate = (FZAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	CLLocation *location = [[CLLocation alloc] initWithLatitude:[row[@"lat"] doubleValue] longitude:[row[@"lon"] doubleValue]];
	CLLocation *location2 = [[CLLocation alloc] initWithLatitude:delegate.currentLocation.coordinate.latitude longitude:delegate.currentLocation.coordinate.longitude];
	
	
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d meters away",(int)[location distanceFromLocation:location2]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *detials = _results[indexPath.row];
	FZDetailViewController *detailViewController = [[FZDetailViewController alloc] initWithDetails:detials];
	// ...
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
}

@end
