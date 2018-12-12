//
//  RMPageViewController.m
//  RTMaxAudio
//
//  Created by zjq on 2018/10/26.
//  Copyright © 2018 derek. All rights reserved.
//

#import "RMPageViewController.h"

@interface RMPageViewController ()

@end

@implementation RMPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    if (self.pageType!=RMPageMessageType) {
         self.textField.keyboardType =  UIKeyboardTypeNumberPad;
    }
}

- (void)initUI {
    self.rightButton.layer.cornerRadius = 2;
    switch (self.pageType) {
        case RMPageReportType:
        {
            [self.rightButton setTitle:@"开始上报" forState:UIControlStateNormal];
            self.textField.placeholder = @"请输入您要上报的用户ID";
        }
            break;
        case RMPageMessageType:
        {
            [self.rightButton setTitle:@"发送消息" forState:UIControlStateNormal];
            self.textField.placeholder = @"请输入消息内容";
        }
            break;
            
        default:
            break;
    }
}


- (IBAction)rightButtonEvent:(id)sender {
    if (self.textField.text.length == 0) {
        [RMCommons showCenterWithText:@"请输入内容"];
        return;
    }
    [self.textField resignFirstResponder];
   
    if (self.buttonEvent) {
        self.buttonEvent(self.textField.text, self.pageType, YES);
    }
    if (self.pageType == RMPageMessageType) {
        self.textField.text = @"";
    }
//     self.textField.text = @"";
}

- (IBAction)leftButtonEvent:(id)sender {
    if (self.textField.text.length == 0) {
        [RMCommons showCenterWithText:@"请输入内容"];
        return;
    }
    [self.textField resignFirstResponder];
    
    if (self.buttonEvent) {
        self.buttonEvent(self.textField.text, self.pageType, NO);
    }
    self.textField.text = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
