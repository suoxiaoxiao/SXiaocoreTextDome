//
//  SXCoreTextView.m
//  SXiaoCoreTextDome
//
//  Created by 索晓晓 on 16/6/14.
//  Copyright © 2016年 SXiao. All rights reserved.
//

#import "SXCoreTextView.h"
#import <CoreText/CoreText.h>


@implementation SXCoreTextView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //将坐标系上下翻转
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 创建绘制区域,CoreText本身支持各种文字排版的区域
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddEllipseInRect(path, NULL, self.bounds);
    
    NSAttributedString *attString = [[NSAttributedString alloc]initWithString:@"Hello World!"];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) attString);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    
    CFRelease(path);
    
    CFRelease(framesetter);
    
}

@end
