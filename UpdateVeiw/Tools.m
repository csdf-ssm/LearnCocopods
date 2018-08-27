//
//  Tools.m
//  DocumentWatermarking
//
//  Created by apple on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "Tools.h"
#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation Tools

+(CAShapeLayer*)currentView:(UIView*)view andUIRectCorner:(UIRectCorner)corner andSize:(CGFloat)size andBorderWith:(CGFloat)borderWidth andBorderColor:(UIColor*)borderColor{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(size, size)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = view.backgroundColor.CGColor;
    layer.strokeColor = borderColor.CGColor;
    layer.lineWidth = borderWidth;
    return layer;
}


//截取指定视图的图片
+(UIImage *)imageFromView:(UIView*)theView{
    
    NSLog(@"%f", [UIScreen mainScreen].scale);
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, 0);//开启高清模式
    
    //    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;

}
//裁剪指定区域图片
+(UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)r{
    
//    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0.0);
////    UIGraphicsBeginImageContext(theView.frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    UIRectClip(r);
//    [theView.layer renderInContext:context];
//
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
//    UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, 0.0);
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIRectClip(r);
    CGContextSaveGState(context);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

//获得某个范围内的图像
+ (UIImage *)imageFromImage: (UIImage *) image   atFrame:(CGRect)r{
    
//    UIGraphicsBeginImageContext(size)
//    image.drawInRect(CGRectMake(0, 0, size.width, size.height))
//    var newImage=UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return newImage
    
//    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, r.size.width, r.size.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;

    //下面的注释需要的话要打开
//    UIGraphicsBeginImageContextWithOptions(image.size,NO,kDeviceScale);
//    r.origin.x = r.origin.x*kDeviceScale;
//    r.origin.y = r.origin.y *kDeviceScale;
//    r.size.width = r.size.width*kDeviceScale;
//    r.size.height = r.size.height *kDeviceScale;
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, r);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    return newImage;
}
//处理图片旋转的问题
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    
    
    // No-op if the orientation is already correct
    
    if (aImage.imageOrientation ==UIImageOrientationUp)
        
        return aImage;
    
    
    
    // We need to calculate the proper transformation to make the image upright.
    
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    
    CGAffineTransform transform =CGAffineTransformIdentity;
    
    
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationDown:
            
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            
            transform = CGAffineTransformRotate(transform, M_PI);
            
            break;
            
            
            
        case UIImageOrientationLeft:
            
        case UIImageOrientationLeftMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            
            transform = CGAffineTransformRotate(transform, M_PI_2);
            
            break;
            
            
            
        case UIImageOrientationRight:
            
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            
            break;
            
        default:
            
            break;
            
    }
    
    
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationUpMirrored:
            
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
            
            
        case UIImageOrientationLeftMirrored:
            
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
            
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
        default:
            
            break;
            
    }
    
    
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    
    // calculated above.
    
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            
                                            CGImageGetBitsPerComponent(aImage.CGImage),0,
                                            
                                            CGImageGetColorSpace(aImage.CGImage),
                                            
                                            CGImageGetBitmapInfo(aImage.CGImage));
    
    CGContextConcatCTM(ctx, transform);
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationLeft:
            
        case UIImageOrientationLeftMirrored:
            
        case UIImageOrientationRight:
            
        case UIImageOrientationRightMirrored:
            
            // Grr...
            
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            
            break;
            
            
            
        default:
            
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            
            break;
            
    }
    
    
    
    // And now we just create a new UIImage from the drawing context
    
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGContextRelease(ctx);
    
    CGImageRelease(cgimg);
    
    return img;
    
}

+ (NSString *)moneyNumFormatter:(NSString *)money{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[money doubleValue]]];
    return formattedNumberString;
}

+ (NSString *)moneyFloatNumFormatter:(NSString *)money{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[money doubleValue]]];
    return formattedNumberString;
}


+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string andChangeStringArr:(NSArray *)changeStringArr andColor:(UIColor *)color andFont:(UIFont *)font{
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:string];
    NSString *temp = nil;
    for (NSString*changeString in changeStringArr) {
        for(int i =0; i < (hintString.length - changeString.length); i++) {
            temp = [string substringWithRange:NSMakeRange(i, changeString.length)];
            if ([temp isEqualToString:changeString]) {
                [hintString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           color, NSForegroundColorAttributeName,
                                           font,NSFontAttributeName, nil]
                                    range:NSMakeRange(i, changeString.length)];
            }
        }
    }
    return hintString;
}



