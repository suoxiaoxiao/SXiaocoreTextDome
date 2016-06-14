//
//  ViewController.m
//  SXiaoCoreTextDome
//
//  Created by 索晓晓 on 16/6/14.
//  Copyright © 2016年 SXiao. All rights reserved.
//

#import "ViewController.h"
#import "SXCoreTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SXCoreTextView *textView = [[SXCoreTextView alloc] init];
    textView.frame = CGRectMake(100, 100, 200, 50);
    textView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:textView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
