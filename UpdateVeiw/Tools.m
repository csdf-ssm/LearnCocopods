//
//  HHControl.m
//  YinYueTai
//
//  Created by qianfeng on 14-11-6.
//  Copyright (c) 2014年 HuangDong. All rights reserved.
//

#import "Tools.h"
#import "AppDelegate.h"
#import <objc/runtime.h>  
@implementation Tools

#define IOS7   [[UIDevice currentDevice]systemVersion].floatValue>=7.0

+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text
{
    
    
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //限制行数
    label.numberOfLines=0;
    //对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:font];
    //单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    //默认字体颜色是白色
    label.textColor=[UIColor blackColor];
    //自适应（行数~字体大小按照设置大小进行设置）
    label.adjustsFontSizeToFitWidth=YES;
    label.text=text;
    return label;
}
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    //设置背景图片，可以使文字与图片共存
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //图片与文字如果需要同时存在，就需要图片足够小 详见人人项目按钮设置
    // [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
    
    
}
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName
{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    imageView.userInteractionEnabled=YES;
    return imageView ;
}

+(UIView*)createViewWithFrame:(CGRect)frame
{
    UIView*view=[[UIView alloc]initWithFrame:frame];
    
    return view ;
    
}
+(UIControl *)createUIControlViewWithFrame:(CGRect)frame{
    UIControl *ctrl=[[UIControl alloc]initWithFrame:frame];
    return ctrl;
}
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    //灰色提示框
    textField.placeholder=placeholder;
    if(placeholder){
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    }
    //文字对齐方式
    textField.textAlignment=NSTextAlignmentLeft;
    textField.secureTextEntry=YESorNO;
    //边框
    //textField.borderStyle=UITextBorderStyleLine;
    //键盘类型
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    //关闭首字母大写
    textField.autocapitalizationType=NO;
    //清除按钮
    textField.clearButtonMode=YES;
    //左图片
    textField.leftView=imageView;
    textField.leftViewMode=UITextFieldViewModeAlways;
    //右图片
    textField.rightView=rightImageView;
    //编辑状态下一直存在
    textField.rightViewMode=UITextFieldViewModeWhileEditing;
    //自定义键盘
    //textField.inputView
    //字体
    textField.font=[UIFont systemFontOfSize:font];
    //字体颜色
    textField.textColor=[UIColor blackColor];
    return textField ;
    
}
#pragma  mark 适配器方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName
{
    UITextField*text= [self createTextFieldWithFrame:frame placeholder:placeholder passWord:YESorNO leftImageView:imageView rightImageView:rightImageView Font:font];
    text.background=[UIImage imageNamed:imageName];
    return  text;
    
}
+(UIScrollView*)makeScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = size;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    return scrollView ;
}
+(UIPageControl*)makePageControlWithFram:(CGRect)frame
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:frame];
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    return pageControl;
}
+(UISlider*)makeSliderWithFrame:(CGRect)rect AndImage:(UIImage*)image
{
    UISlider *slider = [[UISlider alloc]initWithFrame:rect];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    if(image){
        [slider setThumbImage:image forState:UIControlStateNormal];
    }
    slider.maximumTrackTintColor = [UIColor grayColor];
    slider.minimumTrackTintColor = [UIColor yellowColor];
    slider.continuous = YES;
    slider.enabled = YES;
    return slider ;
}
+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

