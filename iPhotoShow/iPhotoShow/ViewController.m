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

#define PHOTONUMBERS 5 //照片数量
@end

@implementation ViewController

#define dDeviceOrientation [[UIDevice currentDevice] orientation]
#define isPortrait  UIDeviceOrientationIsPortrait(dDeviceOrientation)
#define isLandscape UIDeviceOrientationIsLandscape(dDeviceOrientation)
#define isFaceUp    dDeviceOrientation == UIDeviceOrientationFaceUp   ? YES : NO
#define isFaceDown  dDeviceOrientation == UIDeviceOrientationFaceDown ? YES : NO

const CGFloat kScrollObjHeight	= 460;;
const CGFloat kScrollObjWidth	= 320;
//const CGFloat kScrollObjWidth	= 360;
@synthesize image_list;
@synthesize  helpPageCon;
@synthesize imageScrollView;

-(void)doMyLayoutStuff
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (isLandscape) { NSLog(@"Landscape"); }
    if(orientation == 0) {
        NSLog(@"default");
        //Default orientation
        //UI is in Default (Portrait) -- this is really a just a failsafe.
    }else if(orientation == UIInterfaceOrientationPortrait) {
        //Do something if the orientation is in Portrait
        NSLog(@"UIInterfaceOrientationPortrait");
    }else if(orientation == UIInterfaceOrientationLandscapeLeft) {
        // Do something if Left
        NSLog(@"UIInterfaceOrientationLandscapeLeft");
    }else if(orientation == UIInterfaceOrientationLandscapeRight) {
        NSLog(@"UIInterfaceOrientationLandscapeRight");
        //Do something if right
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    offset = 0.0;
    //self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScrollObjWidth, kScrollObjHeight)];
    self.imageScrollView.backgroundColor = [UIColor clearColor];
    self.imageScrollView.scrollEnabled = YES;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.delegate = self;
    self.imageScrollView.contentSize = CGSizeMake(kScrollObjWidth*[self.image_list count], kScrollObjHeight);
    imageScrollView.backgroundColor = [UIColor viewFlipsideBackgroundColor];

    for (NSInteger i = 0; i < [self.image_list count]; i++) {

        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];

        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(kScrollObjWidth*(i), 0, kScrollObjWidth, kScrollObjHeight)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(kScrollObjWidth, kScrollObjHeight);
        s.delegate = self;

        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScrollObjWidth, kScrollObjHeight)];
        imageview.tag = i+1;
        imageview.clipsToBounds = YES;
        imageview.userInteractionEnabled = YES;
        [imageview addGestureRecognizer:singleTap];
        [imageview addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        /*
        NSString *imageName = [[self.image_list objectAtIndex:i] objectForKey:@"url"];
        UIImageView *imageview =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageview.clipsToBounds = YES;
        imageview.userInteractionEnabled = YES;
        imageview.tag = i+1;
        [imageview addGestureRecognizer:singleTap];
        [imageview addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        s.contentSize = imageview.frame.size;
       
        [s addSubview:imageview];
        s.minimumZoomScale = s.frame.size.width / imageview.frame.size.width;
        s.maximumZoomScale = 2.0;
        [s setZoomScale:s.minimumZoomScale];
        */
        s.tag = 1000+i;
        [s addSubview:imageview];
        [self.imageScrollView addSubview:s];
    }
    
    helpPageCon.numberOfPages = [self.image_list count];
    helpPageCon.hidesForSinglePage = YES;
    helpPageCon.layer.zPosition = 100;
    imageScrollView.layer.zPosition = 8;
    
    imageScrollView.autoresizesSubviews = YES;
    imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.imageScrollView];
    //self.view = self.imageScrollView;
    
//    [[self view] setNeedsLayout];
    [self displayImageAtIndex:0];
}

