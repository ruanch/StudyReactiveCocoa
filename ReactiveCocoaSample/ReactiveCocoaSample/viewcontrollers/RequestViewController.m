//
//  RequestViewController.m
//  ReactiveCocoaSample
//
//  Created by 阮沧晖 on 2020/3/1.
//  Copyright © 2020 阮沧晖. All rights reserved.
//

#import "RequestViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface RequestViewController ()

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一次操作
//    [[self parseJSON:@"http://www.orzer.club/test.json"] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    } error:^(NSError * _Nullable error) {
//        NSLog(@"%@",[error description]);
//    } completed:^{
//        NSLog(@"完成请求");
//    }];
    
    
    //串行操作
    RACSignal *s1 = [self parseJSON:@"http://www.orzer.club/test.json"];
    RACSignal *s2 = [self parseJSON:@"http://www.orzer.club/test.json"];
    RACSignal *s3 = [self parseJSON:@"http://www.orzer.club/test.json"];
    
   RACDisposable *disposable = [[[s1 merge:s2] merge:s3] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
 
    //这个方法是执行以下的方法体
    /**[RACDisposable disposableWithBlock:^{
        NSLog(@"信号量完成时需要处理的事件");
    }];*/
    [disposable dispose];
    
    
    
    
//    [[[s1 concat:s2] concat:s3] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
}

- (RACSignal *) parseJSON:(NSString *)urlStr
{
    //创建信号量
   RACSignal *racSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       //建立请求
       NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
       NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
       NSURLSessionDataTask  *data = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           if (error) {
               [subscriber sendError:error];
           }else{
               NSError *e;
               NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
               if(e){
                   [subscriber sendError:e];
               }else{
                   [subscriber sendNext:jsonDic];
                   [subscriber sendCompleted];
               }
           }
       }];
       //开始请求
       [data resume];
       //返回信号量
      return [RACDisposable disposableWithBlock:^{
           NSLog(@"信号量完成时需要处理的事件");
       }];
       
    }];
     //返回信号量
    return racSignal;
}

@end
