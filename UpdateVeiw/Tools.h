//
//  Tools.h
//  DocumentWatermarking
//
//  Created by apple on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Tools : NSObject

//画边框
+(CAShapeLayer*)currentView:(UIView*)view andUIRectCorner:(UIRectCorner)corner andSize:(CGFloat)size andBorderWith:(CGFloat)borderWidth andBorderColor:(UIColor*)borderColor;
//截取指定视图的图片
+(UIImage *)imageFromView:(UIView*)theView;
//获得某个范围内的屏幕图像
+ (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r;
//获得某个范围内的图像
+ (UIImage *)imageFromImage: (UIImage *) image   atFrame:(CGRect)r;
//处理图片旋转的问题
+ (UIImage *)fixOrientation:(UIImage *)aImage ;
//图片合成
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 ;
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 andSpace:(CGFloat)space;
//千分符
+ (NSString *)moneyNumFormatter:(NSString *)money;
//带有小数点的千分符
+ (NSString *)moneyFloatNumFormatter:(NSString *)money;
//自定义String
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string andChangeStringArr:(NSArray *)changeStringArr andColor:(UIColor *)color andFont:(UIFont *)font;
//自定义String
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string andChangeString:(NSString *)changeString andColor:(UIColor *)color andFont:(UIFont *)font;
//自定义指定位置的String
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string andLocation:(NSRange)range andForeGroundColor:(UIColor *)color andBackGrounfColor:(UIColor*)bgColor andFont:(UIFont *)font ;
//获取文字宽度
+(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height;
//获取文字高度
+(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;

//照片转黑白
+ (UIImage*) convertImageToGreyScale:(UIImage*) image;

//获取设备
+(NSString *)deviceString;

/**
 MD5加密
 */
+ (NSString *)stringToMD5:(NSString *)string;
//获取当前时间戳  （以毫秒为单位）
+ (NSString *)getNowTimeTimestamp;

NSString*safeString(id string);

//设置图片的锚点
+ (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;
//设置回原来的锚点
+ (void)setDefaultAnchorPointforView:(UIView *)view;

/**
 *  拍照
 *
 *  @param viewController 代理控制器
 */
+(void) takePhoto:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)viewController;
/**
 *  单相片选择
 *
 *  @param viewController 代理控制器
 */
+(void)selectOnePhoto:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)viewController;

//相机权限问题
+(void)acquireMediaType:(NSString *)mediaType Auth:(void (^)(BOOL grant))block;
/**
 *  请求相册权限
 */
+(void)acquirePhotoAuth:(void (^)(BOOL grant))block;

//邮箱
+ (BOOL) validateEmail:(NSString *)email;
//手机号码验证
+ (BOOL)validateMobile:(NSString *)phone;

//统一请求路劲
+(NSString*)stringWithUrl:(NSString*)string anduser:(NSString *)string;

/**
 把手机号中段变成131****3212
 */
+ (NSString *)phoneNumByX:(NSString *)phoneNum;
/**
 把邮箱中段变成131****1233@xxx.com
 */
+ (NSString *)emailNumByX:(NSString *)emailNum;

//=========以下是正则表达式的匹配========//

//手机号是否有用,不一定准确
+ (BOOL)isPhoneNumber:(NSString*)string;
//或者精确点，但需要根据运营商更新
+ (BOOL)wl_isMobileNumberClassification:(NSString*)string;
//验证邮箱
+ (BOOL)isEmailAddress:(NSString*)string;
//验证密码
+ (BOOL)isValidPassword:(NSString*)string;
//身份证号验证
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber;


@end
