//
//  ViewController.h
//  kinship
//
//  Created by PINCHAO LIU on 4/9/17.
//  Copyright © 2017 PINCHAO LIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIButton *takeFirstPic;

@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIButton *takeSecondPic;

- (IBAction)takeFirstPic:(id)sender;
- (IBAction)selectFirstPic:(id)sender;
- (IBAction)takeSecondPic:(id)sender;
- (IBAction)selectSecondPic:(id)sender;
- (IBAction)checkResult:(id)sender;
- (void)didReceiveMemoryWarning;

@property(nonatomic) NSInteger imagePicked;

@end

