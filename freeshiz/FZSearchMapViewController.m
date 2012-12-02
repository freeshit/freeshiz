//
//  FZSearchMapViewController.m
//  freeshiz
//
//  Created by Zac Bowling on 12/1/12.
//  Copyright (c) 2012 freeshiz. All rights reserved.
//

#import "FZSearchMapViewController.h"

@interface FZPointAnnotation : MKPointAnnotation
@property (nonatomic, strong) NSDictionary *rowData;
@end

@implementation FZPointAnnotation
@synthesize rowData = _rowData;
@end

@interface FZSearchMapViewController ()<MKMapViewDelegate>

@end

@implementation FZSearchMapViewController {
	NSArray *_results;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserverForName:FZSearchResponseNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			_results = note.userInfo[@"results"];

		}];
		
    }
    return self;
}

- (void)loadFromResults {
	[self.mapView removeAnnotations:self.mapView.annotations];
	
	if ([_results count] >0) {
		NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[_results count]];
		for (NSDictionary *row in _results) {
			FZPointAnnotation *point = [[FZPointAnnotation alloc] init];
			point.coordinate = CLLocationCoordinate2DMake([row[@"latitude"] doubleValue], [row[@"logitude"] doubleValue]);
			point.rowData = row;
			[annotations addObject:point];
		}
		[self.mapView addAnnotations:annotations];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.mapView.delegate = self;
	self.mapView.showsUserLocation = YES;

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
