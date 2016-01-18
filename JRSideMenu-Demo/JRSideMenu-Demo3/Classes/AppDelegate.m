//
//  AppDelegate.m
//  JRSideMenu-Demo
//
//  Created by wxiao on 16/1/18.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "LeftController.h"
#import "RightController.h"
#import "LeftViewController3.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	// 1. 创建window
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	// 2. 创建控制器
	MainController *main	= [[MainController alloc] init];
	LeftController *left	= [[LeftController alloc] init];
	RightController *right	= [[RightController alloc] init];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main];
	// 3. 创建跟控制器
	LeftViewController2 *controller = [[LeftViewController2 alloc] initWithLeftView:left andMainView:nav andRightView:right];
	controller.tapCloseAble = YES;								// 是否可以点击关闭侧滑栏 默认 YES
	controller.mainPageScale = 1.0;

	// 4. 设置跟控制器
	self.window.rootViewController = controller;
	// 5. 显示 window
	[self.window makeKeyAndVisible];
	
	return YES;
}


@end


























