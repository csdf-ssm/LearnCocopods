//
//  NetWorkRequest.m
//  DocumentWatermarking
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NetWorkRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "Tools.h"
#define kBaseUrl @"空地址"
#define kSafeUploadList @"一个文件地址"
#define TIMEOUTINTERVAL 30   //超时时间
static NetWorkRequest *instace = nil;

@interface NetWorkRequest()

@property(nonatomic,strong)AFHTTPSessionManager *manager;
@property(nonatomic,assign)AFNetworkReachabilityManager *netmanager;
@property(nonatomic,assign)BOOL netStatus;//网络状态
@end

@implementation NetWorkRequest

+ (instancetype)sharedNetWork{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[self alloc] init];
        
    });
    
    return instace;
    
}

- (instancetype)init
{
    
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _netmanager = [AFNetworkReachabilityManager sharedManager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [_netmanager startMonitoring];
        [_netmanager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            //网络状态
            NSLog(@"检测到网络变化");
            if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
                _netStatus = YES;
            }
            else{
                _netStatus = NO;
            }
            
        }];
//        [_netmanager stopMonitoring];

        //返回数据的序列化器
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
        [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded/json" forHTTPHeaderField:@"Content-Type"];

        // 设置超时时间 放到请求格式后设置时间  否则不生效
        _manager.requestSerializer.timeoutInterval = (self.timeoutInterval ? self.timeoutInterval : TIMEOUTINTERVAL);

        //添加状态栏请求网络
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//        //配置kvnprogress
//        KVNProgressConfiguration *config = [KVNProgressConfiguration defaultConfiguration];
////        config.backgroundFillColor = [UIColor blueColor];
//        config.backgroundTintColor = COLOR_A(100, 100, 100, 1);
//        config.circleFillBackgroundColor = [UIColor clearColor];
////        config.circleStrokeBackgroundColor = [UIColor greenColor];
//        config.circleStrokeForegroundColor = COLOR_A(255, 255, 255, 0.7);
//        [KVNProgress setConfiguration:config];
    }
    return self;
    
}

/*
 *  返回签名
 */
-(NSString*)signString:(NSMutableDictionary*)dic{
    
    if (dic.count) {
        NSArray *allKeyArray = [dic allKeys];
        NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSComparisonResult resuest = [obj2 compare:obj1];
            return resuest;
        }];
        
        //通过排列的key值获取value
        NSMutableArray *valueArray = [NSMutableArray array];
        for (NSString *sortsing in afterSortKeyArray) {
            NSString *valueString = [dic objectForKey:sortsing];
            [valueArray addObject:valueString];
        }
        NSMutableString *mutString=[[NSMutableString alloc]init];
        for (int i = afterSortKeyArray.count-1 ; i > 0 ; i--) {
            [mutString appendFormat:@"%@=%@&",afterSortKeyArray[i],valueArray[i]];
        }
        [mutString deleteCharactersInRange:NSMakeRange(mutString.length-1, 1)];
        NSString *upstring = mutString.uppercaseString;
        NSString *lastString = [upstring substringFromIndex:(upstring.length-16)];
        return lastString;
    }
    return @"";
    
}



/*
 *  返回字符串
 */
-(NSString*)returnSting:(NSMutableDictionary*)dic{
    
    NSArray *allKeyArray = [dic allKeys];

    NSMutableString *string = @"".mutableCopy;
    for (NSString *key in allKeyArray) {
        [string appendFormat:@"%@=%@&",key,dic[key]];
    }
    
    [string deleteCharactersInRange:NSMakeRange(string.length-1, 1)];
    
    return string;
    
}