#pragma -mark 判断导航的高度
+(float)isIOS7{
    
    float height;
    if (IOS7) {
        height=64.0;
    }else{
        height=44;
    }
    
    return height;
}
#pragma mark 需要的方法
+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval
{
    NSTimeInterval seconds = [timeInterval integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [format stringFromDate:date];
}

+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize
{
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    // 根据第一个参数的文本内容，使用280*float最大值的大小，使用系统14号字，返回一个真实的frame size : (280*xxx)!!
    CGRect frame = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return frame.size.height + 5;
}

// 返回一个整数字符串加1后的新字符串
+ (NSString *)addOneByIntegerString:(NSString *)integerString
{
    NSInteger integer = [integerString integerValue];
    return [NSString stringWithFormat:@"%d",integer+1];
}

+ (NSString *)getDateString
{
    NSDate *date=[NSDate date];
    NSDateFormatter *d=[NSDateFormatter new];
    [d setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [d stringFromDate:date];
}

+(UISegmentedControl *)createSegmentControlWithFrame:(CGRect)frame TintColor:(UIColor *)color  Target:(id)target Action:(SEL)action
{
    UISegmentedControl *ctrl=[[UISegmentedControl alloc]initWithFrame:frame];
    ctrl.tintColor=color;
    [ctrl addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return ctrl;
    
}

+ (NSString *)myinfoFilePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:@"myinfo"];
    
}

+ (NSString *)getDocumentDirectory
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+(NSString *)countWeekDay:(NSDate *)date{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}


/** 去掉多余分割线 */
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


+(void)AlterViewWithMessage:(NSString *)message WithBaseView:(UIView *)view{
    CGFloat labelW = [message boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    UILabel *m=(UILabel *)[view viewWithTag:2000];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];

//    [m removeFromSuperview];
//     m=nil;
    if(m==nil)
    {
     m=[Tools createLabelWithFrame:CGRectMake(0, 0, labelW+50,30) Font:15 Text:message];
    m.textAlignment=NSTextAlignmentCenter;
    m.backgroundColor=[UIColor blackColor];
    m.alpha=0.7;
    [m setTextColor:[UIColor whiteColor]];
    m.tag=2000;
    ViewBorderRadius(m, 4, 0, [UIColor whiteColor]);
    [view addSubview:m];
    [view bringSubviewToFront:m];
    m.center=view.center;
    }
    m.text=message;
    [self performSelector:@selector(HideAlterViewWithView:) withObject:view afterDelay:2];
}
+(void)HideAlterViewWithView:(UIView *)view{

        UILabel *l=(UILabel *)[view viewWithTag:2000];
        [l removeFromSuperview];
    
}
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
NSString* safeString(id str)
{
    if (![str isKindOfClass:[NSString class]] && ![str isKindOfClass:[NSNumber class]]) {
        return @"";
    }
    
    @try {
        if([str isEqual:[NSNull null]]){
            return @"";
        }
        else{
            return str;
        }
        if ([str isKindOfClass:[NSNumber class]]) {
            return @"";
        }
        else
        {
            if ([Tools isBlankString:str]) {
                return @"";
            }
            return str;
        }
    }
    @catch (NSException *exception) {
        
    }
}

NSArray* safeArray(NSArray* array){
    if([array isEqual:[NSNull null]]){
        return @[];
    }else{
        return array;
    }
}

//时间戳转换成字符串
+(NSString *)changeTimeToStringWithDate:(NSString *)date withFormat:(NSString *)formate{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formate];
    NSString *timeStamp=date;
    HHLog(@"%zd",[timeStamp integerValue]);
    long long int date1=(long long int)([timeStamp integerValue]/1000);
    NSDate *confromTimesp=[NSDate dateWithTimeIntervalSince1970:date1];
    return  [formatter stringFromDate:confromTimesp];
}
+(NSString *)changeCommentTimeWithDate:(NSDate *)date WithFormat:(NSString *)format{
     NSDateFormatter   *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+(NSString*)changeTimeStrToDate:(NSString *)time{
    NSDateFormatter   *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date=[dateFormatter dateFromString:time];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSString *realTime=[NSString stringWithFormat:@"%zd",[timeSp integerValue]*1000];
    HHLog(@"realTime=%@",realTime);
    return realTime ;
}


//返回安全的字符串
+(NSDictionary *)safeDiction:(NSDictionary*)keyedValues{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:keyedValues];
    for(id key in [dic allKeys]){
        HHLog(@"%@",key);
        id value=[dic valueForKey:key];
        if([value isEqual:[NSNull null]])
        {
            [dic setValue:@"" forKey:key];
        }
    }
    keyedValues=dic;
    return keyedValues;
}
//计算str的长宽
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
/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *phoneRegex=@"^1\\d{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
/**
 *  验证银行卡号是否正确
 *
 *  @param cardNo cardNo
 *
 *  @return value
 */
+ (BOOL) isBlankCountCardNo:(NSString *)cardNo{

    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}
//简单验证是否为16位或者19位
+ (BOOL) isCardNoCount:(NSString *)cardNo{

    NSString *phoneRegex=@"^[0-9]{16}|[0-9]{19}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:cardNo];
}


