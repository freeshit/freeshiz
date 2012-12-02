//
//  FZSearchMapViewController.m
//  freeshiz
//
//  Created by Zac Bowling on 12/1/12.
//  Copyright (c) 2012 freeshiz. All rights reserved.
//

#import <SinglySDK/SinglySDK.h>
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
	BOOL _updated;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserverForName:FZSearchResponseNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			_results = note.userInfo[@"results"];
			[self loadFromResults];
		}];
		_updated = NO;
    }
    return self;
}

- (void)loadFromResults {
	[self.mapView removeAnnotations:[self.mapView.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		return [evaluatedObject isKindOfClass:[FZPointAnnotation class]];
	}]]];
	
	if ([_results count] >0) {
		NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[_results count]];
		
		//work around temporary API change over
		if ([_results isKindOfClass:[NSDictionary class]]){
			_results = [(NSDictionary *)_results allValues];
		}
		for (NSDictionary *row in _results) {
			FZPointAnnotation *point = [[FZPointAnnotation alloc] init];
			point.coordinate = CLLocationCoordinate2DMake([row[@"lat"] doubleValue], [row[@"lon"] doubleValue]);
			point.rowData = row;
			point.title = row[@"description"];
			[annotations addObject:point];
		}
		[self.mapView addAnnotations:annotations];
	}
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
	
	if ([annotation isKindOfClass:[FZPointAnnotation class]]){
		MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
		if (!pin) {
			pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
		}
		pin.pinColor = MKPinAnnotationColorGreen;
		
		
		UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		pin.rightCalloutAccessoryView = detailButton;
		pin.canShowCallout = YES;
		return pin;
		
	}
	return nil;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
	if (!_updated){
		MKCoordinateRegion mapRegion;
		mapRegion.center = mapView.userLocation.coordinate;
		mapRegion.span.latitudeDelta = 0.2;
		mapRegion.span.longitudeDelta = 0.2;
		
		[mapView setRegion:mapRegion animated: YES];
		_updated = YES;
	}
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  SinglyService *service = [SinglyService serviceWithIdentifier:@"facebook"];
  [service requestAuthorizationWithViewController:self];
  
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
