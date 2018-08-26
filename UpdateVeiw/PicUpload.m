//
//  PicUpload.m
//  SanYi
//
//  Created by  lanbox on 15/11/30.
//  Copyright © 2015年 fetechios. All rights reserved.
//

#import "PicUpload.h"
#import "AFNetworking.h"
//#import "SVProgressHUD.h"
//#import "SBJson.h"
//#import "Singleton.h"
static NSString * const FORM_FLE_INPUT = @"file";
@implementation PicUpload

+(void)startMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(void (^)(id, id))succeedBlock
                           failedBlock:(void (^)(id, NSError *))failedBlock
                   uploadProgressBlock:(void (^)(float, long long, long long))uploadProgressBlock{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation *operation = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        int i = 0;
        for (UIImage *image in images) {
            //根据当前系统时间生成图片名称
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss-SSS"];
            NSString *dateString = [formatter stringFromDate:date];
            NSArray *picImageArr = [dateString componentsSeparatedByString:@" "];
            NSString *picNames = [NSString stringWithFormat:@"%@-%@",picImageArr[0],picImageArr[1]];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",picNames,i];
            NSData *imageData;
            if (ratio > 0.0f && ratio < 1.0f) {
                imageData = UIImageJPEGRepresentation(image, ratio);
            }else{
                imageData = UIImageJPEGRepresentation(image, 1.0f);
            }
            
            [formData appendPartWithFileData:imageData name:parameter fileName:fileName mimeType:@"image/jpg/png/jpeg"];
            i++;
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        succeedBlock(operation,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HHLog(@"%@",error);
        failedBlock(operation,error);
        
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat percent = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
        uploadProgressBlock(percent,totalBytesWritten,totalBytesExpectedToWrite);
    }];
    
}

//再试试
+(void)PostImagesToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params andImag:(UIImage*)image succeedBlock:(void (^)(id, id))succeedBlock
              failedBlock:(void (^)(id, NSError *))failedBlock uploadProgressBlock:(void (^)(float, long long, long long))uploadProgressBlock{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *baseUrl=[[NSUserDefaults standardUserDefaults]objectForKey:kSchoolImageIp];
    NSString *url = [NSString stringWithFormat:@"%@/%@?key=2010&value=2010",baseUrl,strUrl];
    // 显示进度
    AFHTTPRequestOperation *operation = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
         // 上传 多张图片
//         for(NSInteger i = 0; i < imgArr.count; i++)
//         {
             NSData * imageData = UIImageJPEGRepresentation(image, 1.0f);
             // 上传的参数名
             NSString * Name = @"file";
             // 上传filename
         NSDate *date = [NSDate date];
         NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
         [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss-SSS"];
         NSString *dateString = [formatter stringFromDate:date];
         NSArray *picImageArr = [dateString componentsSeparatedByString:@" "];
         NSString *picNames = [NSString stringWithFormat:@"%@-%@",picImageArr[0],picImageArr[1]];

             NSString * fileName = [NSString stringWithFormat:@"%@.jpg",picNames];
             
            [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:@"image/jpeg"];
//         }
     }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         succeedBlock(operation,responseObject);

     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         HHLog(@"错误 %@", error.localizedDescription);
          failedBlock(operation,error);
     }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat percent = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
        uploadProgressBlock(percent,totalBytesWritten,totalBytesExpectedToWrite);
    }];
}


//上传语音
+(void)PostRecordToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params andRecordUrl:(NSURL*)recordUrl andStr:(NSString *)recordStr succeedBlock:(void (^)(id, id))succeedBlock
              failedBlock:(void (^)(id, NSError *))failedBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *baseUrl=[[NSUserDefaults standardUserDefaults]objectForKey:kSchoolUserIp];
    NSString *url = [NSString stringWithFormat:@"%@/%@?key=2010&value=2010",baseUrl,strUrl];
    // 显示进度
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传的参数名
        NSString * Name = @"file";
        // 上传filename
        [formData appendPartWithFileURL:recordUrl name:Name fileName:@"testMusic.mp3" mimeType:@"audio/mpeg3" error:nil];
    }
                                              success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             succeedBlock(operation,responseObject);
                                             
                                         }
                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             HHLog(@"错误 %@", error.localizedDescription);
                                             failedBlock(operation,error);
                                         }];
}

+ (NSMutableArray *)postRequestWithURL: (NSString *)url  // IN
                            postParems: (NSMutableDictionary *)postParems // IN
                           picFilePath: (NSString *)picFilePath  // IN
                           picFileName: (NSString *)picFileName  // IN
{
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //根据url初始化request
    NSString *baseUrl=[[NSUserDefaults standardUserDefaults]objectForKey:kSchoolImageIp];


//    NSString *baseurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolServerIp"];
    NSString *picurl = [NSString stringWithFormat:@"%@%@?key=2010&value=2010",baseUrl,url];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:picurl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
    if(picFilePath){
        
        UIImage *image=[UIImage imageWithContentsOfFile:picFilePath];
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 5.0);
        }
    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        //                      NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    if(picFilePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    }
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if(picFilePath){
        //将image的data加入
        [myRequestData appendData:data];
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&urlResponese error:&error];
    //     NSDictionary *dic = [NSDictionary di];
    //     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSMutableString* result= [[NSMutableString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    //     [result replaceOccurrencesOfString:@"," withString:@";" options:NSCaseInsensitiveSearch range:NSMakeRange(0, result.length)];
    //     NSLog(@"------%@",result);
    //     NSData *tranformdata = [result dataUsingEncoding:NSUTF8StringEncoding];
    //     NSDictionary *transformDic = [NSJSONSerialization JSONObjectWithData:tranformdata options:NSJSONReadingAllowFragments error:nil];
    //     NSLog(@"+++++%@",transformDic);
    
    if([urlResponese statusCode] >=200){
        NSMutableArray *returnArr = [NSMutableArray array];
        //&&[urlResponese statusCode]<<span style="margin: 0px; padding: 0px; font-family: 'Courier New'; color: rgb(128, 0, 128);">300
                         NSLog(@"返回结果=====%@",result);
        NSArray *resultArr = [result componentsSeparatedByString:@","];
        //             NSLog(@"%@--%@--%@",resultArr[0],resultArr[1],resultArr[4]);
        NSArray *fitstArr = [resultArr[0] componentsSeparatedByString:@":"];
        if ([[fitstArr lastObject] isEqualToString:@"true"]) {
            //                 NSLog(@"%@",[fitstArr lastObject]);
            NSArray * arr = [resultArr[4] componentsSeparatedByString:@":"];
            NSString *picpath = arr[1];
            NSString *string = [picpath stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
            //                 NSLog(@"%@---------",string);
            [returnArr addObject:string];
            NSArray * fidarr = [resultArr[1] componentsSeparatedByString:@":"];
            NSString *fid =[fidarr lastObject];
            NSString *fidstring = [fid stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
            //                 NSLog(@"%@---------",fidstring);
            [returnArr addObject:fidstring];
            
            return returnArr;
        }
        else{
            [returnArr addObject:[fitstArr lastObject]];
            [returnArr addObject:@""];
            return returnArr;
        }
    }
    return nil;
}



@end