//计算时间间隔
+(CGFloat)countInterval:(NSString *)time{
   
    NSDate *confromTimesp=[Tools changeDateWithDateStr:time WithFormate:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval seconds=[confromTimesp timeIntervalSinceNow];
    float day=seconds/(3600*24);
    return -day;
}
/**
 *  拨打电话
 *
 *  @return 返回webview
 */
+(UIWebView *)clickPhoneNumWithNum:(NSString *)num{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",num]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上

    return callWebview;
}
+(NSString *)getDateWeekNumWithWeek:(BOOL)hasWeek{
    NSDate *date=[NSDate date];
    NSDateComponents *comps;
    NSCalendar *calendar=[NSCalendar currentCalendar];
    comps=[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:date];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    comps=[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:date];
    NSInteger week=[comps weekdayOrdinal];
    NSString *str;
    if(hasWeek){
        str=[NSString stringWithFormat:@"%zd年%zd月 第%zd周",year,month,week];
    }else{
        str=[NSString stringWithFormat:@"%zd年%zd月",year,month];
    }
    return str;
}
/**
 *  计算两个时间间隔
 */
+(NSInteger)countFromStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime withFormate:(NSString *)formate{
    NSDateFormatter   *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
    [dateFormatter setDateFormat:formate];
    long long int date=(long long int)([startTime integerValue]/1000);
    NSDate *date1=[NSDate dateWithTimeIntervalSince1970:date];
    date=(long long int)([endTime integerValue]/1000);
    NSDate *date2=[NSDate dateWithTimeIntervalSince1970:date];
    NSInteger inv=[date1 timeIntervalSinceDate:date2];
    return inv;

}
+(NSInteger)countIntervalFromStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime WithFormate:(NSString *)formate{
    NSDate *date1=[self changeDateWithDateStr:startTime WithFormate:formate];
    NSDate *date2=[self changeDateWithDateStr:endTime WithFormate:formate];
    NSInteger num=[date1 timeIntervalSinceDate:date2];
    return num;
}
+(NSDate *)changeDateWithDateStr:(NSString *)str WithFormate:(NSString *)formate{
    NSDateFormatter   *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
    [dateFormatter setDateFormat:formate];
    return [dateFormatter dateFromString:str];
}
+(NSString *)changeDateWithDate:(NSDate *)date WithFormate:(NSString *)formate{
    NSDateFormatter   *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
    [dateFormatter setDateFormat:formate];
    return [dateFormatter stringFromDate:date];
}
+(BOOL)isNumCharacters:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (string.length>0) {
        return NO;
    }
    return YES;
}
/**
 *  判断型号
 */
+(NSInteger)returniPhoneType{
    if(SCREENSIZEHIGHT==iPhone4Hight){
        return 1;
    }else if(SCREENSIZEHIGHT==iPhone5Hight){
        return 2;
    }else if(SCREENSIZEHIGHT==iPhone6Hight){
        return 3;
    }else if(SCREENSIZEHIGHT==iPhone6PHIGHT){
        return 4;
    }
    return 0;
    
}
/**
 *  判断第几周
 */
+(NSInteger)returnWeekNumber{
    NSDate*date = [NSDate date];
    
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    
    
    NSDateComponents*comps;
    
    
    // 年月日获得
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
                       fromDate:date];
    NSLog(@"year:%zd month: %zd, day: %zd", [comps weekOfYear],[comps month],[comps day]);
    return [comps weekOfYear];
}
/**
 *  返回从现在间隔几天
 */
+(NSDate*)returnDateFromNowWithInterval:(NSInteger)day WithDate:(NSDate *)date{
////    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:day*24*3600];
////    return date;
//    NSString *str=[NSString stringWithFormat:@"%@ 00:00:00",[Tools changeDateWithDate:date WithFormate:@"yyyy-MM-dd"]];
//    NSDate *nowDate=[Tools changeDateWithDateStr:str WithFormate:@"yyyy-MM-dd"];
//    
    NSDate *countDate=[NSDate dateWithTimeInterval:day*24*3600 sinceDate:date];
    return countDate;
}
/**
 *  计算两个时间的间隔
 */
