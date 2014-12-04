//
//  WeiJiFenEngine.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFUserInfo.h"

#define LS_USERINFO_CHANGED_NOTIFICATION @"LS_USERINFO_CHANGED_NOTIFICATION"

typedef void(^onAppServiceBlock)(NSInteger tag, NSDictionary* jsonRet, NSError* err);

@interface WeiJiFenEngine : NSObject

@property (nonatomic,readonly) NSString* baseUrl;

@property(nonatomic, strong) NSString *confirm;
@property(nonatomic, strong) NSString* token;
@property(nonatomic, strong) NSString* userPassword;
@property(nonatomic, strong) NSString* uid;
@property(nonatomic, strong) JFUserInfo* userInfo;

+ (WeiJiFenEngine*)shareInstance;
+ (NSString*)getErrorMsgWithReponseDic:(NSDictionary*)dic;
+ (NSString*)getErrorCodeWithReponseDic:(NSDictionary*)dic;

- (NSString*)getCurrentAccoutDocDirectory;
- (void)saveAccount;
- (void)deleteAccount;
- (BOOL)hasAccoutLoggedin;
- (void)logout;

/**
 *  登录成功后，保存用户token，后面的所有接口请求用到
 *
 *  @param str token
 */
+ (void)saveUserToken:(NSString *)str;

+ (NSString *)userToken;

#pragma mark -Delegate
- (int)getConnectTag;
- (void)addOnAppServiceBlock:(onAppServiceBlock)block tag:(NSInteger)tag;
- (void)removeOnAppServiceBlockForTag:(NSInteger)tag;

#pragma mark - HttpRequest
//test
- (BOOL)querySysUserInfo:(NSString *)uid tag:(int)tag;
//注册接口
- (BOOL)registerUserInfo:(NSString *)userName mobile:(NSString *)mobile password:(NSString *)password confirm:(NSString *)confirm tag:(int)tag;
//登陆接口
- (BOOL)logInUserInfo:(NSString *)userName token:(NSString *)token password:(NSString *)password confirm:(NSString *)confirm tag:(int)tag;
//商品列表
- (BOOL)getCommodityListWithToken:(NSString *)token confirm:(NSString *)confirm type:(int)type page:(int)page pageSize:(int)pageSize tag:(int)tag;
//商品详情
- (BOOL)commodityShowWithToken:(NSString *)token confirm:(NSString *)confirm pId:(NSString *)pId tag:(int)tag;
/*!@brief 确认购买信息
 *
 * @param tid 主题id
 * @param pid 商品id
 * @param count 购买数量
 * @param buyercontact 收货地址
 * @param buyername 收货人姓名
 * @param buyerzip 邮编
 * @param buyerphone 收货人电话
 * @param buyermobile 收货人手机
 * @param buyermsg 备注信息
 * @param transportfee 运费 物流方式只有为2买家承担运费才传这个值其他为0
 */
- (BOOL)confirmBuyWithTId:(NSString *)tid pId:(NSString *)pid count:(int)count buyercontact:(NSString *)buyercontact buyername:(NSString *)buyername buyerzip:(NSString *)buyerzip buyerphone:(NSString *)buyerphone buyermobile:(NSString *)buyermobile buyermsg:(NSString *)buyermsg transportfee:(int)transportfee tag:(int)tag;
//确认付款信息
- (BOOL)confirmPaymentWithOrderId:(NSString *)orderId message:(NSString *)message password:(NSString *)password tag:(int)tag;
//取消交易
- (BOOL)cancelTradeWithOrderId:(NSString *)orderId message:(NSString *)message password:(NSString *)password tag:(int)tag;


//帮助列表 社区交流 社区晒单
- (BOOL)getHelpListWithToken:(NSString *)token confirm:(NSString *)confirm fId:(NSString *)fId page:(int)page pageSize:(int)pageSize tag:(int)tag;
//我的帖子
- (BOOL)getMyCommunityWithToken:(NSString *)token confirm:(NSString *)confirm page:(int)page pageSize:(int)pageSize tag:(int)tag;
//帖子详情
- (BOOL)getHelpInfoWithToken:(NSString *)token confirm:(NSString *)confirm fId:(NSString *)fId tId:(NSString *)tId tag:(int)tag;
//网站任务
- (BOOL)getWebTaskInfoWithToken:(NSString *)token confirm:(NSString *)confirm page:(int)page pageSize:(int)pageSize tag:(int)tag;
#pragma mark - account
/*!@brief 发送消息
 * @param plid 第一次发送就为空
 */
- (BOOL)sendMessageWithPlid:(NSString *)plid receiveuid:(NSString *)receiveuid message:(NSString *)message tag:(int)tag;
//在线消息
- (BOOL)onlineMessageListWithReceiveUid:(NSString *)receiveuid tag:(int)tag;
//用户消息
- (BOOL)getUserMessagesWithToken:(NSString *)token confirm:(NSString *)confirm tag:(int)tag;
//系统消息
- (BOOL)getSystemMessagesWithToken:(NSString *)token confirm:(NSString *)confirm page:(int)page pageSize:(int)pageSize tag:(int)tag;

//好友列表
- (BOOL)getFriendListWithTag:(int)tag;
//好友资料
- (BOOL)getPersonalInfoWithUserId:(NSString *)uid tag:(int)tag;
//我的资料
- (BOOL)getMyProfileWithUserId:(NSString *)uid tag:(int)tag;
//我的奖品
- (BOOL)getMyPrizeWithUserId:(NSString *)uid tag:(int)tag;
//排行榜
- (BOOL)getRankListWithPage:(int)page pageSize:(int)pageSize tag:(int)tag;

/*!@brief 我来回答
 * @param pid 留言id 对已经留言人进行回复
 * @param tid 主题id
 * @param fid 版块id
 */
- (BOOL)userReplyMessageWithPid:(NSString *)pid tid:(NSString *)tid fid:(NSString *)fid message:(NSString *)message tag:(int)tag;

/*!@brief 发布新帖
 * @param fid 版块id
 */
- (BOOL)publishNewThreadWithFid:(NSString *)fid title:(NSString *)title message:(NSString *)message tag:(int)tag;
/*!@brief 立即申请
 */
- (BOOL)doApplyWithTaskid:(NSString *)taskid tag:(int)tag;
//添加好友
- (BOOL)addFriendWithFuid:(NSString *)fuid gid:(NSString *)gid note:(NSString *)note tag:(int)tag;
@end
