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

@interface FZPostPictureViewController : UIViewController {
    IBOutlet UIImageView *image;
    IBOutlet UITextView *description;
    NSString *remoteURL;
  
    NSMutableData *receivedData;
  
  BOOL didCancel;
}

@end