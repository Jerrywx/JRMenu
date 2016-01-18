//
//  LeftViewController.h
//  JRSideMenu-Demo
//
//  Created by wxiao on 16/1/17.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kScreenSize           [[UIScreen mainScreen] bounds].size
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height

#define kMainPageDistance   100   //打开左侧窗时，中视图(右视图)露出的宽度
#define kMainPageScale		0.8  //打开左侧窗时，中视图(右视图）缩放比例
#define kOpenLeftCenterX	(kScreenWidth + kScreenWidth * kMainPageScale / 2.0 - kMainPageDistance)
#define kMainCenterX		([[UIScreen mainScreen] bounds].size.width * 0.5)
#define kMainPageCenter  CGPointMake(kScreenWidth + kScreenWidth * kMainPageScale / 2.0 - kMainPageDistance, kScreenHeight / 2)  //打开左侧窗时，中视图中心点

#define kMainPageCenter2  CGPointMake(-kScreenWidth * kMainPageScale / 2.0 + kMainPageDistance, kScreenHeight / 2)  //打开左侧窗时，中视图中心点

#define vCouldChangeDeckStateDistance  (kScreenWidth - kMainPageDistance) / 2.0 - 40 //滑动距离大于此数时，状态改变（关--》开，或者开--》关）
#define vSpeedFloat		1.0		//滑动速度
#define kLeftAlpha		0.9		//左侧蒙版的最大值
#define kLeftCenterX	30		//左侧初始偏移量
#define kLeftScale		0.7		//左侧初始缩放比例
#define vDeckCanNotPanViewTag    987654   // 不响应此侧滑的View的tag

// 滑动方向
typedef NS_ENUM(NSInteger, JRControllerDirection) {
	jrControllerDirectionNone,
	jrControllerDirectionUp,
	jrControllerDirectionDown,
	jrControllerDirectionRight,
	jrControllerDirectionLeft,
};

@interface LeftViewController2 : UIViewController

/**
 *  是否可以点击mainVC 关闭侧滑栏  默认: YES;
 */
@property (nonatomic, assign) BOOL tapCloseAble;

/**
 *  主视图缩放
 */
@property (nonatomic, assign) CGFloat mainPageScale;


- (instancetype)initWithLeftView:(UIViewController *)leftVC
					 andMainView:(UIViewController *)mainVC;

- (instancetype)initWithLeftView:(UIViewController *)leftVC
					 andMainView:(UIViewController *)mainVC
					andRightView:(UIViewController *)rightVC;

@end
