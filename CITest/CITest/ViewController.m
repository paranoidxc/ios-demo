//
//  ViewController.m
//  CITest
//
//  Created by 川 on 4/16/13.
//  Copyright (c) 2013 com.huangxc. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLIbrary/AssetsLibrary.h>
#import "UIImage+Resize.h"

@interface ViewController ()

@end
 
@implementation ViewController {
    CIContext *context;
    CIFilter *filter;
    CIImage *beginImage;
    CIImage *maskImage;
    CGContextRef cgcontext;
    
}

@synthesize imgV;
@synthesize amountSlider;
@synthesize maskModeButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCGContext];
	// Do any additional setup after loading the view, typically from a nib.
    
    maskImage = [CIImage imageWithCGImage:
                [UIImage imageNamed:@"sampleMaskPng.png"].CGImage];
    
    NSString *filePath =
    [[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"];
    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    
     context = [CIContext contextWithOptions:nil];
    // use cpu
    //context = [CIContext contextWithOptions:
    //           [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
    //                                       forKey:kCIContextUseSoftwareRenderer]];
    
    filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg =
    [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    [imgV setImage:newImg];
    CGImageRelease(cgimg);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeValue:(UISlider *)sender {
    float slideValue = [sender value];
    [filter setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputIntensity"];
    CIImage *outputImage = [filter outputImage];
    
    
    if ([maskModeButton.titleLabel.text isEqualToString:
         @"Mask Mode Off"]) {
        CIFilter *maskFilter = [CIFilter filterWithName:
                                @"CISourceAtopCompositing" keysAndValues:kCIInputImageKey,
                                outputImage, @"inputBackgroundImage", maskImage, nil];
        outputImage = maskFilter.outputImage;
    }
    outputImage = [self addBackgroundLayer:outputImage];
    CGImageRef cgimg =
    [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    [imgV setImage:newImg];
    CGImageRelease(cgimg);
}

- (IBAction)loadPhoto:(id)sender {
    UIImagePickerController *pickerC =  [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    [self presentModalViewController:pickerC animated:YES];
}

- (IBAction)savePhoto:(id)sender {
    CIImage *saveToSave = [filter outputImage];
    CGImageRef cgImg =
    [context createCGImage:saveToSave fromRect:[saveToSave extent]];
    
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgImg
                                 metadata:[saveToSave properties]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              CGImageRelease(cgImg);
                          }];

    
}

- (IBAction)maskMode:(id)sender {
    CIFilter *maskFilter = [CIFilter filterWithName:@"CISourceAtopCompositing" keysAndValues:kCIInputImageKey, [filter outputImage], @"inputBackgroundImage", maskImage, nil];
    
    CIImage *outputImage = [maskFilter outputImage];
    if ([maskModeButton.titleLabel.text
         isEqualToString:@"Mask Mode Off"]) {
        [maskModeButton setTitle:@"Mask Mode"
                        forState:UIControlStateNormal];
        outputImage = [filter outputImage];
    } else {
        [maskModeButton setTitle:@"Mask Mode Off"
                        forState:UIControlStateNormal];
    }
    
    outputImage = [self addBackgroundLayer:outputImage];
    CGImageRef cgImg = [context createCGImage:outputImage
                                     fromRect:[outputImage extent]];
    [imgV setImage:[UIImage imageWithCGImage:cgImg]];
    CGImageRelease(cgImg);
}

-(CIImage *)addBackgroundLayer:(CIImage *)inputImage {
    CIImage *bg = [CIImage imageWithCGImage:[UIImage
                                             imageNamed:@"bryce.png"].CGImage];
    CIFilter *sourceOver = [CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:kCIInputImageKey, inputImage,
                            @"inputBackgroundImage", bg, nil];
    return sourceOver.outputImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissModalViewControllerAnimated:YES];
    
    UIImage *gotImage =[info objectForKey:UIImagePickerControllerOriginalImage];
    gotImage = [gotImage scaleToSize:[beginImage extent].size];
    
    beginImage = [CIImage imageWithCGImage:gotImage.CGImage];
    [filter setValue:beginImage forKey:kCIInputImageKey];
    [self changeValue:amountSlider];
    
    //NSLog(@"%@", info);
}
- (void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)setupCGContext {
    NSUInteger width = 320;
    NSUInteger height = 213;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    cgcontext = CGBitmapContextCreate(NULL, width,
                                      height, bitsPerComponent, bytesPerRow, colorSpace,
                                      kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
}

-(CGImageRef)drawMyCircleMask:(CGPoint)location reset:(BOOL)reset {
    if (reset) {
        CGContextClearRect(cgcontext, CGRectMake(0, 0, 320, 213));
    }
    CGContextSetRGBFillColor(cgcontext, 1, 1, 1, .7);
    CGContextFillEllipseInRect(cgcontext, CGRectMake(
                                                     location.x - 25, location.y - 25, 50.0, 50.0));
    CGImageRef cgImg = CGBitmapContextCreateImage(cgcontext);
    return cgImg;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint loc = [[touches anyObject] locationInView:imgV];
    if (loc.y <= 213 && loc.y >= 0) {
        loc = CGPointMake(loc.x, imgV.frame.size.height - loc.y);
        CGImageRef cgimg = [self drawMyCircleMask:loc reset:YES];
        maskImage = [CIImage imageWithCGImage:cgimg];
        [self changeValue:amountSlider];
        //UIImage *img = [UIImage imageWithCGImage:cgimg];
        //imgV.image = img;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint loc = [[touches anyObject] locationInView:imgV];
    if (loc.y <= 213 && loc.y >= 0) {
        loc = CGPointMake(loc.x, imgV.frame.size.height - loc.y);
        CGImageRef cgimg = [self drawMyCircleMask:loc reset:NO];
        maskImage = [CIImage imageWithCGImage:cgimg];
        [self changeValue:amountSlider];
    }
}

@end
