//
//  RMMenuView.m
//  RTMaxAudio
//
//  Created by zjq on 2018/10/25.
//  Copyright © 2018 derek. All rights reserved.
//

#import "RMMenuView.h"
#import "LHSlideViews.h"
#import "RMPageViewController.h"

@interface RMMenuView()<LHSlideViewsDelegate>
{
    NSInteger lastPage;
}
@property (nonatomic, strong) LHSlideViews *slideView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *views;


@end

@implementation RMMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lastPage = 0;
        self.titleArray = [[NSMutableArray alloc] initWithObjects:@"视频上报",@"广播消息", nil];
        self.views = [[NSMutableArray alloc] initWithArray:[self getViews]];
        //[[NSMutableArray alloc] initWithObjects:self.monitorView,self.callView,self.reportView,self.messageView,nil];
        self.slideView = [[LHSlideViews alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.slideView.titles = self.titleArray;
        self.slideView.pagesViews = self.views;
        self.slideView.delegate = self;
        self.slideView.menuButtonWidth = frame.size.width/4;
        self.slideView.menuTitleColor = [RMCommons getColor:@"#22C485"];
        [self.slideView reloadData];
        [self addSubview:self.slideView];
        
    }
    return self;
}
// 时间上报
- (void)event:(NSString*)userID withType:(RMPageType)type withRight:(BOOL)isRight {
    switch (type) {
        case RMPageReportType:
            if (self.mediaBlock) {
                self.mediaBlock(userID);
            }
            break;
        case RMPageMessageType:
            if (self.messageBlock) {
                self.messageBlock(userID);
            }
            break;
            
        default:
            break;
    }
}

- (NSMutableArray*)getViews {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i=0; i<2; i++) {
        RMPageViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"pageController"];
        switch (i) {
            case 0:
                controller.pageType = RMPageReportType;
                break;
            case 1:
                controller.pageType = RMPageMessageType;
                break;
                
            default:
                break;
        }
        WEAKSELF;
        controller.buttonEvent = ^(NSString * _Nonnull userID, RMPageType pageType, BOOL rightButton) {
            [weakSelf event:userID withType:pageType withRight:rightButton];
        };
        [tempArray addObject:controller];
    }
    return tempArray;
}

#pragma mark - LHSlideViewsDelegate
- (void) lHSlideViewsVisiblePageViewController:(UIViewController *)pageViewController index:(NSInteger)index {
    
    if (lastPage!= index) {
        RMPageViewController *page = [self.views objectAtIndex:lastPage];
        if (page.textField.isFirstResponder) {
            [page.textField resignFirstResponder];
        }
    }
    lastPage = index;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
