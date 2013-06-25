//
//  ViewController.h
//  iPhotoShow
//
//  Created by 川 on 12/19/12.
//  Copyright (c) 2012 com.huangxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate,UIApplicationDelegate> {
    CGFloat offset;
    int ipage;
}
@property (strong, nonatomic)NSArray *image_list;
@property (strong, nonatomic) IBOutlet UIPageControl *helpPageCon;
@property (nonatomic, retain) UIScrollView *imageScrollView;
- (IBAction)imagepagechange:(id)sender;
- (void)doMyLayoutStuff;
@end
