//
//  CustomDialogView.m
//  Qian100
//
//  Created by zhaoxiao on 14-11-13.
//  Copyright (c) 2014年 ZOSENDA. All rights reserved.
//

#import "CustomDialogView.h"

#define kBaseTag 1000
#define kContentViewWidth 260.0f
#define kButtonHeight 45.0f
#define kMarginLeftRight 9.0f
#define kMarginTopButtom 22.0f

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CustomDialogView ()
{
    UIView *contentView;
    UIButton *cancelBtn;
    
    UIImage *titleImage;
    UILabel *titleLabel;
    
    NSLayoutConstraint *contentViewHeightConstraint;
}

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,retain) NSMutableArray *buttonTitleList;

@property (nonatomic,copy) void (^dialogViewCompleteHandle)(NSInteger);

@end

@implementation CustomDialogView

-(id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        
        self.title = title;
        
        self.message = message;
        
        va_list args;
        va_start(args, otherButtonTitles);
        _buttonTitleList = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*))
        {
            [_buttonTitleList addObject:str];
        }
        va_end(args);
        
        [self setup];
    }
    
    return self;
}

/**
 *  view初始化
 */
-(void)setup
{
    //内容视图
    contentView = [[UIView alloc]init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.clipsToBounds = YES;
    contentView.backgroundColor = UIColorFromRGB(0xe8e8e8);
    [contentView.layer setCornerRadius:5.0f];
    [self addSubview:contentView];
    
    NSDictionary *bindDic_contentView = NSDictionaryOfVariableBindings(contentView);
    NSString *formatStr_contentView = [NSString stringWithFormat:@"H:[contentView(%f)]",kContentViewWidth];
    NSArray *contentView_H = [NSLayoutConstraint constraintsWithVisualFormat:formatStr_contentView options:0 metrics:nil views:bindDic_contentView];
    NSLayoutConstraint *contentView_CX = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *contentView_CY = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraints:contentView_H];
    [self addConstraint:contentView_CX];
    [self addConstraint:contentView_CY];
    
    //标题
    titleLabel = [[UILabel alloc]init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = _title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0x333333);
    [contentView addSubview:titleLabel];
    
    NSDictionary *dic_titleLabel = @{@"width":@(150.0f)};
    NSArray *titleLabel_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[titleLabel(width)]" options:0 metrics:dic_titleLabel views:NSDictionaryOfVariableBindings(titleLabel)];
    NSLayoutConstraint *titleLabel_CX = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [contentView addConstraints:titleLabel_H];
    [contentView addConstraint:titleLabel_CX];
        
    //消息体
    UIFont *msgFont = [UIFont systemFontOfSize:16.0f];
    _msgLabel = [[UILabel alloc]init];
    _msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _msgLabel.backgroundColor = [UIColor clearColor];
    _msgLabel.font = msgFont;
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.textColor = UIColorFromRGB(0x333333);
    _msgLabel.text = _message;
    _msgLabel.numberOfLines = 0;
    [contentView addSubview:_msgLabel];
    
    //横线
    UIView *lineView = [[UIView alloc]init];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    lineView.backgroundColor = UIColorFromRGB(0xdadbdd);
    [contentView addSubview:lineView];
    
    //多按钮
    NSMutableDictionary *bindBtnsDic = [NSMutableDictionary dictionary];
    NSDictionary *dic_btns = @{@"leftRight":@(0),@"height":@(kButtonHeight)};
    NSString *formatStr_btns = @"H:|-leftRight-";
    float btnWidth = (kContentViewWidth - (_buttonTitleList.count - 1)) / _buttonTitleList.count;
    if(_buttonTitleList.count > 1)
    {
        //分割线
        UIView *lineView1 = [[UIView alloc]init];
        lineView1.translatesAutoresizingMaskIntoConstraints = NO;
        lineView1.backgroundColor = UIColorFromRGB(0xdadbdd);
        [contentView addSubview:lineView1];
        
        NSString *formate_H = [NSString stringWithFormat:@"H:|-%f-[lineView1(%f)]",btnWidth,1.0f];
        NSString *formate_V = [NSString stringWithFormat:@"V:[lineView1(%f)]|",kButtonHeight];
        NSArray *lineView1_H = [NSLayoutConstraint constraintsWithVisualFormat:formate_H options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView1)];
        NSArray *lineView1_V = [NSLayoutConstraint constraintsWithVisualFormat:formate_V options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView1)];
        [contentView addConstraints:lineView1_H];
        [contentView addConstraints:lineView1_V];
    }
    
    for (int i = 0; i < _buttonTitleList.count; i++)
    {
        UIButton *btn = [[UIButton alloc]init];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [btn setTitle:[_buttonTitleList objectAtIndex:i] forState:UIControlStateNormal];
        [btn.layer setMasksToBounds:YES];
        if(i > 0 && i == _buttonTitleList.count - 1)
        {
            [btn setTitleColor:UIColorFromRGB(0xb51d23) forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:UIColorFromRGB(0x646464) forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:kBaseTag + i];
        [contentView addSubview:btn];
        
        NSString *btnFlag = [NSString stringWithFormat:@"btn%d",i];
        [bindBtnsDic setObject:btn forKey:btnFlag];
        
        if(i > 0 && i == _buttonTitleList.count - 1)
        {
            formatStr_btns = [formatStr_btns stringByAppendingFormat:@"-1-[%@(%f)]",btnFlag,btnWidth];
        }
        else
        {
            formatStr_btns = [formatStr_btns stringByAppendingFormat:@"[%@(%f)]",btnFlag,btnWidth];
        }
        
        NSString *btn_formatStr = [NSString stringWithFormat:@"V:[btn(height@500)]|"];
        NSArray *btn_V = [NSLayoutConstraint constraintsWithVisualFormat:btn_formatStr options:0 metrics:dic_btns views:NSDictionaryOfVariableBindings(btn)];
        [contentView addConstraints:btn_V];
    }
    formatStr_btns = [formatStr_btns stringByAppendingString:@"-leftRight-|"];
    //按钮约束
    NSArray *btns_H = [NSLayoutConstraint constraintsWithVisualFormat:formatStr_btns options:0 metrics:dic_btns views:bindBtnsDic];
    [contentView addConstraints:btns_H];
    
    UIButton *relateBtn = bindBtnsDic[@"btn0"];
    NSDictionary *bindDic = @{@"titleLabel":titleLabel,@"msgLabel":_msgLabel,@"lineView":lineView,@"relateBtn":relateBtn};
    NSDictionary *paramDic = @{@"topMargin":@(kMarginTopButtom),@"lineHeight":@(1.0),@"msgMarginLeftRight":@(17.0f),@"marginTop":@(kMarginTopButtom),@"marginLeft":@(kMarginLeftRight)};
    
    //横线约束
    NSArray *lineView_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lineView]|" options:0 metrics:paramDic views:bindDic];
    [contentView addConstraints:lineView_H];
    
    //文本约束
    NSArray *msgLabel_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-msgMarginLeftRight-[msgLabel]-msgMarginLeftRight-|" options:0 metrics:paramDic views:bindDic];
    [contentView addConstraints:msgLabel_H];
    
    NSString *formatStr = @"V:|-topMargin-[titleLabel]-topMargin-[msgLabel]-topMargin-[lineView(lineHeight)][relateBtn]|";
    NSArray *views_V = [NSLayoutConstraint constraintsWithVisualFormat:formatStr options:0 metrics:paramDic views:bindDic];
    [contentView addConstraints:views_V];
    
    //自动布局后的高度
    CGSize size = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSDictionary *dic_contentView = @{@"height":@(size.height)};
    NSArray *contentView_Height = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView(height@400)]" options:0 metrics:dic_contentView views:bindDic_contentView];
    [self addConstraints:contentView_Height];
    contentViewHeightConstraint = contentView_Height[0];
}

