//
//  RMMessageCell.m
//  RTMaxAudio
//
//  Created by zjq on 2018/10/25.
//  Copyright © 2018 derek. All rights reserved.
//

#import "RMMessageCell.h"

@implementation RMMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.bgImageView.layer.cornerRadius = 2;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageLabel).insets(UIEdgeInsetsMake(-5, -10, -5, -10));
    }];
}

- (void)setMessageModel:(RMMessageModel *)messageModel {
    _messageModel = messageModel;
    NSString *str;
    if (messageModel.isMe) {
        str = [NSString stringWithFormat:@"我:%@",messageModel.messageStr];
        self.messageLabel.text = str;
        self.messageLabel.textColor = [UIColor whiteColor];
        self.bgImageView.backgroundColor = [RMCommons getColor:@"#08C37A"];
    }else{
        str = [NSString stringWithFormat:@"%@:%@",messageModel.userID,messageModel.messageStr];
        self.messageLabel.text = str;
        self.messageLabel.textColor = [RMCommons getColor:@"#666666"];
        self.bgImageView.backgroundColor = [UIColor whiteColor];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
