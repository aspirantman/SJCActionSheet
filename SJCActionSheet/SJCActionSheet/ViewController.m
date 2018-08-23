//
//  ViewController.m
//  SJCActionSheet
//
//  Created by 时光与你 on 2018/8/23.
//  Copyright © 2018年 Yehwang. All rights reserved.
//

#import "ViewController.h"
#import "SJCActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *back = [[UIImageView alloc] initWithFrame:self.view.bounds];
    back.image = [UIImage imageNamed:@"backView"];
    [self.view insertSubview:back atIndex:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAction:(UIButton *)sender {
    SJCActionSheet *sheet = [SJCActionSheet sjcSheetWithTitle:@"提示" message:@"去App Store评个分吧"];
    SJCAction *action1 = [SJCAction actionWithTitle:@"好的" style:SJCActionStyleDefault handler:^(SJCAction *action) {
        NSLog(@"点击了%@",action.title);
    }];
    SJCAction *action2 = [SJCAction actionWithTitle:@"等等" style:SJCActionStyleCancel handler:^(SJCAction *action) {
        NSLog(@"点击了%@",action.title);
    }];
    SJCAction *action3 = [SJCAction actionWithTitle:@"忽略" style:SJCActionStyleDestructive handler:^(SJCAction *action) {
        NSLog(@"点击了%@",action.title);
    }];
    [sheet showWithActions:@[action1, action2, action3]];
}
@end