-(void)setMessageFont:(UIFont *)messageFont
{
    if(_messageFont != messageFont)
    {
        _messageFont = messageFont;
        
        _msgLabel.font = _messageFont;
    }
}

/**
 *  点击按钮事件
 *
 *  @param sender OK按钮
 */
-(void)buttonAction:(UIButton *)sender
{
    NSInteger selIndex = sender.tag - kBaseTag;
    if(_dialogViewCompleteHandle)
    {
        _dialogViewCompleteHandle(selIndex);
    }
    [self closeView];
}

-(void)showInView:(UIView *)baseView completion:(void (^)(NSInteger))completeBlock
{
    self.dialogViewCompleteHandle = completeBlock;
    
    if(!_seriesAlert)
    {
        for (UIView *subView in baseView.subviews) {
            if([subView isKindOfClass:[CustomDialogView class]])
            {
                return;
            }
        }
    }
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [baseView addSubview:self];
    
    NSArray *view_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)];
    NSArray *view_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)];
    [baseView addConstraints:view_H];
    [baseView addConstraints:view_V];
    
    contentView.alpha = 0;
    contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3f animations:^{
        contentView.alpha = 1.0;
        contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

/**
 *  显示弹出框
 */
-(void)showWithCompletion:(void (^)(NSInteger))completeBlock
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self showInView:keyWindow completion:completeBlock];
}

/**
 *  关闭视图
 */
-(void)closeView
{
    [UIView animateWithDuration:0.3f animations:^{
        contentView.alpha = 0;
        contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
