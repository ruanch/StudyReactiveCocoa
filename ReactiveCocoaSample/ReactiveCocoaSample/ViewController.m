//
//  ViewController.m
//  ReactiveCocoaSample
//
//  Created by 阮沧晖 on 2020/2/26.
//  Copyright © 2020 阮沧晖. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong) NSArray *viewControllers;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 常规
    //self.title = @"ReactiveCocoa 常用示例";
    
    //用禾括号代替赋值
    self.navigationItem.titleView = ({
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"ReactiveCocoa 常用示例";
        [titleLabel sizeToFit];
        titleLabel;
    });
    
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] init];
        rightButtonItem.title = @"学习";
        rightButtonItem.target = self;
        rightButtonItem.action = @selector(clickVedio);
        rightButtonItem;
    });
    
    
    _titleArray = @[@"登录示例",@"RGB颜色控制示例",@"网络请求获取数据",@"获取定位示例"];
    _viewControllers = @[@"LoginViewController",@"RGBViewController",@"RequestViewController",@"LocationViewController"];
}

- clickVedio{
    NSLog(@"click study");
    return nil;
}


#pragma mark -UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idf = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idf];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idf];
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vcString = _viewControllers[indexPath.row];
    [self.navigationController pushViewController:[[NSClassFromString(vcString) alloc] init] animated:YES];
}


@end
