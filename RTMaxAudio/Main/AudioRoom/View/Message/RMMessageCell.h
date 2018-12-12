//
//  RMMessageCell.h
//  RTMaxAudio
//
//  Created by zjq on 2018/10/25.
//  Copyright © 2018 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, strong) RMMessageModel *messageModel;

@end

NS_ASSUME_NONNULL_END
