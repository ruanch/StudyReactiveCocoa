//
//  RGBViewController.m
//  ReactiveCocoaSample
//
//  Created by 阮沧晖 on 2020/2/29.
//  Copyright © 2020 阮沧晖. All rights reserved.
//

#import "RGBViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>;


@interface RGBViewController ()
@property (weak, nonatomic) IBOutlet UISlider *RSilder;
@property (weak, nonatomic) IBOutlet UISlider *GSilder;
@property (weak, nonatomic) IBOutlet UISlider *BSilder;

@property (weak, nonatomic) IBOutlet UITextField *RTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *GTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *BTextFiled;
@property (weak, nonatomic) IBOutlet UIView *RGBDisplayView;
@end

@implementation RGBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化控件的值
    self.RTextFiled.text = self.GTextFiled.text = self.BTextFiled.text  = @"0.5";
    //绑定关联控件
   RACSignal *rRacSignal =  [self bindControl:self.RSilder textFiled:self.RTextFiled];
   RACSignal *gRacSignal =  [self bindControl:self.GSilder textFiled:self.GTextFiled];
   RACSignal *bRacSignal =  [self bindControl:self.BSilder textFiled:self.BTextFiled];
    
    //转换并显示
    [[[RACSignal combineLatest:@[rRacSignal,gRacSignal,bRacSignal]]  map:^id _Nullable(RACTuple * _Nullable value) {
           return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1.0];
       }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
           dispatch_async(dispatch_get_main_queue(), ^{
               self.RGBDisplayView.backgroundColor = x;
           });
    }];
    
}

- (RACSignal *)bindControl:(UISlider *)slider textFiled:(UITextField *)textFiled{
  //修复要输完才有值
    RACSignal *ts = [[textFiled rac_textSignal] take:1];
    
  //获取控件终端信号
  RACChannelTerminal *sliderChannelTerminal = [slider rac_newValueChannelWithNilValue:nil];
  RACChannelTerminal *textChannelTerminal = [textFiled rac_newTextChannel];
  //互相绑定
  [[sliderChannelTerminal map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.02f",[value floatValue]];
    }] subscribe:textChannelTerminal];
  [textChannelTerminal subscribe:sliderChannelTerminal];
    //返回合并信号量
    return [[sliderChannelTerminal merge:textChannelTerminal] merge:ts];
}

@end
