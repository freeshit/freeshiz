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
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)picture:(id)sender;
@end