-(void)GET:(NSString *)URLString delegate:(id)delegate parameters:(NSMutableDictionary *)parameters success:(Success)success failure:(Failure)failure{
    
    [self setRequestHeader];
    
    URLString = [NSString stringWithFormat:@"%@%@",kBaseUrl,URLString];
    NSLog(@"%@",URLString);
//    [KVNProgress show];
    [_manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [KVNProgress dismissWithCompletion:^{
            //                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if (success)
            {
                //转换成json
                success(dic);
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画

//        }];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [KVNProgress dismissWithCompletion:^{
            NSDictionary *dic = [self errDicWithError:error];
//            if (dic!=nil && [dic[@"status_code"] integerValue] == 401) {
//                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//                AppDelegate *dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                dele.window.rootViewController = [[JHBaseNavController alloc]initWithRootViewController:dele.loginVC];
//                [dele.window makeKeyAndVisible];
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"Token过期,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
//            }
//            else{
                failure(error,dic);
//            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画

//        }];

    }];

}

-(void)POST:(NSString *)URLString delegate:(id)delegate parameters:(NSMutableDictionary *)parameters success:(Success)success failure:(Failure)failure{
//    [self setRequestHeader];
//    [KVNProgress show];    

    URLString = [NSString stringWithFormat:@"%@%@"kBaseUrl,URLString];
    
    
    
    
    
    
    
    
    
//    if ([SingleData sharedInstall].token == nil) {
//        [parameters setObject:safeString([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) forKey:@"token"];
//    }
//    else{
//        [parameters setObject:safeString([SingleData sharedInstall].token) forKey:@"token"];
//    }
//    if ([SingleData sharedInstall].token == nil) {
//        [parameters setObject:safeString([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) forKey:@"token"];
//    }
//    else{
//        [parameters setObject:safeString([SingleData sharedInstall].token) forKey:@"token"];
//    }
//    NSLog(@"urlString======%@",URLString);
//    NSLog(@"parameters======%@",parameters);
    
    [_manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [KVNProgress dismissWithCompletion:^{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if (success) {
                success(dic);
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
//        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        NSData *data = (NSData*)error;
////        [KVNProgress dismissWithCompletion:^{
            NSDictionary *dic = [self errDicWithError:error];
//            if (dic!=nil && [dic[@"status_code"] integerValue] == 401) {
//
//                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//                AppDelegate *dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                dele.window.rootViewController = [[JHBaseNavController alloc]initWithRootViewController:dele.loginVC];
//                [dele.window makeKeyAndVisible];
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"Token过期,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
//
//            }
//            else{
//
                if (failure) {
                    failure(error,dic);
                }
//            }
        
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画

//        }];

        

    }];
}

-(void)PUT:(NSString *)URLString delegate:(id)delegate parameters:(NSMutableDictionary *)parameters success:(Success)success failure:(Failure)failure{
    [self setRequestHeader];
//    [KVNProgress show];

    URLString = [NSString stringWithFormat:@"%@%@",kBaseUrl,URLString];
    [_manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [KVNProgress dismissWithCompletion:^{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if (success) {
                success(dic);
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画

//        }];


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [KVNProgress dismissWithCompletion:^{
            NSDictionary *dic = [self errDicWithError:error];
//            if (dic!=nil && [dic[@"status_code"] integerValue] == 401) {
//
//                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//                AppDelegate *dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                dele.window.rootViewController = [[JHBaseNavController alloc]initWithRootViewController:dele.loginVC];
//                [dele.window makeKeyAndVisible];
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"Token过期,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
//
//            }
//            else{
//
                if (failure) {
                    failure(error,dic);
                }
//            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画

//        }];

    }];
    
}


-(void)Delete:(NSString *)URLString delegate:(id)delegate parameters:(NSMutableDictionary *)parameters success:(Success)success failure:(Failure)failure{
    [self setRequestHeader];
//    [KVNProgress show];

    URLString = [NSString stringWithFormat:@"%@%@",kBaseUrl,URLString];
    [_manager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [KVNProgress dismissWithCompletion:^{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if (success) {
                success(dic);
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画

//        }];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [KVNProgress dismissWithCompletion:^{
            NSDictionary *dic = [self errDicWithError:error];
//            if (dic!=nil && [dic[@"status_code"] integerValue] == 401) {
//
//                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//                AppDelegate *dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                dele.window.rootViewController = [[JHBaseNavController alloc]initWithRootViewController:dele.loginVC];
//                [dele.window makeKeyAndVisible];
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"Token过期,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
//
//            }
//            else{
//
                if (failure) {
                    failure(error,dic);
                }
//            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画

//        }];
        

    }];
}

//批量上传图片  只对应与上传在线问题和提出申诉的批量
- (void)requestImgArrPOSTWithParamDic:(NSMutableDictionary *)paramDic imageArr:(NSArray*)imageArr name:(NSString *)name success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    [self setRequestHeader];
//    [KVNProgress show];

    NSString* URLString = [NSString stringWithFormat:@"%@%@",kBaseUrl,kSafeUploadList];
//    if ([SingleData sharedInstall].token == nil) {
//        [paramDic setObject:safeString([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) forKey:@"token"];
//    }
//    else{
//        [paramDic setObject:safeString([SingleData sharedInstall].token) forKey:@"token"];
//    }
    
    // 1.发送请求(字典只能放非文件参数)
    [_manager POST:URLString parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        int i = 0;
        for (UIImage *image in imageArr) {
            //根据当前系统时间生成图片名称
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss-SSS"];
            NSString *dateString = [formatter stringFromDate:date];
            NSArray *picImageArr = [dateString componentsSeparatedByString:@" "];
            NSString *picNames = [NSString stringWithFormat:@"%@-%@",picImageArr[0],picImageArr[1]];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg",picNames,i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg/png/jpeg"];
            i++;
        }

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [KVNProgress dismiss];

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [KVNProgress dismiss];

        failure(error);
    }];
    
}


- (void)requestAddImgPOSTWithURLStr:(NSString *)URLString paramDic:(NSMutableDictionary *)paramDic image:(UIImage *)image name:(NSString *)name success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    [self setRequestHeader];
//    [KVNProgress show];

    URLString = [NSString stringWithFormat:@"%@%@",kBaseUrl,URLString];
//    if ([SingleData sharedInstall].token == nil) {
//        [paramDic setObject:safeString([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) forKey:@"token"];
//    }
//    else{
//        [paramDic setObject:safeString([SingleData sharedInstall].token) forKey:@"token"];
//    }

    // 1.发送请求(字典只能放非文件参数)
    [_manager POST:URLString parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);//进行图片压缩
        // 使用日期生成图片名称
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
        
        // 上传图片，以文件流的格式
        // 任意的二进制数据MIMEType application/octet-stream
        // 特别注意，这里的图片的名字不要写错，必须是接口的图片的参数名字如我这里是file
        if (imageData!=nil) { // 图片数据不为空才传递
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg/png/jpg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [KVNProgress dismiss];

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [KVNProgress dismiss];

        failure(error);
    }];
    
}

/*
 *  设置请求头 
 */
-(void)setRequestHeader{
    NSString *token = @"";
//    if ([SingleData sharedInstall].token ==nil|| [@"" isEqualToString:[SingleData sharedInstall].token]) {
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"] == nil) {
//            token = @"";
//        }
//        else{
//            token = [NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
////            token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
//        }
//    }
//    else{
//        token = [NSString stringWithFormat:@"Bearer %@",[SingleData sharedInstall].token];
//    }
    [_manager.requestSerializer setValue:safeString(token) forHTTPHeaderField:@"authorization"];
}


/*
 *  处理错误
 */
-(NSDictionary*)errDicWithError:(NSError*)error{
    
    if(!_netStatus){
        return @{@"message":error.userInfo[@"NSLocalizedDescription"]};
    }
    
    if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"请求超时。"] || [error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"The request timed out."]) {
        return @{@"message":error.userInfo[@"NSLocalizedDescription"]};
    }
    if (error.userInfo[@"com.alamofire.serialization.response.error.data"] == nil) {
        return @{@"message":error.userInfo[@"NSLocalizedDescription"]};
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] options:NSJSONReadingAllowFragments error:nil];
    return dic;
    
}

//获取版本升级
-(void)GETVersion:(NSString *)URLString parameters:(NSMutableDictionary *)parameters success:(Success)success failure:(Failure)failure{
    
    NSString *signString = [self signString:parameters];
    
    [parameters setObject:signString forKey:@"sign"];
    
//    URLString = [NSString stringWithFormat:@"%@%@",kBaseUrl,URLString];
    
    [_manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (success)
        {
            //转换成json
            success(dic);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dic = [self errDicWithError:error];
        failure(error,dic);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
    }];
    
}



@end
