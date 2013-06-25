//
//  IndexViewController.m
//  iPhotoShow
//
//  Created by 川 on 4/10/13.
//  Copyright (c) 2013 com.huangxc. All rights reserved.
//

#import "IndexViewController.h"
#import "ViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{   
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTheImageSlide:(id)sender {
    ViewController *vc = [[ViewController alloc]init];
    //vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //vc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    NSMutableDictionary *img1 = [[NSMutableDictionary alloc]init];
    [img1 setObject:@"image1.jpg" forKey:@"url"];
    [img1 setObject:@"image1 text" forKey:@"text"];
    NSMutableDictionary *img2 = [[NSMutableDictionary alloc]init];
    [img2 setObject:@"image2.jpg" forKey:@"url"];
    [img2 setObject:@"image2 text" forKey:@"text"];
    NSMutableDictionary *img3 = [[NSMutableDictionary alloc]init];
    [img3 setObject:@"image3.jpg" forKey:@"url"];
    [img3 setObject:@"image3 text" forKey:@"text"];
    NSMutableDictionary *img4 = [[NSMutableDictionary alloc]init];
    [img4 setObject:@"image4.jpg" forKey:@"url"];
    [img4 setObject:@"image4 text" forKey:@"text"];
    NSMutableDictionary *img5 = [[NSMutableDictionary alloc]init];
    [img5 setObject:@"image5.jpg" forKey:@"url"];
    [img5 setObject:@"image5 text" forKey:@"text"];
    NSArray *images = [NSArray arrayWithObjects:img1,img2,img3,img4,img5,nil];
    vc.image_list = images;

    //NSMutableDictionary *mutableDict = [[dictionary mutableCopy] autorelease];
    [self presentModalViewController:vc animated:YES];
   
    //UIViewAnimationTransition trans = UIViewAnimationTransitionCurlDown;
    //[UIView beginAnimations: nil context: nil];
    //[UIView setAnimationTransition: trans forView: [self view] cache: YES];
    //[self presentModalViewController:vc animated:NO];
    //[UIView commitAnimations];
    
}
@end
