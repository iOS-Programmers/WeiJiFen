//
//  TopicDetailsViewController.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-24.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "TopicDetailsViewController.h"
#import "WeiJiFenEngine.h"
#import "UIImageView+WebCache.h"
#import "CommentInfoViewCell.h"
#import "JFCommentInfo.h"

@interface TopicDetailsViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UIView *contentContainerView;
@property (nonatomic, strong) IBOutlet UIImageView *userAvatar;
@property (nonatomic, strong) IBOutlet UILabel *topicLabel;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) IBOutlet UIView *priceContainerView;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UIButton *replyButton;
@property (nonatomic, strong) IBOutlet UILabel *replyLabel;

@end

@implementation TopicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"帖子详情";
    if (_isFromHelp) {
        self.title = @"帮助详情";
    }
    [self.tableView reloadData];
    [self refreshTopicInfo];
    [self refeshHeaderView];
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

- (void)refeshHeaderView{
    
    [self.userAvatar sd_setImageWithURL:_topicInfo.userAvatarUrl placeholderImage:[UIImage imageNamed:@"jf_message_icon.png"]];
    self.userNameLabel.text = _topicInfo.author;
    self.dateLabel.text = [LSCommonUtils secondChangToDate:[NSString stringWithFormat:@"%d",_topicInfo.dateline]];
    self.replyLabel.text = [NSString stringWithFormat:@"  网友回答（%d）",_topicInfo.replies];
    
    [self.replyButton setImage:[UIImage imageNamed:@"jf_topic_reply_icon.png"] forState:UIControlStateNormal];
    [self.replyButton setTitle:@"  发表回复" forState:UIControlStateNormal];
    if (_isFromHelp) {
        [self.replyButton setImage:nil forState:UIControlStateNormal];
        [self.replyButton setTitle:@"我要回答" forState:UIControlStateNormal];
    }
    
    self.topicLabel.text = _topicInfo.subject;
    CGRect frame = self.topicLabel.frame;
    frame.size.width = self.view.frame.size.width - 10*2;
//    self.topicLabel.frame = frame;
    
    float textHeight = [self.topicLabel sizeThatFits:CGSizeMake(frame.size.width, CGFLOAT_MAX)].height;
    frame.size.height = textHeight;
    self.topicLabel.frame = frame;
    
    CGFloat replyButtonOriginY = self.topicLabel.frame.origin.y + self.topicLabel.frame.size.height;
    self.priceContainerView.hidden = YES;
    if (_isFromHelp) {
        self.priceContainerView.hidden = NO;
        frame = self.priceContainerView.frame;
        frame.origin.y = self.topicLabel.frame.origin.y + self.topicLabel.frame.size.height + 25;
        self.priceContainerView.frame = frame;
        replyButtonOriginY = self.priceContainerView.frame.origin.y + self.priceContainerView.frame.size.height;
    }
    
    frame = self.contentContainerView.frame;
    frame.size.height = replyButtonOriginY + 25 + self.replyButton.frame.size.height;
    self.contentContainerView.frame = frame;
    
    frame = self.replyLabel.frame;
    frame.origin.y = self.contentContainerView.frame.origin.y + self.contentContainerView.frame.size.height + 21;
    self.replyLabel.frame = frame;
    
    frame = self.headView.frame;
    frame.size.height = self.replyLabel.frame.origin.y + self.replyLabel.frame.size.height;
    self.headView.frame = frame;
    self.tableView.tableHeaderView = self.headView;
    
}

#pragma mark - custom
-(void)refreshTopicInfo{
    __weak TopicDetailsViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getHelpInfoWithToken:nil confirm:[WeiJiFenEngine shareInstance].confirm fId:_topicInfo.fId tId:_topicInfo.tId tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        NSDictionary *infoDic = [jsonRet objectForKey:@"data"];
        [_topicInfo setTopicInfoByDic:infoDic];
        [weakSelf refeshHeaderView];
        [weakSelf.tableView reloadData];
        
    } tag:tag];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _topicInfo.comments.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JFCommentInfo *commentInfo = _topicInfo.comments[indexPath.row];
    
    return [CommentInfoViewCell getCommentInfoViewCellHeight:commentInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CommentInfoViewCell";
    CommentInfoViewCell *cell = (CommentInfoViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JFCommentInfo *commentInfo = _topicInfo.comments[indexPath.row];
    cell.commentInfo = commentInfo;
    
    return cell;
}

@end
