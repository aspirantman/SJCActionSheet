//
//  SJCActionSheet.m
//  jewelry
//
//  Created by 时光与你 on 2018/8/22.
//  Copyright © 2018年 Yehwang. All rights reserved.
//

#import "SJCActionSheet.h"
/*===========================================SJCAction================================================*/
@interface SJCAction ()
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) void(^handler)(SJCAction *action);
@property (nonatomic, readwrite) SJCActionStyle style;
@end
@implementation SJCAction
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(SJCActionStyle)style handler:(void (^ __nullable)(SJCAction *action))handler{
    
    SJCAction *action = [[self alloc] init];
    action.title = title ? : @"";
    action.style = style ? : 0;
    action.handler = handler ? : NULL;
    
    return action;
}
@end
/*===========================================SJCActionViewCell=======================================*/
@interface SJCActionViewCell : UITableViewCell
- (void)setAction:(SJCAction *)action;
- (void)showBottomLine:(BOOL)show;
@end
float const PopoverViewCellHorizontalMargin = 15.f; ///< 水平边距
float const PopoverViewCellVerticalMargin = 3.f; ///< 垂直边距
@interface SJCActionViewCell ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) UIView *bottomLine;
@end
@implementation SJCActionViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = self.backgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews{
    // UI
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.userInteractionEnabled = NO;
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.titleLabel.font = [UIFont systemFontOfSize:18];
    _button.backgroundColor = self.contentView.backgroundColor;
    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.contentView addSubview:_button];
    
    // Constraint
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_button]-margin-|" options:kNilOptions metrics:@{@"margin" : @(PopoverViewCellHorizontalMargin)} views:NSDictionaryOfVariableBindings(_button)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_button]-margin-|" options:kNilOptions metrics:@{@"margin" : @(PopoverViewCellVerticalMargin)} views:NSDictionaryOfVariableBindings(_button)]];
    
    // 底部线条
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00];
    bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:bottomLine];
    _bottomLine = bottomLine;
    
    // Constraint
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLine]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(bottomLine)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomLine(lineHeight)]|" options:kNilOptions metrics:@{@"lineHeight" : @(1/[UIScreen mainScreen].scale)} views:NSDictionaryOfVariableBindings(bottomLine)]];
}

- (void)setAction:(SJCAction *)action{
    [_button setTitle:action.title forState:UIControlStateNormal];
    switch (action.style) {
        case SJCActionStyleDefault:
            [_button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
            break;
        case SJCActionStyleCancel:
            [_button setTitleColor:[UIColor colorWithRed:245/255.0 green:201/255.0 blue:89/255.0 alpha:1.0] forState:UIControlStateNormal];
            break;
        case SJCActionStyleDestructive:
            [_button setTitleColor:[UIColor colorWithRed:228/255.0 green:68/255.0 blue:71/255.0 alpha:1.0] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}
- (void)showBottomLine:(BOOL)show{
    _bottomLine.hidden = !show;
}
@end

/*===========================================SJCActionSheetHeader=======================================*/
@interface SJCActionSheetHeader : UIView
@property(strong,nonatomic) UILabel *titleLabel;
@property(strong,nonatomic) UILabel *messageLabel;
@property(strong,nonatomic) UILabel *onlyOneLabel;
@property(strong,nonatomic) UIView *bottomLine;
- (void)realoadHeader:(NSString *)title andMessage:(NSString *)message;
@end

@implementation SJCActionSheetHeader
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls{
    self.backgroundColor = [UIColor clearColor];
    _onlyOneLabel = [UILabel new];
    _onlyOneLabel.textColor = [UIColor lightGrayColor];
    _onlyOneLabel.textAlignment = NSTextAlignmentCenter;
    _onlyOneLabel.numberOfLines = 1;//标题和描述目前只支持一行，因为也不会太长，支持多行也挺简单
    _onlyOneLabel.hidden = YES;
    [self addSubview:_onlyOneLabel];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 1;
    _titleLabel.hidden = YES;
    [self addSubview:_titleLabel];
    
    _messageLabel = [UILabel new];
    _messageLabel.textColor = [UIColor lightGrayColor];
    _messageLabel.font = [UIFont systemFontOfSize:12];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.numberOfLines = 1;
    _messageLabel.hidden = YES;
    [self addSubview:_messageLabel];
    
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00];
    [self addSubview:_bottomLine];

}

- (void)realoadHeader:(NSString *)title andMessage:(NSString *)message{
    
    if (![self isBlankString:title]&&![self isBlankString:message]) {
        _titleLabel.hidden = NO;
        _messageLabel.hidden = NO;
        _titleLabel.text = title;
        _messageLabel.text = message;
    }else if (![self isBlankString:title]&&[self isBlankString:message]){
        _onlyOneLabel.hidden = NO;
        _onlyOneLabel.font = [UIFont boldSystemFontOfSize:14];
        _onlyOneLabel.text = title;
    }else if ([self isBlankString:title]&&![self isBlankString:message]){
        _onlyOneLabel.hidden = NO;
        _onlyOneLabel.font = [UIFont systemFontOfSize:12];
        _onlyOneLabel.text = message;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - (1 / [UIScreen mainScreen].scale), CGRectGetWidth(self.bounds), (1 / [UIScreen mainScreen].scale));
    _onlyOneLabel.frame = self.bounds;
    _titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 30);
    _messageLabel.frame = CGRectMake(0, 20, CGRectGetWidth(self.bounds), 30);
}

- (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

@end
/*===========================================SJCActionSheet=======================================*/
static CGFloat const SJCActionViewCellHeight = 50.f;
static NSString *SJCActionViewCellID = @"SJCActionViewCell";
static NSString *kTitle = @"";
static NSString *kMessage = @"";
static CGFloat const SJCActionViewFooterHeight = 50.f;
static CGFloat const SJCActionViewFooterMarginHeight = 5.5f;
static CGFloat SJCActionViewHeaderHeight = 0.f;
@interface SJCActionSheet ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, weak) UIWindow *keyWindow;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic,strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, copy) NSArray<SJCAction *> *actions;
@property (nonatomic, assign) CGFloat windowWidth;
@property (nonatomic, assign) CGFloat windowHeight;
@property (nonatomic, assign) CGFloat sheetHeight;