-(void)displayImageAtIndex:(int)index
{
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:1000+index];
    UIImageView *imageView = [[scrollView subviews] objectAtIndex:0];
    if( !imageView.image ){
        NSString *imageName = [[self.image_list objectAtIndex:index] objectForKey:@"url"];
        UIImage *image =[UIImage imageNamed:imageName];
        [imageView setFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y,
                                       image.size.width, image.size.height)];
        [imageView setImage:[UIImage imageNamed:imageName]];
        scrollView.contentSize = imageView.frame.size;
        scrollView.minimumZoomScale = scrollView.frame.size.width / imageView.frame.size.width;
        scrollView.maximumZoomScale = 2.0;
        [scrollView setZoomScale:scrollView.minimumZoomScale];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)x
{
    return (x == UIInterfaceOrientationPortrait) || UIInterfaceOrientationIsLandscape(x);
}

#pragma mark -
-(void)handleSingleTap:(UIGestureRecognizer *)gesture{
    [self dismissModalViewControllerAnimated:YES];
}


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
   
    if (scrollView == self.imageScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        if (x==offset){
        
        }else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    UIImageView *image = [[s subviews] objectAtIndex:0];
                    [s setZoomScale: s.minimumZoomScale];
                    float minimumZoomScale = s.frame.size.width / image.bounds.size.width;
                    //[s setZoomScale:0.13];
                }
            }
        }
        ipage = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self displayImageAtIndex:ipage];
        /*
        UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:1000+ipage];
        UIImageView *imageView = [[scrollView subviews] objectAtIndex:0];
        if( !imageView.image ){
            NSString *imageName = [[self.image_list objectAtIndex:ipage] objectForKey:@"url"];
            //NSLog(@" url = %@", [[self.image_list objectAtIndex:ipage] objectForKey:@"url"]);
            NSLog(@" image view tag = %d", imageView.tag );
            UIImage *image =[UIImage imageNamed:imageName];
            // imageView.frame.size = image.size;
            [imageView setFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, image.size.width, image.size.height)];
            [imageView setImage:[UIImage imageNamed:imageName]];
            scrollView.contentSize = imageView.frame.size;
            scrollView.minimumZoomScale = scrollView.frame.size.width / imageView.frame.size.width;
            scrollView.maximumZoomScale = 2.0;
            [scrollView setZoomScale:scrollView.minimumZoomScale];
        }*/
        /*
        NSString *imageName = [[self.image_list objectAtIndex:i] objectForKey:@"url"];
        UIImageView *imageview =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageview.clipsToBounds = YES;
        imageview.userInteractionEnabled = YES;
        imageview.tag = i+1;
        [imageview addGestureRecognizer:singleTap];
        [imageview addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        s.contentSize = imageview.frame.size;
        
        [s addSubview:imageview];
        s.minimumZoomScale = s.frame.size.width / imageview.frame.size.width;
        s.maximumZoomScale = 2.0;
        [s setZoomScale:s.minimumZoomScale];
         */
        
    }
}


-(void)reZoomImageInScroll {
    for( UIScrollView *scrollView in self.imageScrollView.subviews ) {
        if( [scrollView isKindOfClass:[UIScrollView class]] ) {
            UIImageView *imageView = [[scrollView subviews] objectAtIndex:0];
            //float minimumZoomScale = scrollView.frame.size.width / imageView.bounds.size.width;
            //[scrollView setZoomScale:minimumZoomScale];
            [scrollView setZoomScale:scrollView.minimumZoomScale];
        }
    }
}

