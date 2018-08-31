//
//  NetWorkRequest.h
//  DocumentWatermarking
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^Success)(id responseObject);     // 成功Block
typedef void (^Failure)(NSError *error,NSDictionary*errDic);        // 失败Block


@interface NetWorkRequest : NSObject
/**
 超时时间 默认20秒normal i386 objective-c com.apple.compilers.llvm.clang.1_0.compiler
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

+(instancetype)sharedNetWork;


/**
 GET 请求封装
 
 @param URLString  请求链接
 @param parameters 请求参数
 @param success    请求成功回调
 @param failure    请求失败回调
 */
- (void)GET:(NSString *)URLString
   delegate:(id )delegate
 parameters:(NSMutableDictionary *)parameters
    success:(Success)success
    failure:(Failure)failure;


/**
 POST 请求回调
 
 @param URLString  请求链接
 @param parameters 请求参数
 @param success    请求成功回调
 @param failure    请求失败回调
 */
- (void)POST:(NSString *)URLString
    delegate:(id )delegate
  parameters:(NSMutableDictionary *)parameters
     success:(Success)success
     failure:(Failure)failure;


/**
 PUT请求

 @param URLString 请求路径
 @param delegate 代理
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
- (void)PUT:(NSString *)URLString
    delegate:(id )delegate
  parameters:(NSMutableDictionary *)parameters
     success:(Success)success
     failure:(Failure)failure;
/**
 Delete请求
 
 @param URLString 请求路径
 @param delegate 代理
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
- (void)Delete:(NSString *)URLString
   delegate:(id )delegate
 parameters:(NSMutableDictionary *)parameters
    success:(Success)success
    failure:(Failure)failure;

//批量上传图片
- (void)requestImgArrPOSTWithParamDic:(NSMutableDictionary *)paramDic imageArr:(NSArray*)imageArr name:(NSString *)name success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

//上传图片
- (void)requestAddImgPOSTWithURLStr:(NSString *)url paramDic:(NSMutableDictionary *)paramDic image:(UIImage *)image name:(NSString *)name success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

//获取版本升级
-(void)GETVersion:(NSString *)URLString parameters:(NSMutableDictionary *)parameters success:(Success)success failure:(Failure)failure;
@end
