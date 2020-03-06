//
//  LoginViewController.m
//  ReactiveCocoaSample
//
//  Created by 阮沧晖 on 2020/2/29.
//  Copyright © 2020 阮沧晖. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.loginButton.enabled = NO;
    
    //信号合并
    //值会成为一个元组
    RACSignal *enableSingnal = [[RACSignal combineLatest:@[self.userNameLabel.rac_textSignal,self.passwordLabel.rac_textSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        NSLog(@"%@",value);
        return @([value[0] length] > 0 && [value[1] length] > 6);
    }];
    
    //按钮控制
    self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:enableSingnal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}

@end
