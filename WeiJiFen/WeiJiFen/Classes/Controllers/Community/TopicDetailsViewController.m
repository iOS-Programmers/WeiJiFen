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
#import "JFInputWindow.h"
#import "PersonalProfileViewController.h"

@interface TopicDetailsViewController ()<JFInputWindowDelegate>
{
    JFCommentInfo *_selCommentInfo;
    JFInputWindow *_inputSheet;
}
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

- (IBAction)replyAction:(id)sender;
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
#pragma mark - custom
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
    self.priceLabel.text = _topicInfo.price;
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

#pragma mark - request
-(void)refreshTopicInfo{
    __weak TopicDetailsViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getHelpInfoWithToken:WeiJiFenEngine.userToken confirm:[WeiJiFenEngine shareInstance].confirm fId:_topicInfo.fId tId:_topicInfo.tId tag:tag];
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

-(void)replyMessage:(NSString *)message{
    
    __weak TopicDetailsViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] userReplyMessageWithPid:_selCommentInfo.pId tid:_topicInfo.tId fid:_topicInfo.fId message:message tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        [LSCommonUtils showWarningTip:@"回复成功！" At:weakSelf.view];
        [weakSelf refreshTopicInfo];
        
    } tag:tag];
    
}
- (IBAction)replyAction:(id)sender {
    _selCommentInfo = nil;
    [self addInputView];
}

-(void)addInputView{
    
    _inputSheet = [[[NSBundle mainBundle] loadNibNamed:@"JFInputWindow" owner:nil options:nil] objectAtIndex:0];
    if (_selCommentInfo == nil) {
        _inputSheet.title = @"我来回答";
    }else if (_selCommentInfo){
        _inputSheet.title = @"回复帖子";
    }
    _inputSheet.delegate = self;
    [self.view addSubview:_inputSheet];
    [_inputSheet loadInputView];
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
        
        [cell.userAvatar addTarget:self action:@selector(userAvatarClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.replyButton addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    JFCommentInfo *commentInfo = _topicInfo.comments[indexPath.row];
    cell.commentInfo = commentInfo;
    
    return cell;
}

-(void)userAvatarClickAt:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    UITableView *tempTable = self.tableView;
    CGPoint currentTouchPosition = [touch locationInView:tempTable];
    NSIndexPath *indexPath = [tempTable indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        NSLog(@"indexPath: row:%ld", indexPath.row);
        JFCommentInfo *commentInfo = _topicInfo.comments[indexPath.row];
        NSLog(@"authorId==%@",commentInfo.authorId);
        
        JFUserInfo *userInfo = [[JFUserInfo alloc] init];
        userInfo.uid = commentInfo.authorId;
        
        PersonalProfileViewController *vc = [[PersonalProfileViewController alloc] init];
        vc.userInfo = userInfo;
        vc.userId = commentInfo.authorId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}
-(void)handleClickAt:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    UITableView *tempTable = self.tableView;
    CGPoint currentTouchPosition = [touch locationInView:tempTable];
    NSIndexPath *indexPath = [tempTable indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        NSLog(@"indexPath: row:%ld", indexPath.row);
        JFCommentInfo *commentInfo = _topicInfo.comments[indexPath.row];
        NSLog(@"pId==%@",commentInfo.pId);
        if (commentInfo.pId.length != 0) {
            _selCommentInfo = commentInfo;
            //do someSting
            [self addInputView];
        }
    }
}
#pragma mark -  JFInputWindowDelegate
-(void)publishActionWithJFInputWindow:(JFInputWindow *)inputView title:(NSString *)title content:(NSString *)content{
    
    [self replyMessage:content];
}
@end
