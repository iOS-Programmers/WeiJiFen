//
//  ChatViewController.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-30.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "ChatViewController.h"
#import "JFMessageInfo.h"
#import "ChatCardViewCell.h"
#import "JFLocalDataManager.h"
#import "HPGrowingTextView.h"
#import "LSAlertView.h"

#define growingTextViewMaxNumberOfLines 3

@interface ChatViewController ()<HPGrowingTextViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString *plid;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *toolbarContainerView;
@property (strong, nonatomic) IBOutlet HPGrowingTextView *growingTextView;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (strong, nonatomic) IBOutlet UIImageView *inputViewBgImageView;

@end

@implementation ChatViewController

- (void)dealloc{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    _growingTextView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.title = @"消息";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _dataSource = [[NSMutableArray alloc] init];
    
    _inputViewBgImageView.image = [[UIImage imageNamed:@"s_n_chat_bottom_input_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
    _growingTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _growingTextView.minNumberOfLines = 1;
    _growingTextView.maxNumberOfLines = growingTextViewMaxNumberOfLines;
    _growingTextView.returnKeyType = UIReturnKeySend; //just as an example
    _growingTextView.font = [UIFont systemFontOfSize:15.0f];
    _growingTextView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
    _growingTextView.delegate = self;
    _growingTextView.backgroundColor = [UIColor clearColor];
    _growingTextView.internalTextView.backgroundColor = [UIColor clearColor];
    self.placeHolderLabel.hidden = NO;
    
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self                                                                         action:@selector(growingTextViewClicked)];
    [_growingTextView addGestureRecognizer:tapgesture];
    
    if (_peerId.length == 0) {
        [LSCommonUtils showWarningTip:@"会话无效" At:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self loadMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)growingTextViewClicked{
    
    if (![_growingTextView isFirstResponder]) {
        [_growingTextView becomeFirstResponder];
    }
}

#pragma mark - request
- (void)loadMessage{
    
    __weak ChatViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] onlineMessageListWithReceiveUid:_peerId tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
//            return;
        }
        
        NSArray *TmpMsgArray = [jsonRet arrayObjectForKey:@"data"];
//        NSArray *TmpMsgArray = [[JFLocalDataManager shareInstance] getTESTOnlineMsg];
        for (int i = 0; i < TmpMsgArray.count; i++) {
            NSDictionary *dic = [TmpMsgArray objectAtIndex:i];
            JFMessageInfo *messageInfo = [[JFMessageInfo alloc] init];
            [messageInfo setOnLineMsgInfoByDic:dic];
            if (i%2 == 1) {
                messageInfo.isSender = YES;
            }
            [weakSelf.dataSource addObject:messageInfo];
        }
        [weakSelf.tableView reloadData];
        
    } tag:tag];
}

-(void)sendMessage{
    
    NSString *searchContent = [self.growingTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([searchContent length] == 0) {
        LSAlertView *alertView = [[LSAlertView alloc] initWithTitle:nil message:@"消息不能为空" cancelButtonTitle:@"确定"];
        [alertView show];
        return;
    }
    
    __weak ChatViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] sendMessageWithPlid:_plid receiveuid:_peerId message:self.growingTextView.text tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        [weakSelf loadMessage];
        
    } tag:tag];
    
}

#pragma mark - UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JFMessageInfo *msgInfo = self.dataSource[indexPath.row];
    return [ChatCardViewCell getChatCardViewCellHeight:msgInfo];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ChatCardViewCell";
    ChatCardViewCell *cell = (ChatCardViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JFMessageInfo *msgInfo = self.dataSource[indexPath.row];
    cell.messageInfo = msgInfo;
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -HPGrowingTextViewDelegate
#define MAX_REPLY_TEXT_LENGTH 256
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView{
    
    if (growingTextView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.hidden = YES;
    }
    return YES;
}
- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView{
    
    if (_growingTextView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.hidden = YES;
    }
//    _textRange = growingTextView.selectedRange;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = _toolbarContainerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    _toolbarContainerView.frame = r;
}
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
//    _textRange = growingTextView.selectedRange;
    if (growingTextView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    } else {
        self.placeHolderLabel.hidden = NO;
    }
}


- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if([LSCommonUtils getHanziTextNum:growingTextView.text] > _maxReplyTextLength) {
//        
//        LSAlertView *alertView = [[LSAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"回复文字不可以超过%d个字符", _maxReplyTextLength] cancelButtonTitle:@"确定"];
//        [alertView show];
//        
//        return NO;
//    }
    if ([text isEqualToString:@"\n"]) {
        [self sendMessage];
        return NO;
        
    }
    return YES;
}

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView{
//    _textRange = growingTextView.selectedRange;
}
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
    [self sendMessage];
    return YES;
}

-(void) keyboardWillShow:(NSNotification *)note{
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = _toolbarContainerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height = containerFrame.origin.y - tableViewFrame.origin.y;
    
    CGPoint offset = self.tableView.contentOffset;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _toolbarContainerView.frame = containerFrame;
    self.tableView.frame = tableViewFrame;
    if (self.tableView.contentSize.height >= self.tableView.frame.size.height) {
        offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
    }
    self.tableView.contentOffset = offset;
    // commit animations
    [UIView commitAnimations];
}

-(void)customKeyboardWillHide{
    
    NSNumber *curve = 0;
    // get a rect for the textView frame
    CGRect containerFrame = _toolbarContainerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height = containerFrame.origin.y - tableViewFrame.origin.y;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _toolbarContainerView.frame = containerFrame;
    self.tableView.frame = tableViewFrame;
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = _toolbarContainerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height = containerFrame.origin.y - tableViewFrame.origin.y;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _toolbarContainerView.frame = containerFrame;
    self.tableView.frame = tableViewFrame;
    // commit animations
    [UIView commitAnimations];
}

@end
