//
//  CustomLabel.m
//  SXiaoCoreTextDome
//
//  Created by 索晓晓 on 16/6/29.
//  Copyright © 2016年 SXiao. All rights reserved.
//

/*
    1: 创建 NSMutableAttributedString  令要显示图片的地方 变成@" " 
    2: 创建图片View  并保存本地
    3: 读出图片的宽高 设置要替换的高度和宽度
    4: 绘制文字后要把图片绘制上去
 */

#import "CustomLabel.h"
#import <CoreText/CoreText.h>

#define textHeight (15)
#define textWidth (30)

NSString * const NSRoundBackgroundColorAttributeName = @"NSRoundBackgroundColorAttributeName";

NSString * const NSRoundFontNameAttributeName = @"NSRoundFontNameAttributeName";
#pragma mark - ------------------------ NSMutableAttributedString ----------------------------------------
@implementation NSMutableAttributedString (SXString)

//- (void)addAttribute:(NSString *)name value:(id)value
//{
//    if ([name isEqualToString:NSRoundBackgroundColorAttributeName]) {
////        _roundColor = (UIColor *)value;
//    }
//    if ([name isEqualToString:NSRoundFontNameAttributeName]) {
////        _roundFont = (UIFont *)value;
//    }
//
//}

@end

//
//@interface PicPickView : UIView
//
//@property (nonatomic ,strong)UILabel *text;
//
//@property (nonatomic ,strong)UIImageView *bgView;
//
//- (UIImage *)getCurrentImage;
//
//@end

#pragma mark - ------------------------ PicPickView ----------------------------------------
@implementation PicPickView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        self.text = [[UILabel alloc] init];
        self.text.backgroundColor = [UIColor clearColor];
        self.text.textAlignment = NSTextAlignmentCenter;
        self.layer.masksToBounds = YES;
        self.bgView = [[UIImageView alloc] init];
        self.bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        self.layer.cornerRadius = 5;

        [self addSubview:self.text];
    }
    return self;
}



- (UIImage *)getCurrentImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    self.text.frame = self.bounds;
}

@end

#pragma mark - ------------------------ CustomLabel ----------------------------------------
@interface CustomLabel ()
{
    UIColor  *_roundColor;
    UIFont   *_roundFont;
    NSString *_roundStr;
    NSRange  _roundRange;
    CTFrameRef _frame;
    CGFloat  _fontSize;
}
@property (nonatomic ,strong)PicPickView *picView;

@end

@implementation CustomLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.picView = [[PicPickView alloc] init];
        self.picView.text.text = @"你好";
        self.picView.frame = CGRectMake(0, 0, textWidth, textHeight);
    }
    return self;
}

//CTRun的回调，销毁内存的回调
void RunDelegateDeallocCallback( void* refCon ){
    
}

//CTRun的回调，获取高度
CGFloat RunDelegateGetAscentCallback( void *refCon ){
    NSString *imageName = (__bridge NSString *)refCon;
    
    return textHeight;//[UIImage imageNamed:imageName].size.height;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    return 0;
}
//CTRun的回调，获取宽度
CGFloat RunDelegateGetWidthCallback(void *refCon){
    NSString *imageName = (__bridge NSString *)refCon;
    return textWidth;//[UIImage imageNamed:imageName].size.width;
}

- (NSMutableAttributedString *)setUpAttributedString
{
   return  [self existenceSet];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _roundRange = NSMakeRange(0, 0);
    
    [attributedText enumerateAttributesInRange:NSMakeRange(0, attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        for (NSString *attStr in attrs.allKeys) {
            if ([attStr isEqualToString:NSRoundBackgroundColorAttributeName]) {
                _roundColor = [attrs objectForKey:NSRoundBackgroundColorAttributeName];
                _roundRange = range;
            }
            if ([attStr isEqualToString:NSRoundFontNameAttributeName]) {
                _roundFont = [attrs objectForKey:NSRoundFontNameAttributeName];
                _roundRange = range;
            }
        }
        
        if (!_roundColor) {
            _roundColor = self.textColor;
        }
        if (!_roundFont) {
            _roundFont = self.font;
        }
        
    }];
    
    self.picView.text.font = _roundFont;
    self.picView.bgView.backgroundColor = _roundColor;
    
    
    NSLog(@"%@%@%@",_roundFont,_roundColor,NSStringFromRange(_roundRange));
    
    //需要将_roundFont 东西去掉
    if (_roundRange.length == 0 || _roundRange.location == NSNotFound) {
    }else{// 需要显示
        // 1 替换空白区域位置
        _roundStr = [attributedText attributedSubstringFromRange:_roundRange].string;
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
        [att replaceCharactersInRange:_roundRange withString:@""];
        attributedText = att;
        self.picView.text.text = _roundStr;
        
        _fontSize = [_roundStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName : _roundFont} context:nil].size.height;
        NSLog(@"_fontSize = %f",_fontSize);
    }
    
    [super setAttributedText:attributedText];
}