- (void)layoutPortailScrollImages {
    [self reZoomImageInScroll];
    UIScrollView *view = nil;
    CGFloat curXLoc = 0;
    for( view in [self.imageScrollView subviews ] ) {
        //is ui scroll view then
        if( [view isKindOfClass:[UIScrollView class] ]){
            UIImageView *imageView = nil;
            view.contentMode = UIViewContentModeScaleAspectFit;
            view.frame = CGRectMake(curXLoc, 0, kScrollObjWidth,kScrollObjHeight);
            for( imageView in [view subviews] ){
                // is ui image view  then
                if( [imageView isKindOfClass:[UIImageView class]] && imageView.tag > 0 ) {
                    UIImage *img = [imageView image];
                    if( img ) {
                        // view.contentSize = img.size;
                        view.contentSize = CGSizeMake(kScrollObjWidth,kScrollObjHeight);
                        view.minimumZoomScale = view.frame.size.width / img.size.width;
                        CGRect zoomRect;
                        if( view.minimumZoomScale < 1.0 ){
                            zoomRect.size.height = img.size.height * view.minimumZoomScale;
                            zoomRect.size.width  = kScrollObjWidth;
                            zoomRect.origin.x = 0;
                            zoomRect.origin.y = (kScrollObjHeight- zoomRect.size.height)/2;
                        }else {
                            zoomRect.size.height = kScrollObjHeight;
                            zoomRect.size.width = img.size.width * view.minimumZoomScale;
                            zoomRect.origin.x = (kScrollObjWidth-zoomRect.size.width)/2;
                            zoomRect.origin.y = 0;
                        }
                        [imageView setFrame:zoomRect];
                    }
                }
            }
            curXLoc += kScrollObjWidth;
        }
    }
    
    [imageScrollView setFrame:CGRectMake(0, 0, kScrollObjWidth,kScrollObjHeight)];
	// set the content size so it can be scrollable
	[imageScrollView setContentSize:CGSizeMake(([self.image_list count] * imageScrollView.frame.size.width), [imageScrollView bounds].size.height)];
    int page = helpPageCon.currentPage; //获取当前pagecontroll的值
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [imageScrollView setContentOffset:CGPointMake(kScrollObjWidth * ipage, 0) animated:NO];
}

