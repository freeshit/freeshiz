//
//  FZDetailViewController.m
//  freeshiz
//
//  Created by Zac Bowling on 12/1/12.
//  Copyright (c) 2012 freeshiz. All rights reserved.
//

#import "FZDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FZDetailViewController ()

@end

@implementation FZDetailViewController {
	NSDictionary *_details;
	UIImageView *_backgroundImage;
}

- (id)initWithDetails:(NSDictionary *)details
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _details = details;
		CGFloat width = [[UIScreen mainScreen] bounds].size.width;
		_backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 200)];
		NSString *image_url = [NSString stringWithFormat:@"%@/convert?w=%f&h=%d&fit=clip",_details[@"image_url"],width*self.tableView.contentScaleFactor,400];
		
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:image_url]];
		[NSURLConnection sendAsynchronousRequest:urlRequest
										   queue:[NSOperationQueue mainQueue]
							   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
								   if (data){
									   _backgroundImage.image = [UIImage imageWithData:data];
								   }
		}];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = _backgroundImage.bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite: 1.0 alpha: 0.0] CGColor], (id)[[UIColor colorWithWhite: 1.0 alpha: 1.0] CGColor], nil];
	[_backgroundImage.layer insertSublayer:gradient atIndex:0];
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
	[view addSubview:_backgroundImage];
	self.tableView.backgroundView = view;
	self.tableView.backgroundColor = [UIColor whiteColor];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    // Configure the cell...
    cell.backgroundColor = [UIColor whiteColor];
	
	switch (indexPath.row) {
		case 0:
		{
			UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 360, 20)];
			titleLabel.font = [UIFont boldSystemFontOfSize:12];
			NSString *title = _details[@"title"];
			titleLabel.text = title?title:@"FreeShiz";
			[cell.contentView addSubview:titleLabel];
			
			break;
		}
		case 1:
		{
			
			break;
		}
		case 2:
		{
			
			break;
		}

		default:
			break;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