+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string andChangeString:(NSString *)changeString andColor:(UIColor *)color andFont:(UIFont *)font{
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range1=[[hintString string]rangeOfString:changeString];
    [hintString addAttribute:NSForegroundColorAttributeName value:color range:range1];
    [hintString addAttribute:NSFontAttributeName value:font range:range1];
    return hintString;
}

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string andLocation:(NSRange)range andForeGroundColor:(UIColor *)color andBackGrounfColor:(UIColor*)bgColor andFont:(UIFont *)font {
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:string];
    if (color) {
        [hintString addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    if (bgColor) {
        [hintString addAttribute:NSBackgroundColorAttributeName value:bgColor range:range];
    }
    [hintString addAttribute:NSFontAttributeName value:font range:range];
    return hintString;
}

+(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height
{
    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
    CGRect rect=[string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}

+(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds=[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    return bounds.size.height;
}

//图片合成
+(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 andSpace:(CGFloat)space{
    
//    CGSize size = CGSizeMake(image1.size.width>image2.size.width?image1.size.width*kDeviceScale:image2.size.width*kDeviceScale, image1.size.height*kDeviceScale+image2.size.height*kDeviceScale+space*kDeviceScale);
//    //    UIGraphicsBeginImageContext(size);
//    UIGraphicsBeginImageContextWithOptions(size, NO, kDeviceScale);
//
//    // Draw image1
//    [image1 drawInRect:CGRectMake(0, 0, image1.size.width*kDeviceScale, image1.size.height*kDeviceScale)];
//
//    // Draw image2
//    [image2 drawInRect:CGRectMake(0, image1.size.height*kDeviceScale+space*kDeviceScale, image2.size.width*kDeviceScale, image2.size.height*kDeviceScale)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}


//图片合成
+(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2{
    
//    CGSize size = CGSizeMake(image1.size.width>image2.size.width?image1.size.width*kDeviceScale:image2.size.width*kDeviceScale, image1.size.height*kDeviceScale+image2.size.height*kDeviceScale+5);
////    UIGraphicsBeginImageContext(size);
//    UIGraphicsBeginImageContextWithOptions(size, NO, kDeviceScale);
//
//    // Draw image1
//    [image1 drawInRect:CGRectMake(0, 0, image1.size.width*kDeviceScale, image1.size.height*kDeviceScale)];
//
//    // Draw image2
//    [image2 drawInRect:CGRectMake(0, image1.size.height*kDeviceScale+5, image2.size.width*kDeviceScale, image2.size.height*kDeviceScale)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

//图片灰度处理
+(UIImage *)convertImageToGreyScale:(UIImage *)image{

    const int RED =1;
    const int GREEN =2;
    const int BLUE =3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0,0, image.size.width* image.scale, image.size.height* image.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t*) malloc(width * height *sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels,0, width * height *sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,8, width *sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context,CGRectMake(0,0, width, height), [image CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t*) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] +0.59 * rgbaPixel[GREEN] +0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(imageRef);
    
    return resultUIImage;
}


+(NSString *)deviceString{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return platform;

}

//md5加密
+ (NSString *)stringToMD5:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


//获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
    
}

NSString*safeString(id string){
//    if (IsNilOrNull(string)) {
//        return @"";
//    }
    return [NSString stringWithFormat:@"%@",string];
}

//设置图片的锚点
+ (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

//设置回原来的锚点
+ (void)setDefaultAnchorPointforView:(UIView *)view
{
    [self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:view];
}


/**
 *  拍照
 *
 *  @param viewController 代理控制器
 */
+(void) takePhoto:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)viewController
{
    [Tools acquireMediaType:AVMediaTypeVideo Auth:^(BOOL grant){
        
        if (grant) {
            
            if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])) {
                UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
                cameraUI.delegate = viewController;
                cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
                cameraUI.allowsEditing = YES;
                if([[[UIDevice
                      currentDevice] systemVersion] floatValue]>=8.0) {
                    ((UIViewController *)viewController).modalPresentationStyle=UIModalPresentationOverCurrentContext;
                }
                
                [(UIViewController *)viewController presentViewController:cameraUI animated:YES completion:nil];
                
            }
            else {
            }
        }
        
    }];
}

/**
 *  单相片选择
 *
 *  @param viewController 代理控制器
 */
+(void)selectOnePhoto:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)viewController{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    NSLog(@"状态%zd",author);
    
    if(author ==ALAuthorizationStatusRestricted){
        //此应用程序没有被授权访问的照片数据
        
    }
    else if(author == ALAuthorizationStatusDenied){
        
        // 用户已经明确否认了这一照片数据的应用程序访问
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                              
                                                        message:@"您已设置不允许访问相册,请在设备的设置-隐私-照片中允许访问照片。"
                              
                                                       delegate:nil
                              
                                              cancelButtonTitle:@"确定"
                              
                                              otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    else if(author == ALAuthorizationStatusAuthorized){
        //允许访问
    }else{
        //用户尚未做出了选择这个应用程序的问候
    }
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])) {
        UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.delegate = viewController;
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.allowsEditing = NO;
        if([[[UIDevice
              currentDevice] systemVersion] floatValue]>=8.0) {
            ((UIViewController *)viewController).modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }
        [(UIViewController *)viewController presentViewController:cameraUI animated:YES completion:nil];
    }
}

