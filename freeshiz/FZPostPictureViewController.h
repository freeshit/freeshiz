//
//  FZPostPictureViewController.h
//  freeshiz
//
//  Created by Zac Bowling on 12/1/12.
//  Copyright (c) 2012 freeshiz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FPPicker/FPPicker.h>
#import <Firebase/Firebase.h>

@interface FZPostPictureViewController : UIViewController <FPPickerDelegate, NSURLConnectionDelegate> {
    IBOutlet UIImageView *image;
    IBOutlet UITextView *description;
    NSString *remoteURL;
  
    NSMutableData *receivedData;
}
@property (nonatomic, retain) UIImageView *image;
- (IBAction)pickerModalAction: (id) sender;
-(IBAction)postItem:(id)sender;
-(NSMutableURLRequest*)postItemURLRequest;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end