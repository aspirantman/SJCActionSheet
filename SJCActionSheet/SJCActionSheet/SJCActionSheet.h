//
//  SJCActionSheet.h
//  jewelry
//
//  Created by 时光与你 on 2018/8/22.
//  Copyright © 2018年 Yehwang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SJCActionStyle) {
    SJCActionStyleDefault = 0,
    SJCActionStyleCancel,
    SJCActionStyleDestructive
};
@interface SJCAction : NSObject

/**
 SJCAction 初始化

 @param title 单元的标题
 @param style 单元的样式
 @param handler 处理事务
 @return 实例对象
 */
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(SJCActionStyle)style handler:(void (^ __nullable)(SJCAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) SJCActionStyle style;
@property (nonatomic, copy, readonly) void(^handler)(SJCAction *action);
@end

@interface SJCActionSheet : UIView

/**
 SJCActionSheet 初始化

 @param title 标题
 @param message 描述
 @return 实例对象
 */
+ (instancetype)sjcSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

/**
 显示

 @param actions 操作队列(默认自带一个取消按钮)
 */
- (void)showWithActions:(NSArray<SJCAction *> *)actions;
@end


