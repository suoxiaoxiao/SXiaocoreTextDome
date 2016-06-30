//
//  ViewController.m
//  SXiaoCoreTextDome
//
//  Created by 索晓晓 on 16/6/14.
//  Copyright © 2016年 SXiao. All rights reserved.
//

#import "ViewController.h"
#import "SXCoreTextView.h"
#import "CustomLabel.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    SXCoreTextView *textView = [[SXCoreTextView alloc] init];
//    textView.frame = CGRectMake(100, 100, 200, 50);
//    textView.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:textView];
    
//    [UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
    
    CustomLabel *label = [[CustomLabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"我们我们一起我们一起奔跑,我们一起奔跑,一起戏水"];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 4)];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(4, 5)];    
    
    [attStr addAttribute:NSRoundBackgroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(attStr.length - 2, 2)];
    [attStr addAttribute:NSRoundFontNameAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(attStr.length - 2, 2)];
    label.backgroundColor = [UIColor redColor];
    label.attributedText = attStr;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
