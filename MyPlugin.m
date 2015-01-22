//
//  CDVBrigePlugin.m
//  SellerMissionManage
//
//  Created by zt on 14-10-14.
//
//

#import "MyPlugin.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface MyPlugin(){
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
        if([@"showVC" isEqualToString:functionName] || [@"closeWebView" isEqualToString:functionName]){
            [self showVC];
        }
        NSString *pushid = @"b";//[UserDefaults objectForKey:@"jpushid"];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:pushid];        //成功回调
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]; //失败回调
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (UINavigationController*)navigationController{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return app.viewController.navigationController;
}

- (MainViewController*)mainViewController{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return (MainViewController*)app.viewController;
}

#pragma mark 
- (void)showVC{
    
}
@end

