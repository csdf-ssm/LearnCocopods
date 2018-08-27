//
//  PicUpload.h
//  SanYi
//
//  Created by  lanbox on 15/11/30.
//  Copyright © 2015年 fetechios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PicUpload : NSObject

/**
 *  上传带图片的内容，允许多张图片上传（URL）POST   (服务器数组接受)
 *
 *  @param url                 网络请求地址
 *  @param images              要上传的图片数组（注意数组内容需是图片）
 *  @param parameter           图片数组对应的参数
 *  @param parameters          其他参数字典
 *  @param ratio               图片的压缩比例（0.0~1.0之间）
 *  @param succeedBlock        成功的回调
 *  @param failedBlock         失败的回调
 *  @param uploadProgressBlock 上传进度的回调
 */
+(void)startMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(void(^)(id operation, id responseObject))succeedBlock
                           failedBlock:(void(^)(id operation, NSError *error))failedBlock
                   uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock;
/**
 *  上传单张图片   (服务器单张接受,但是可以循环上传)
 *
 *  @param strUrl       上传路劲
 *  @param params       其他参数
 *  @param image        图片
 *  @param succeedBlock 成功回调
 *  @param failedBlock  失败回调
 */
+(void)PostImagesToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params andImag:(UIImage*)image   succeedBlock:(void (^)(id, id))succeedBlock
              failedBlock:(void (^)(id, NSError *))failedBlock uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock;
/**
 *  上传语音    (应该是和图片一样,单次上传,可循环上传)
 *
 *  @param strUrl       上传路劲
 *  @param params       其他参数
 *  @param recordUrl    语音路劲
 *  @param succeedBlock 成功回调
 *  @param failedBlock  失败回调
 */
+(void)PostRecordToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params andRecordUrl:(NSURL*)recordUrl andStr:(NSString *)recordStr succeedBlock:(void (^)(id, id))succeedBlock
              failedBlock:(void (^)(id, NSError *))failedBlock;

/**
 *  上传单张图片
 *
 *  @param url         上传路劲
 *  @param postParems  参数
 *  @param picFilePath 文件路劲
 *  @param picFileName 文件名
 *
 *  @return 返回值
 */
+ (NSMutableArray *)postRequestWithURL: (NSString *)url  // IN
                            postParems: (NSMutableDictionary *)postParems // IN
                           picFilePath: (NSString *)picFilePath  // IN
                           picFileName: (NSString *)picFileName;  // IN

@end
