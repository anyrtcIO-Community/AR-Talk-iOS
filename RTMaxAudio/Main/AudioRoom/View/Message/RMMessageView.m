//
//  RMMessageView.m
//  RTMaxAudio
//
//  Created by zjq on 2018/10/25.
//  Copyright © 2018 derek. All rights reserved.
//

#import "RMMessageView.h"
#import "RMMessageCell.h"

static NSString *rmMessageCell = @"RMMessageCell";


@interface RMMessageView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation RMMessageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.messageArray = [[NSMutableArray alloc] initWithCapacity:5];
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"RMMessageCell" bundle:nil] forCellReuseIdentifier:rmMessageCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)sendMessage:(RMMessageModel*)message {
    
    [self.messageArray addObject:message];
    [self.tableView reloadData];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - UITableViewDelegate   UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RMMessageCell *cell = (RMMessageCell*)[tableView dequeueReusableCellWithIdentifier:rmMessageCell forIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.messageModel = [self.messageArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