- (void)layoutLandScapesScrollImages
{
    /*
    int page = helpPageCon.currentPage; //获取当前pagecontroll的值
    UIScrollView *scrollView = self.imageScrollView;
    for (UIScrollView *s in scrollView.subviews){
        if ([s isKindOfClass:[UIScrollView class]]){
            UIImageView *image = [[s subviews] objectAtIndex:0];
            float minimumZoomScale = s.frame.size.width / image.bounds.size.width;
            [s setZoomScale:minimumZoomScale];
        }
    }
     */

    float fw = imageScrollView.frame.size.width;
    float fh = imageScrollView.frame.size.height;
    
    [self reZoomImageInScroll];
    
	UIScrollView *scrollView = nil;
	NSArray *subviews = [imageScrollView subviews];
	CGFloat curXLoc = 0;
	for (scrollView in subviews)
	{
		if ([scrollView isKindOfClass:[UIScrollView class]] )
		{
            CGRect _frame = scrollView.frame;
            
            _frame.size.height = 300;
            _frame.size.width = 480;
            //[view setFrame:_frame];
            
            UIImageView *imageView = nil;
            NSArray *isubviews = [scrollView subviews];
          
            scrollView.contentMode = UIViewContentModeScaleAspectFit;
            //view.frame = CGRectMake(curXLoc, 0, fw,fh);
            scrollView.frame = CGRectMake(curXLoc, 0, 480,300);
            for( imageView in isubviews) {
                if ([imageView isKindOfClass:[UIImageView class]] && imageView.tag > 0)
                {                    
                    UIImage *image = [imageView image];
                    if(image){
                        // view.contentSize = img.size;
                        scrollView.contentSize = CGSizeMake(480,300);
                        
                        CGFloat scale = 480/300;
                        CGFloat image_scale = image.size.height / image.size.width;
                        CGRect zoomRect;
                        if( scale > image_scale ){
                            zoomRect.size.height = image.size.height / ( image.size.width/480 );
                            zoomRect.size.width  = 480;
                            zoomRect.origin.x = 0;
                            zoomRect.origin.y = (300- zoomRect.size.height)/2;
                        } else {
                            zoomRect.size.height = 300;
                            zoomRect.size.width =  image.size.width / ( image.size.height/300 );
                            zoomRect.origin.x = (480-zoomRect.size.width)/2;
                            zoomRect.origin.y = 0;
                        }
                        
                        //CGFloat scale = img.size.height/img.size.width;
                        
                        NSLog(@" scale = %f",scale);
                        // scrollView.minimumZoomScale = scrollView.frame.size.height / img.size.height;
                        
                       // scrollView.minimumZoomScale = scrollView.frame.size.width / imageView.frame.size.width;
                        NSLog(@" minimumZoomScale = %f",scrollView.minimumZoomScale);

                        /*
                        // view.contentSize = img.size;
                        scrollView.contentSize = CGSizeMake(480,300);
                       
                        CGFloat scale = scrollView.frame.size.width/img.size.width;
                        //CGFloat scale = img.size.height/img.size.width;
                        
                         NSLog(@" scale = %f",scale);
                       // scrollView.minimumZoomScale = scrollView.frame.size.height / img.size.height;
                        
                         NSLog(@" minimumZoomScale = %f",scrollView.minimumZoomScale);
                        
                        CGRect zoomRect;
                        if( scrollView.minimumZoomScale < 1.0 ){
                            zoomRect.size.height = img.size.height * scale;
                            zoomRect.size.width  = 480;
                            zoomRect.origin.x = 0;
                            zoomRect.origin.y = (300- zoomRect.size.height)/2;
                        }else {
                            zoomRect.size.height = 300;
                            zoomRect.size.width = img.size.width * scale;
                            zoomRect.origin.x = (480-zoomRect.size.width)/2;
                            zoomRect.origin.y = 0;
                        }
                         */
                        NSLog(@" width =%f, height = %f, x = %f, y=%f",zoomRect.size.width,zoomRect.size.height,zoomRect.origin.x, zoomRect.origin.y);
                        [imageView setFrame:zoomRect];
                    }
                     
                } 
            }
            curXLoc += fw;
		}
	}
    
    [imageScrollView setFrame:CGRectMake(0, 0, 480,300)];
	// set the content size so it can be scrollable
	[imageScrollView setContentSize:CGSizeMake(([self.image_list count] * imageScrollView.frame.size.width), [imageScrollView bounds].size.height)];
    //int page = helpPageCon.currentPage; //获取当前pagecontroll的值
    //NSLog(@" landscape page = %d", page);
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [imageScrollView setContentOffset:CGPointMake(fw * ipage, 0) animated:NO];
    //NSLog( @" content offset x end = %f",imageScrollView.contentOffset.x);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIImageView *image = [[scrollView subviews] objectAtIndex:0];
    image.frame = [self centeredFrameForScrollView:scrollView andUIView:image];;
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




-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //NSLog(@"scroll offset x = %f",imageScrollView.contentOffset.x);
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    //[[self view] setNeedsLayout];
   // NSLog(@" current page = %d", helpPageCon.currentPage);
    UIDeviceOrientation currentOrientation  = [[UIDevice currentDevice] orientation];
   // NSLog(@"did rotate from %d", currentOrientation);
    if( currentOrientation == 1 || currentOrientation == 2 ) {
        [self layoutPortailScrollImages];
    }else {
        //NSLog( @" content offset x start = %f",imageScrollView.contentOffset.x);
        [self layoutLandScapesScrollImages];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == imageScrollView) {
        if( scrollView.tag > 0 ){
            
        }else {
            CGFloat pageWidth = scrollView.frame.size.width;
            int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            helpPageCon.currentPage = page;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)imagepagechange:(id)sender {
    NSLog(@"iamge page change ");
    int page = helpPageCon.currentPage; //获取当前pagecontroll的值
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [self.imageScrollView setContentOffset:CGPointMake(kScrollObjWidth * page, 0) animated:YES];
}

@end
