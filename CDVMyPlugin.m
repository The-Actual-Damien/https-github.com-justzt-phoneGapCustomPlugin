//
//  CDVBrigePlugin.m
//  SellerMissionManage
//
//  Created by zt on 14-10-14.
//
//

#import "CDVMyPlugin.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "WCAlertView.h"

@interface CDVMyPlugin()<ChatViewControllerDelegate>{
}
@end

@implementation CDVMyPlugin

- (void)pushid:(CDVInvokedUrlCommand *)command{
    CDVPluginResult* pluginResult = nil;
    NSString* chatter = [command.arguments objectAtIndex:0];  //获取js文件传过来的值，参数
    
    NSString *functionName = [command.arguments objectAtIndex:1];  //调用方法的名称
    
    if (chatter != nil && [chatter length] > 0) {
        if([@"login" isEqualToString:functionName]){
            [self login:chatter];
        }else{
            [self showChatVC:chatter];
        }
        NSString *pushid = @"b";//[UserDefaults objectForKey:@"jpushid"];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:pushid];        //成功回调
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]; //失败回调
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

// to chat vc
- (void)showChatVC:(NSString*)chatter{
    // 跳转到聊天界面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:chatter isGroup:NO];
    chatVC.delegate = self;
    [app.viewController.navigationController pushViewController:chatVC animated:YES];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chatVC];
//    [app.viewController presentViewController:nav animated:YES completion:^{}];
}

// login
- (void)login:(NSString*)account{
    NSString *acc = account;
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:acc
                                                        password:@"111111"
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         NSString *message;
         if (error) {
             message = [NSString stringWithFormat:@"登录失败：%@",error];
         }else {
             message = [NSString stringWithFormat:@"登录成功:%@",acc];
         }
         
        [WCAlertView showAlertWithTitle:nil message:message customizationBlock:^(WCAlertView *alertView) {
              
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
              
        } cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
     } onQueue:nil];
}

#pragma mark - ChatViewControllerDelegate
- (void)chatViewControllerDidClickBackButton:(id)chatVC{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.viewController dismissViewControllerAnimated:YES completion:nil];
}
@end

