//
//  CDVBrigePlugin.m
//  SellerMissionManage
//
//  Created by zt on 14-10-14.
//
//

#import "MyPlugin.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "WCAlertView.h"
#import "H5ChatItemVo.h"
#import "AppDelegate.h"
#import "MBProgressHUD+Add.h"
#import "ChatVCHelper.h"
#import "DafengCheDBManager.h"

@interface MyPlugin()<ChatViewControllerDelegate>{
}
@end

@implementation MyPlugin

- (void)pushid:(CDVInvokedUrlCommand *)command{
    [self nativeCall:command];
}

- (void)nitvieFunctionCall:(CDVInvokedUrlCommand *)command{
    [self nativeCall:command];
}

- (void)nitvieCall:(CDVInvokedUrlCommand *)command{
    [self nativeCall:command];
}
// 所有js调用本地的入口
- (void)nativeCall:(CDVInvokedUrlCommand *)command{
    CDVPluginResult* pluginResult = nil;
    NSString* functionName = [command.arguments objectAtIndex:0];  //调用方法的名称
    NSString *parameter;
    if (command.arguments.count >= 2) {
        parameter = [command.arguments objectAtIndex:1];  //获取js文件传过来的值，参数
    }
    
    if (functionName != nil && [functionName length] > 0) {
        if([@"closeSCWebViewController" isEqualToString:functionName] || [@"closeWebView" isEqualToString:functionName]){
            [self closeSCWebViewController];
        }else if([@"loadChatList" isEqualToString:functionName]){
            [self showChatVC:parameter];
        }else if ([@"logout" isEqualToString:functionName]){
            [self logout];
        }
        NSString *pushid = @"b";//[UserDefaults objectForKey:@"jpushid"];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:pushid];        //成功回调
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]; //失败回调
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - 私有方面
- (UIWebView*)h5WebView{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return  delegate.viewController.webView;
}

#pragma mark - 插件方法
// 跳转到聊天界面
- (void)showChatVC:(NSString*)userid{
    [[ChatVCHelper sharedHelper] loadChatList];
    
    [MBProgressHUD showHUDAddedTo:MAIN_WINDOW animated:YES];
    
    // 先从本地数据库去用户信息
    H5ChatItemVo *vo = [[DafengCheDBManager sharedManager] queryUserInfoWithUserid:userid];
    if (vo != nil) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *chatter = vo.from;
        if ([[ChatVCHelper sharedHelper] isSalerWithHuanXinId:vo.from]) {
            chatter = vo.to;
        }
        ChatViewController *chatVC = [[ChatViewController alloc] initWithUserId:userid chatter:vo.from];
        chatVC.delegate = self;
        [app.viewController.navigationController pushViewController:chatVC animated:YES];
        [MBProgressHUD hideAllHUDsForView:MAIN_WINDOW animated:YES];
    }else{
        [SCHttpManager getHuanXinWithUserId:userid isSaler:NO success:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:MAIN_WINDOW animated:YES];
            // 跳转到聊天界面
            NSString *hxId = DicValueForKey(obj, nil, @"huanxinId");
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            ChatViewController *chatVC = [[ChatViewController alloc] initWithUserId:userid chatter:hxId];
            chatVC.delegate = self;
            [app.viewController.navigationController pushViewController:chatVC animated:YES];
        } fail:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:MAIN_WINDOW animated:YES];
        }];
    }
}

// 用户退出
- (void)logout{
    EMError *error;
    [[[EaseMob sharedInstance] chatManager] logoffWithError:&error];
    if (error) {
        SCLogF(@"环信注销错误:%@",error);
    }else{
        [[ChatVCHelper sharedHelper] resetDefaults];
    }
}

#pragma mark - ChatViewControllerDelegate
- (void)chatViewControllerDidClickBackButton:(id)chatVC{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - webviewController 关闭
- (void)closeSCWebViewController{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSCWebViewController" object:nil];
}
@end

