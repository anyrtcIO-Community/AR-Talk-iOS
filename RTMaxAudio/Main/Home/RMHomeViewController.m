//
//  RMHomeViewController.m
//  RTMaxAudio
//
//  Created by derek on 2018/6/7.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "RMHomeViewController.h"
#import "RATalkbackViewController.h"



@interface RMHomeViewController ()

@end

@implementation RMHomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)doSomeEvent:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RATalkbackViewController *talkController = [storyboard instantiateViewControllerWithIdentifier:@"talkBack"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:talkController];
    
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