- (NSMutableAttributedString *)existenceSet
{
//    //没有特殊设置字体
//    if (_roundRange.length == 0 || _roundRange.location == NSNotFound) {
//        return ;
//    }
    
    //设置CTRun的回调，用于针对需要被替换成图片的位置的字符，可以动态设置图片预留位置的宽高
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallback;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    //创建图片的名字
    NSString *imgName = @"smile.png";
    //创建CTRun回调
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void * _Nullable)(imgName));
    
    //这里为了简化解析文字，所以直接认为最后一个字符是需要显示图片的位置，对需要显示图片的位置，都用空字符来替换原来的字符，空格用于给图片留位置
    NSMutableAttributedString *imageAttributedString1 = [[NSMutableAttributedString alloc] initWithString:@" "];
    [att appendAttributedString:imageAttributedString1];
    
    
    
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@" "];
    //设置图片预留字符使用CTRun回调
    [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
    CFRelease(runDelegate);
    //设置图片预留字符使用一个imageName的属性，区别于其他字符
    [imageAttributedString addAttribute:@"imageName" value:imgName range:NSMakeRange(0, 1)];
    
    [att appendAttributedString:imageAttributedString];
    
    //换行模式，设置段落属性
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    CTParagraphStyleSetting settings[] = {
        lineBreakMode
    };
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)style forKey:(id)kCTParagraphStyleAttributeName ];
    [att addAttributes:attributes range:NSMakeRange(0, [att length])];
    
    return att;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    NSMutableArray *imageHeightArray = [NSMutableArray array];
    
    NSAttributedString *content = [self setUpAttributedString];
    
//    NSAttributedString *content = self.attributedText;
    
    NSLog(@"rect:%@",NSStringFromCGRect(rect));
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置context的ctm，用于适应core text的坐标体系
    CGContextSaveGState(context);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //设置CTFramesetter
    CTFramesetterRef framesetter =  CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, rect.size.width - 5, rect.size.height));
    //创建CTFrame
    _frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, content.length), path, NULL);
    //把文字内容绘制出来
    CTFrameDraw(_frame, context);
    
    //获取画出来的内容的行数
    CFArrayRef lines = CTFrameGetLines(_frame);
    //获取每行的原点坐标
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), lineOrigins);
    NSLog(@"line count = %ld",CFArrayGetCount(lines));
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        //获取每行的宽度和高度
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        NSLog(@"ascent = %f,descent = %f,leading = %f",lineAscent,lineDescent,lineLeading);
        NSLog(@"line-height = %f",lineAscent+lineDescent+lineLeading);
        [imageHeightArray addObject:[NSString stringWithFormat:@"%f",lineAscent+lineDescent+lineLeading]];
        //获取每个CTRun
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        NSLog(@"run count = %ld",CFArrayGetCount(runs));
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            //获取每个CTRun
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            NSLog(@"%@",attributes);
            
            CGRect runRect;
            //调整CTRun的rect
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            NSLog(@"width = %f , height = %f",runRect.size.width,runRect.size.height);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:@"imageName"];
            //图片渲染逻辑，把需要被图片替换的字符位置画上图片
            if (imageName) {
                UIImage *image = [_picView getCurrentImage];
                if (image) {
                    CGFloat height = 0;
                    NSString *last = [imageHeightArray lastObject];
                    [imageHeightArray removeLastObject];
                    for (NSString  *subhtight in imageHeightArray) {
                        height += [subhtight floatValue];
                    }
                    CGRect imageDrawRect;
                    imageDrawRect.size = CGSizeMake(textWidth, [_roundStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _roundFont} context:nil].size.height);
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    //截屏
//                    imageDrawRect.origin.y = lineOrigin.y;
//                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                    //UIView
                    
                    //要加字体补偿
                    imageDrawRect.origin.y = height + ([last floatValue] - _fontSize) * 0.5;
                    //CFArrayGetCount(lines) * 14 - 14 + 5;
                    self.picView.frame = imageDrawRect;
                    [self addSubview:self.picView];
                }
            }
        }
    }
    CGContextRestoreGState(context);
}



- (void)drawTextInRect:(CGRect)rect
{
}

@end