+(NSString *)returnFromDate:(NSString *)startTime WithEndTime:(NSString *)endTime WithFormatter:(NSString *)formate{
    NSDate *StartDate=[Tools changeDateWithDateStr:startTime WithFormate:formate];
    NSDate *EndDate=[Tools changeDateWithDateStr:endTime WithFormate:formate];
    NSInteger inv=[EndDate timeIntervalSinceDate:StartDate];
    NSInteger day=inv/(24*3600);
    if((day*(24*3600))>inv){
        day=day-1;
    }
    if(day){
        NSInteger seconds=inv-day*(24*3600);
        NSInteger hour=(seconds)/3600;
        if((hour*3600)>seconds){
            hour=hour-1;
        }
        if(hour){
            return [NSString stringWithFormat:@"%zd天%zd时",day,hour];
        }else{
            return [NSString stringWithFormat:@"%zd天",day];
        }
    
    }else{
        NSInteger seconds=inv-day*(24*3600);
        NSInteger hour=(seconds)/3600;
        if((hour*3600)>seconds){
            hour=hour-1;
        }
        return [NSString stringWithFormat:@"%zd时",hour];
    }
}
/**
 *  判断初始时间是不是小于结束时间
 *
 *
 */
+(BOOL)returnTimeFromDate:(NSString *)startTime WithEndTime:(NSString *)endTime WithFormatter:(NSString *)formate{
    NSDate *StartDate=[Tools changeDateWithDateStr:startTime WithFormate:formate];
    NSDate *EndDate=[Tools changeDateWithDateStr:endTime WithFormate:formate];
    HHLog(@"startTime=%@,endTime=%@",StartDate,EndDate);
     NSInteger inv=[EndDate timeIntervalSinceDate:StartDate];
    if(inv<0){
        return NO;
    }else{
        return YES;
    }
}

+ (NSDictionary *) entityToDictionary:(id)entity
{

    Class clazz = [entity class];
    u_int count;
    //首先，我们需要先获取所有的属性，以便获取属性值
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        //在遍历属性列表时，我们通过这样获取名称
        objc_property_t prop=properties[i];
        const void* propertyName = property_getName(prop);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        
        //        const char* attributeName = property_getAttributes(prop);
        //        NSLog(@"%@",[NSString stringWithUTF8String:propertyName]);
        //        NSLog(@"%@",[NSString stringWithUTF8String:attributeName]);
       
        id value =  [entity performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
        if(value ==nil)
            [valueArray addObject:[NSNull null]];
        else {
            [valueArray addObject:value];
        }
        //        NSLog(@"%@",value);
    }
    
    free(properties);
    
    NSDictionary* returnDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    
    return returnDic;
}

+(void)resetModelWithModel:(id)entity{
    Class clazz = [entity class];
    u_int count;
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    for(int i=0;i<count;i++){
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        [entity performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName]) withObject:@""];
        
    }
   free(properties);
}
+(NSDateComponents *)returnDateComponents{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
    return comp;
}
/**
 *  获得今天是周几
 */
+(NSInteger)getWeekIndex{
    NSDateComponents *comp = [self returnDateComponents];
    return [comp weekday];
}
/**
 *  获得今天是本月的第几天
 */
+(NSInteger)getMotheIndex{
     NSDateComponents *comp = [self returnDateComponents];
    return [comp day];

}
/**
 *  获得今天是本年的几月份
 */
+(NSInteger)getMontheIndexOfYear{
    NSDateComponents *comp = [self returnDateComponents];
    return [comp month];

}
//获得年份数
+(NSInteger)getYearIndex{
    NSDateComponents *comp = [self returnDateComponents];
    return [comp year];

}
//  将数组重复的对象去除，只保留一个
+ (NSArray *)arrayWithMemberIsOnly:(NSArray *)array
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++) {
            if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
                [categoryArray addObject:[array objectAtIndex:i]];
                
            }
    }
        return categoryArray;
}
/**
 *  在数字键盘上添加完成按钮
 *
 *  @return 键盘上添加的toolbar
 */
+(UIView *)createKeyboardWithDoneButtonWithTarget:(id)target WithAction:(SEL)action{
    //   定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENSIZEWIDTH, 30)];
    //设置style
    [topView setBarStyle:UIBarStyleBlack];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * button2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *doneButton = [Tools createButtonWithFrame:CGRectMake(0, 0, 50, 30) ImageName:nil Target:target Action:action Title:@"完成"];
    //定义完成按钮
    UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc]initWithCustomView:doneButton];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneBtn,nil]; [topView setItems:buttonsArray];
    return topView;

}

//检测是否含有emoji表情
+(BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         }
         else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         }
         else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
}
//判断是否是iphone yes 是iphone no 是ipad
+(BOOL)isIphone{

    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
        return NO;
    }
    return YES;
}

@end