/**
 *  请求相机权限
 *
 *  @param mediaType 类型
 *  @param block     返回值
 */
+(void)acquireMediaType:(NSString *)mediaType Auth:(void (^)(BOOL grant))block;
{
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ( granted ) {
                block(YES);
            }
            else {
                
                block (NO);
            }
        });
        
    }];
}

/**
 *  请求相册权限
 *
 *  @param block     返回值
 */
+(void)acquirePhotoAuth:(void (^)(BOOL grant))block
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

        if (status == PHAuthorizationStatusAuthorized) {
            //这里就是用权限
            block(YES);
        }  else {
            // 这里便是无访问权限
            //可以弹出个提示框，叫用户去设置打开相册权限
            block(NO);
        }
        });

    }];
    
}


//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    
    NSString *emailRegex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}
//手机号码验证
+ (BOOL)validateMobile:(NSString *)phone{
    
    NSString *MOBILE = @"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(16[6])|(17[0,1,3,5-8])|(18[0-9])|(19[8,9]))\\d{8}$";
    
    NSPredicate *regexTestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    
    if ([regexTestMobile evaluateWithObject:phone]) {
        return YES;
    }else {
        return NO;
    }
}

//身份证号判断
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber
{
//    if (IDCardNumber.length <= 0) {
//        return NO;
//    }
    
    NSString *regex2 = @"[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9Xx])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if ([identityCardPredicate evaluateWithObject:IDCardNumber]) {
        return YES;
    }else {
        return NO;
    }
}

+(NSString*)stringWithUrl:(NSString*)urlString anduser:(NSString *)string{
    NSString *url = @"";
    if (string==nil||[string isEqualToString:@""]) {
        url = [NSString stringWithFormat:urlString,@"me"];
    }
    else{
        url = [NSString stringWithFormat:urlString,string];
    }
    return url;
}

//处理手机号
+(NSString *)phoneNumByX:(NSString *)phoneNum{
    if (phoneNum && ![phoneNum isKindOfClass:[NSNull class]]) {
        if (phoneNum.length<4) {
            return phoneNum;
        }
        NSString * stringHead = [phoneNum substringToIndex:3];
        NSString * stringTail = [phoneNum substringFromIndex:phoneNum.length-4];
        return [NSString stringWithFormat:@"%@****%@",stringHead,stringTail];
    }
    else{
        return [phoneNum description];
    }
}

//处理邮箱
+(NSString *)emailNumByX:(NSString *)emailNum{
    
    if (emailNum && ![emailNum isKindOfClass:[NSNull class]]) {
        
        NSString *eamilPreString = [emailNum substringToIndex:[emailNum rangeOfString:@"@"].location];
        
        NSString *emailEndString = [emailNum substringFromIndex:[emailNum rangeOfString:@"@"].location];
        if (eamilPreString.length<8) {
            return emailNum;
        }
        NSString * stringHead = [eamilPreString substringToIndex:3];
        NSString * stringTail = [eamilPreString substringFromIndex:eamilPreString.length-4];
        return [NSString stringWithFormat:@"%@****%@%@",stringHead,stringTail,emailEndString];
    }
    else{
        return [emailNum description];
    }
}


//===============以下是正则表达式匹配===========//
+ (BOOL)isPhoneNumber:(NSString*)string {
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:string];
    
    if (!isMatch)
        return NO;
    return YES;
    
}

//或者精确点，但需要根据运营商更新
+ (BOOL)wl_isMobileNumberClassification:(NSString*)string {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\\\d|705)\\\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17
     */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\\\d|709)\\\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700,177
     22
     */
    NSString * CT = @"^1((33|53|77|8[09])\\\\d|349|700)\\\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28
     */
    NSString * PHS = @"^0(10|2[0-5789]|\\\\d{3})\\\\d{7,8}$";
    
    if (([self isValidateByRegex:CM andString:string])
        || ([self isValidateByRegex:CU andString:string])
        || ([self isValidateByRegex:CT andString:string])
        || ([self isValidateByRegex:PHS andString:string])) {
        return YES;
    }else {
        return NO;
    }
}

//验证邮箱
+ (BOOL)isEmailAddress:(NSString*)string {
    //^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$
    
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [emailTest evaluateWithObject:string];
    
}

//验证密码
+ (BOOL)isValidPassword:(NSString*)string{
    //以字母开头，只能包含“字母”，“数字”，“下划线”，长度6~18
    NSString *regex = @"^([a-zA-Z]|[a-zA-Z0-9_]|[0-9]){6,18}$";
    return [self isValidateByRegex:regex andString:string];
}

+ (BOOL)isValidateByRegex:(NSString *)regex andString:(NSString*)string{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:string];
}


@end
