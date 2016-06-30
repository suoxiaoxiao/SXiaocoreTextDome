//
//  CustomLabel.h
//  SXiaoCoreTextDome
//
//  Created by 索晓晓 on 16/6/29.
//  Copyright © 2016年 SXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//圆角背景颜色
extern NSString * const NSRoundBackgroundColorAttributeName;
//圆角字体
extern NSString * const NSRoundFontNameAttributeName;

@interface NSMutableAttributedString (SXString)

//- (void)addAttribute:(NSString *)name value:(id)value;

@end

@interface PicPickView : UIView

@property (nonatomic ,strong)UILabel *text;

@property (nonatomic ,strong)UIImageView *bgView;

- (UIImage *)getCurrentImage;

@end

@interface CustomLabel : UILabel


@end


