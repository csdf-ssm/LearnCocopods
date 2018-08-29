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

+ (NSString *)moneyNumFormatter:(NSString *)money;
+ (NSString *)moneyFloatNumFormatter:(NSString *)money;

+(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height;
+(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;

//获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp;
NSString*safeString(id string);

//邮箱
+ (BOOL) validateEmail:(NSString *)email;
//手机号码验证
+ (BOOL)validateMobile:(NSString *)phone;

//身份证号判断
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber;

//验证邮箱
+ (BOOL)isEmailAddress:(NSString*)string;


@end
