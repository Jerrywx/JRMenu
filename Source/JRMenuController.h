//
//  JRMenuController.h
//  JRMenuController
//
//  Created by Jerry on 15/6/12.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRMenuController : UIViewController

/// 主视图隐藏后显示比例(0~1)
@property (nonatomic, assign) CGFloat otherScale;

/// 主视图比例 (0~1)
@property (nonatomic, assign) CGFloat mainScale;

/// 滑动速度系数-建议在0.5-1之间。默认为0.5
@property (assign,nonatomic) CGFloat speedf;

/// 是否允许点击视图恢复视图位置。默认为yes
@property (strong) UITapGestureRecognizer *sideslipTapGes;


#pragma mark - initialization
/// 构造方法(左控制器 & 右控制器 & 背景图片)
-(instancetype)initWithLeftController:(UIViewController *)leftController
					andMainController:(UIViewController *)mainController
				   andRightController:(UIViewController *)rightController
				   andBackgroundImage:(UIImage *)image;

/// 构造方法(左控制器 & 右控制器)
-(instancetype)initWithLeftController:(UIViewController *)leftController
					andMainController:(UIViewController *)mainController
				   andRightController:(UIViewController *)rightController;

/// 构造方法(左控制器 & 右控制器)
-(instancetype)initWithLeftController:(UIViewController *)leftController andMainView:(UIViewController *)mainController;

/// 构造方法(右控制器)
-(instancetype)initWithRightView:(UIViewController *)rightController andMainView:(UIViewController *)mainController;

#pragma mark -
/// 恢复位置
-(void)showMainView;

/// 显示左视图
-(void)showLeftView;

/// 显示右视图
-(void)showRighView;


@end
