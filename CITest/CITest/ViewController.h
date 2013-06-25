//
//  ViewController.h
//  CITest
//
//  Created by 川 on 4/16/13.
//  Copyright (c) 2013 com.huangxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UISlider *amountSlider;
@property (strong, nonatomic) IBOutlet UIButton *maskModeButton;
- (IBAction)changeValue:(UISlider *)sender;
- (IBAction)loadPhoto:(id)sender;

- (IBAction)savePhoto:(id)sender;
- (IBAction)maskMode:(id)sender;

-(CIImage *)addBackgroundLayer:(CIImage *)inputImage;
@end
