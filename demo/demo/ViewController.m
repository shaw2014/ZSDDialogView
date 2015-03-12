//
//  ViewController.m
//  demo
//
//  Created by zhaoxiao on 15/3/12.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import "ViewController.h"
#import "CustomDialogView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(100, 100, 100, 50)];
    [btn setTitle:@"show" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showAlert:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)showAlert:(id)sender
{
    CustomDialogView *dialog = [[CustomDialogView alloc]initWithTitle:@"提示" message:@"准备好了吗？" buttonTitles:@"确定",@"取消", nil];
    [dialog showWithCompletion:^(NSInteger selectIndex) {
        NSLog(@"action selected %ld",selectIndex);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
