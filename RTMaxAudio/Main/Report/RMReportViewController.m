//
//  RMReportViewController.m
//  RTMaxAudio
//
//  Created by zjq on 2018/10/29.
//  Copyright © 2018 derek. All rights reserved.
//

#import "RMReportViewController.h"

@interface RMReportViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation RMReportViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view insertSubview:self.videoView atIndex:0];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}
- (void)dismiss {
    [self.maxKit closeReportVideo];
    [self.videoView removeFromSuperview];
    if (self.leaveBlock) {
        self.leaveBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

    
- (IBAction)doEvent:(UIButton*)sender {
    switch (sender.tag) {
        case 200:
            [self dismiss];
            break;
        case 201:
            [self.maxKit switchCamera];
            break;
        default:
            break;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
