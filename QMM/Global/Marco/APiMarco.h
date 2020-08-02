//
//  APiMarco.h
//  youbaner
//
//  Created by luzhongchang on 17/7/29.
//  Copyright © 2017年 luzhongchang. All rights reserved.
//

#ifndef APiMarco_h
#define APiMarco_h

#define USER_DEFAULTS_LOGIN_KEY @"USER_DEFAULTS_LOGIN_KEY"
#define USER_REGISTER_MOBILE_KEY @"registerkey"
#define USER_SEX_STATUES_KEY     @"usedefaultSex"


#define LOGIN_NOTIF_KEY                 @"LoginNotifiactionKey" //用户登录成功
#define LOGOUT_NOTIF_KEY                @"LoginoutNOtificationKey"//用户登出
#define LOG_KICK_OUT_NOTIF_KEY          @"LOG_KICK_OUT_NOTIF_KEY"//用户异常退出

#define LOGOUT_UPDATE_USERINFOKEY         @"updateUserInfoKey"//刷新用户信息

// ---------首页遇见
#define API_TOP_RECOMMAND                        @"gettopuserlist"//获取推荐用户
#define API_NEW_HOME                @"getuserlists"    // 有伴获取用户列表

// ------------约会
#define API_DATING_LIST             @"getuserappointments"  // 获取约会列表


#define API_DATING_INFO             @"getuserappointmentbyid"     // 约会详情
#define API_DATING_ACTION_INVITE             @"addappointment"     // 约会申请
#define API_DATING_ACTION_CANCEL             @"initiatorarevokappointmente"     // 取消约会
#define API_DATING_ACTION_CHANGE             @"changeappointmentestatus"     // 约会状态改变
#define API_DATING_ACTION_SIGNIN             @"appointmentsign"     // 约会签到
#define API_DATING_LINE             @"getuserappointmentroutebyid"     // 约会足迹




#define API_QINIU_TOKEN           @"common/getQiniuToken"             // 获取七牛Token

#define API_LOGIN                 @"login"  //登录
#define API_LOGOUT                  @"logout"

#define API_REGISTER              @"register"       //用户注册

#define API_VERIFYCODE            @"getmobilevc"      //获取验证码
#define API_NEW_VERIFY_CODE     @"userregister"     // 验证码验证

#define  API_FINDPASSWORD        @"findpass"      //用户忘记密码
#define  API_RESETPASSWORD         @"resetpass"      //修改密码

#define API_HOME_ONE              @"getoneuser"  //逛一逛
#define API_HOME                  @"getuserlist"       //首页接口
#define API_ONE_KEY_GREET_LIST  @"getakeytogreetinguserlist"    //一键打招呼数据
#define API_ONE_KEY_GREET  @"akeytogreeting"    // 一键打招呼

#define API_USER_BALANCE    @"getuserbalance"   // 获取账户余额



#define API_GETREPORTLIST         @"getsysuserreport"

#define API_ISBEMOVED             @"userbeckoning"       //用户心动接口

#define API_PROFILE           @"getuserinfo"         //自己详情
#define API_USER_INFO           @"getuserdetailbyid"         //其他用户详情

#define APT_USERINFO              @"getuserinfo"                   //用户详情

#define API_GETUPLOADMAXPHOTO     @"getuserphotomaxsize"           //获取最大上传图片数量
#define API_GETITEM               @"getproduct"                   //获取产品数值
#define API_UPLOADAVATAR          @"uploaduseravatar"           //上传用户头像
#define API_REPORT                @"userreport"

#define API_EDITORUSERINFO        @"saveuserdetail"              //修改用户基本信息

#define API_EXECUTEALIPAY         @"executealipay"            //支付宝支付
#define API_EXECUTEWECHATPAY      @"executewechatpaybytype"       //微信支付

#define API_MESSAGELIST           @"msg-getMsglist"        //用户用户信息列表
#define API_SENDMESSAGE           @"msg-sendMsg"           //发送消息
#define API_BLACKUSER             @"userblack"            //拉黑用户
#define API_MESSAGELISTBYUSERID   @"msg-getMessage"        //获取聊天列表
#define API_MESSAGE_DELETEUNREAD  @"msg-clearNewcount"     //清除用户小红点

#define API_UPLOADIDENTIFYPICTURE @"uploaduseridcard" //上传用户认证图片

#define API_UPLOADSHOWPHOTOS     @"uploaduserphoto" //上传用户认证图片

#define API_CHECKUPDATE           @"checkupdate" //检查版本更新
#define API_DELETE_PICTURE           @"removeuserphoto" //检查版本更新

#define API_CHANGEORDERSTATUS @"changeorderstatusuccess"//修改订单状态

#define API_LOGIN_OUT          @"logout" //用户推出

#define API_SAVEPARTUSE_DATA         @"saveusersomedetail" //跟新部分用户数据

#define API_BIND_PUSH                  @"bindpush"

#define API_GETADDRESS_API @"getuseraddresslist"//获取通讯列表

#define API_TRANSDETAIL_API @"getusertransbytype"//交易明细

#define API_DELAETSIGNAL_MESSAGE @"msg-removeMsglistbyid" //删除单个消息
#define API_PREPAYAPPOINMENT @"prepayappointment"//获取保证金订单
#define API_PREPAYMENTOEDER @"prepaymentorder"   //订单,查看余额是否足够


#define API_getmemberproduct  @"getmemberproduct"//  // 1:充值会员，2:置顶,3:充值钱包,4:红娘推荐,5:约会保证金

#define API_GETORDERID            @"rechargememeservicebyapple" //获取订单号

#define API_CHECK_APPLE           @"changeordersuccessbyapple" //

#endif /* APiMarco_h */
