//
//  ZoomViewController.m
//  Zoom
//
//  Created by Fernando Bunn on 10/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ZoomViewController.h"

@implementation ZoomViewController

- (void)loadView {
	UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	scroll.backgroundColor = [UIColor blackColor];
	scroll.delegate = self;
	image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test.jpg"]];
    NSLog(@"image origin x%f", image.frame.origin.x);
    NSLog(@"image origin y%f", image.frame.origin.y);
    
    NSLog(@"image size width %f", image.frame.size.width);
    NSLog(@"image size height %f", image.frame.size.height);
	scroll.contentSize = image.frame.size;
	[scroll addSubview:image];
	
	scroll.minimumZoomScale = scroll.frame.size.width / image.frame.size.width;
	scroll.maximumZoomScale = 2.0;
	[scroll setZoomScale:scroll.minimumZoomScale];

	self.view = scroll;
	[scroll release];

}

- (void)viewDidUnload {
	[image release], image = nil;
}


- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
	CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
	
	return frameToCenter;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
   image.frame = [self centeredFrameForScrollView:scrollView andUIView:image];;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return image;
}


- (void)dealloc {
    [super dealloc];
}

@end
