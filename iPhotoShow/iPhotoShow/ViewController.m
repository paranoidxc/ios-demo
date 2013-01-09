//
//  ViewController.m
//  iPhotoShow
//
//  Created by 川 on 12/19/12.
//  Copyright (c) 2012 com.huangxc. All rights reserved.
//

#import "ViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface ViewController ()

#define PHOTONUMBERS 8  //照片数量
@end

@implementation ViewController

const CGFloat kScrollObjHeight	= 460;;
const CGFloat kScrollObjWidth	= 320;
//const CGFloat kScrollObjWidth	= 360;

@synthesize  helpPageCon;
@synthesize imageScrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    offset = 0.0;
    //self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
   
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScrollObjWidth, kScrollObjHeight)];
    //self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-20, 0, kScrollObjWidth, kScrollObjHeight)];
    self.imageScrollView.backgroundColor = [UIColor clearColor];
    self.imageScrollView.scrollEnabled = YES;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.delegate = self;
    self.imageScrollView.contentSize = CGSizeMake(kScrollObjWidth*PHOTONUMBERS, kScrollObjHeight);
    imageScrollView.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    for (int i = 1; i<=PHOTONUMBERS; i++){
        
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(kScrollObjWidth*(i-1), 0, kScrollObjWidth, kScrollObjHeight)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(kScrollObjWidth, kScrollObjHeight);
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        [s setZoomScale:1.0];
        s.tag = i;
        
        /*
        UIImageView *imageview = [[UIImageView alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"image%d.jpg",i];
        imageview.image = [UIImage imageNamed:imageName];
        imageview.frame = CGRectMake(20, 0, kScrollObjWidth-40, kScrollObjHeight);
        */
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScrollObjWidth, kScrollObjHeight)];
        NSString *imageName = [NSString stringWithFormat:@"image%d.jpg", i];
        imageview.image = [UIImage imageNamed:imageName];
        
        
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        //imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.clipsToBounds = YES;
        imageview.userInteractionEnabled = YES;
        imageview.tag = i;
        [imageview addGestureRecognizer:doubleTap];
        
        [s addSubview:imageview];
        [self.imageScrollView addSubview:s];
    }
    
    helpPageCon.numberOfPages = PHOTONUMBERS;
    helpPageCon.hidesForSinglePage = YES;
    helpPageCon.layer.zPosition = 1;
    
    imageScrollView.autoresizesSubviews = YES;
    imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.imageScrollView];
}

#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    [(UIScrollView*)gesture.view.superview zoomToRect:zoomRect animated:YES];
}

#pragma mark - Utility methods

- (CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.imageScrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x==offset){
            
        }
        else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    
                    //UIImageView *image = [[s subviews] objectAtIndex:0];
                    //image.frame = CGRectMake(20, 0, kScrollObjWidth, kScrollObjHeight);
                    
                }
            }
        }
    }
}
- (void)rlayoutScrollImages
{
    float fw = imageScrollView.frame.size.width;
    float fh = imageScrollView.frame.size.height;
    
    NSLog( @" scroll width %f",fw);
    NSLog( @" scroll height %f",fh);
    
	UIScrollView *view = nil;
	NSArray *subviews = [imageScrollView subviews];
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIScrollView class]] )
		{
            UIImageView *iview = nil;
            NSArray *isubviews = [view subviews];
          
            view.contentMode = UIViewContentModeScaleAspectFit;
            view.frame = CGRectMake(curXLoc, 0, fw,fh);
            for( iview in isubviews) {
                
                if ([iview isKindOfClass:[UIImageView class]] && iview.tag > 0)
                {
                    iview.contentMode = UIViewContentModeScaleAspectFit;
                    iview.frame = CGRectMake(0, 0, fw,fh);
                } 
            }
            curXLoc += fw;
			
		}
	}
     
	// set the content size so it can be scrollable
	[imageScrollView setContentSize:CGSizeMake((PHOTONUMBERS * imageScrollView.frame.size.width), [imageScrollView bounds].size.height)];
    int page = helpPageCon.currentPage; //获取当前pagecontroll的值
    NSLog(@" page = %d", page);
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    
    [imageScrollView setContentOffset:CGPointMake(fw * page, 0) animated:NO];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    UIDeviceOrientation currentOrientation  = [[UIDevice currentDevice] orientation];
    NSLog(@"did rotate from %d", currentOrientation);
   [self rlayoutScrollImages];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if( scrollView.tag > 0 ){
        
    }else {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        helpPageCon.currentPage = page;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