@property(strong,nonatomic) UIView *marginView;
@property(strong,nonatomic) UIButton *cancleBtn;

@property(strong,nonatomic) SJCActionSheetHeader *headerView;
@end

@implementation SJCActionSheet

+ (instancetype)sjcSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message{
    kTitle = title;
    kMessage = message;
    if ([self isBlankString:kTitle]&&[self isBlankString:kMessage]) {
        SJCActionViewHeaderHeight = 0.f;
    }else if (![self isBlankString:kTitle]&&![self isBlankString:kMessage]){
        SJCActionViewHeaderHeight = 50.f;
    }else{
        SJCActionViewHeaderHeight = 44.f;
    }
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-SJCActionViewFooterMarginHeight-SJCActionViewFooterHeight);
    _visualEffectView.frame = self.bounds;
    _marginView.frame = CGRectMake(0, CGRectGetHeight(_tableView.bounds), self.frame.size.width, SJCActionViewFooterMarginHeight);
    _cancleBtn.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-SJCActionViewFooterHeight, self.frame.size.width, SJCActionViewFooterHeight);
}

- (void)initialize{
    // data
    _actions = @[];
    
    // current view
    self.backgroundColor = [UIColor clearColor];
    
    // keyWindow
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _windowWidth = CGRectGetWidth(_keyWindow.bounds);
    _windowHeight = CGRectGetHeight(_keyWindow.bounds);
    
    // shadeView
    _shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    _shadeView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.25f];
    _shadeView.alpha = 0.f;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_shadeView addGestureRecognizer:tapGesture];
    
    //visualEffectView
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self insertSubview:_visualEffectView atIndex:0];
    
    //headerView
    _headerView = [[SJCActionSheetHeader alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), SJCActionViewHeaderHeight)];
    [_headerView realoadHeader:kTitle andMessage:kMessage];
    
    
    // tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor blackColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 0.0;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = _headerView;
    [_tableView registerClass:[SJCActionViewCell class] forCellReuseIdentifier:SJCActionViewCellID];
    [self addSubview:_tableView];
    
    // UI
    _marginView = [[UIView alloc] initWithFrame:CGRectZero];
    _marginView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.07];
    [self addSubview:_marginView];
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancleBtn.backgroundColor = self.backgroundColor;
    _cancleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_cancleBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancleBtn];
    
}


- (void)showWithActions:(NSArray<SJCAction *> *)actions{
    if (!actions) {
        _actions = @[];
    } else {
        _actions = [actions copy];
    }
    CGFloat currentX = 0;
    CGFloat currentW = _windowWidth;
    [_tableView reloadData];
    self.sheetHeight = _tableView.contentSize.height;
    if (_actions.count<=6) {
        self.sheetHeight = SJCActionViewCellHeight * _actions.count +SJCActionViewFooterHeight + SJCActionViewFooterMarginHeight + SJCActionViewHeaderHeight;
        _tableView.scrollEnabled = NO;
    }else{
        self.sheetHeight = SJCActionViewCellHeight *6 +SJCActionViewFooterHeight + SJCActionViewFooterMarginHeight + SJCActionViewHeaderHeight;
        _tableView.scrollEnabled = YES;
    }
    CGFloat currentY = _windowHeight;
    self.frame = CGRectMake(currentX, currentY, currentW, self.sheetHeight);
    // 遮罩层
    [_keyWindow addSubview:_shadeView];
    [_keyWindow addSubview:self];
    //显示
    [UIView animateWithDuration:0.25f animations:^{
        self.shadeView.alpha = 1.f;
        self.frame = CGRectMake(currentX, self.windowHeight - self.sheetHeight, currentW, self.sheetHeight);
    }];
    
}

- (void)hide{
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = CGRectMake(0, self.windowHeight, self.windowWidth, self.sheetHeight);
        self.shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _actions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SJCActionViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SJCActionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SJCActionViewCellID];
    [cell setAction:_actions[indexPath.row]];
    [cell showBottomLine: indexPath.row < _actions.count - 1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = CGRectMake(0, self.windowHeight, self.windowWidth, self.sheetHeight);
        self.shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        SJCAction *action = self.actions[indexPath.row];
        action.handler ? action.handler(action) : NULL;
        self.actions = nil;
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

+ (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

- (void)dealloc{
    
}
@end
