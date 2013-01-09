//
//  ViewController.h
//  iPhotoShow
//
//  Created by 川 on 12/19/12.
//  Copyright (c) 2012 com.huangxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate> {
    CGFloat offset;
}

@property (strong, nonatomic) IBOutlet UIPageControl *helpPageCon;
@property (nonatomic, retain) UIScrollView *imageScrollView;
- (IBAction)imagepagechange:(id)sender;
@end
