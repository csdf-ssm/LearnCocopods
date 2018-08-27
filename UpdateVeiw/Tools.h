//
//  HHControl.h
//  YinYueTai
//
//  Created by qianfeng on 14-11-6.
//  Copyright (c) 2014年 HuangDong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Tools : NSObject
#pragma mark --创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text;
#pragma mark --创建View
+(UIView*)createViewWithFrame:(CGRect)frame;
#pragma mark --创建imageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;
#pragma mark --创建button
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title;
#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font;
#pragma mark-创建UISegmentedControl
+(UISegmentedControl *)createSegmentControlWithFrame:(CGRect)frame TintColor:(UIColor *)color Target:(id)target Action:(SEL)action;
+(UIControl *)createUIControlViewWithFrame:(CGRect)frame;
//适配器的方法  扩展性方法
//现有方法，已经在工程里面存在，如果修改工程内所有方法，工作量巨大，就需要使用适配器的方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName;
#pragma mark 创建UIScrollView
+(UIScrollView*)makeScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size;
#pragma mark 创建UIPageControl
+(UIPageControl*)makePageControlWithFram:(CGRect)frame;
#pragma mark 创建UISlider
+(UISlider*)makeSliderWithFrame:(CGRect)rect AndImage:(UIImage*)image;
#pragma mark 创建时间转换字符串
+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date;
#pragma mark --判断导航的高度64or44
+(float)isIOS7;

#pragma mark 内涵图需要的方法
+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval;

+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize;

+ (NSString *)addOneByIntegerString:(NSString *)integerString;

//获取日期字符串
+ (NSString *)getDateString;

+ (NSString *)myinfoFilePath;

//+ (NSString *)getDocPathWithName:(NSString *)name;

+ (NSString *)getDocumentDirectory;
//将button返回颜色
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
////安全字符串
//NSString* safeString(id str);
//根据日期获得星期几
+(NSString *)countWeekDay:(NSDate *)date;
+ (void)setExtraCellLineHidden: (UITableView *)tableView;
//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string;
NSString* safeString(NSString*);
NSArray* safeArray(NSArray*);
//将时间戳变成时间格式
+(NSString *)changeTimeToStringWithDate:(NSString *)date withFormat:(NSString *)formate;
//获得沙河路径
//将时间变成普通模式
+(NSString *)changeCommentTimeWithDate:(NSDate *)date WithFormat:(NSString *)format;
//返回安全的字符串
+(NSDictionary *)safeDiction:(NSDictionary*)keyedValues;
//计算字符串的长宽
+(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height;
+(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;
//将时间格式字符串转化成时间戳
+(NSString *)changeTimeStrToDate:(NSString *)time;
//实体类转字典
+ (NSDictionary *) entityToDictionary:(id)entity;
/**
 *  是否是手机号码
 *
 *  @param mobile 带判断字符串对象
 *
 *  @return 是否
 **/
 + (BOOL) isValidateMobile:(NSString *)mobile;

/**
 *  验证银行卡号是否正确
 *
 *  @param cardNo 卡号
 *
 *  @return bool value
 */
+ (BOOL) isBlankCountCardNo:(NSString *)cardNo;
/**
 *  简单验证是否为16活着19位数字
 *
 *  @param cardNo 卡号
 *
 *  @return boolvalue
 */
+ (BOOL) isCardNoCount:(NSString *)cardNo;

/**
 *  算距离现在的时间间隔
 */
+(CGFloat)countInterval:(NSString *)time;
/**
 *  拨打电话
 */
+(UIWebView *)clickPhoneNumWithNum:(NSString *)num;
/**
 *  获取当前的周数
 */
+(NSString *)getDateWeekNumWithWeek:(BOOL)hasWeek;
/**
 *  计算两个时间段的间隔
 */
+(NSInteger)countFromStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime withFormate:(NSString*)formate;
+(NSInteger)countIntervalFromStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime WithFormate:(NSString *)formate;
/**
 * 改变时间 将日期字符串转成日期类型
 */
+(NSDate*)changeDateWithDateStr:(NSString *)str WithFormate:(NSString *)formate;
/**
 * 改变时间 将日期类型串转成日期字符串
 */

+(NSString *)changeDateWithDate:(NSDate *)date WithFormate:(NSString *)formate;
/**
 *  判断是否是数字
 *
 *  @param string 字符串
 *
 *  @return value
 */
+(BOOL)isNumCharacters:(NSString *)string;
/**
 *  判断是iphone型号 1代表iphone4 2代表iphone5 3 代表iphonr6 4代表iphone6p
 */
+(NSInteger)returniPhoneType;
/**
 *  判断今天是一年的第几周
 */
+(NSInteger)returnWeekNumber;
/**
 *  计算今天过去几天的NSDate
 */
+(NSDate*)returnDateFromNowWithInterval:(NSInteger)day WithDate:(NSDate *)date;
/**
 *  计算两个时间的时间间隔，返回几天几时的格式
 */
+(NSString*)returnFromDate:(NSString*)startTime WithEndTime:(NSString *)endTime WithFormatter:(NSString*)
 formate;
/**
 *  判断初始时间是不是小于结束时间
 *
 *  @param startTime 开始时间
 *  @param endTime   结束时间
 *  @param formate   时间格式
 *
 *  @return 判断大小
 */
+(BOOL)returnTimeFromDate:(NSString *)startTime WithEndTime:(NSString *)endTime WithFormatter:(NSString *)formate;
/**
 *  获得今天是周几
 */
+(NSInteger) getWeekIndex;
/**
 *  获得今天是本月的第几天
 */
+(NSInteger)getMotheIndex;
/**
 *  获得今天是本年的几月份
 */
+(NSInteger)getMontheIndexOfYear;
//获得年份数
+(NSInteger)getYearIndex;
/**
 *  去重
 */
+ (NSArray *)arrayWithMemberIsOnly:(NSArray *)array;
/**
 *  在数字键盘上添加完成按钮
 *
 *  @return 键盘上添加的toolbar
 */
+(UIView *)createKeyboardWithDoneButtonWithTarget:(id)target WithAction:(SEL)action;
//检测是否含有emoji表情
+(BOOL)stringContainsEmoji:(NSString *)string;
+(BOOL)isIphone;
@end
