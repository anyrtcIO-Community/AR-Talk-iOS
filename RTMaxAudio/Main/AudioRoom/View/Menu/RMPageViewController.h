//
//  RMPageViewController.h
//  RTMaxAudio
//
//  Created by zjq on 2018/10/26.
//  Copyright © 2018 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RMPageType) {
    RMPageReportType = 0,
    RMPageMessageType,
};

@interface RMPageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, assign) RMPageType pageType;

typedef void(^ButtonEvent)(NSString *userID,RMPageType pageType,BOOL rightButton);
@property (nonatomic, copy) ButtonEvent buttonEvent;

@end

NS_ASSUME_NONNULL_END
