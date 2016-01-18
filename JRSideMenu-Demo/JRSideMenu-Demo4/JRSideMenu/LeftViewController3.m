//
//  LeftViewController.m
//  JRSideMenu-Demo
//
//  Created by wxiao on 16/1/17.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import "LeftViewController3.h"
#import "UIView+JRExtension.h"

@interface LeftViewController2 () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGFloat					speedf;					//滑动速度系数-建议在0.5-1之间。默认为0.5
@property (nonatomic, strong) UIViewController			*leftVC;				 //左侧窗控制器
@property (nonatomic, strong) UIViewController			*rightVC;				 //左侧窗控制器
@property (nonatomic, strong) UIViewController			*mainVC;
@property (nonatomic, strong) UIPanGestureRecognizer	*pan;

@property (nonatomic, assign) BOOL						closed;
@property (nonatomic, assign)  CGFloat					scalef;					//实时横向位移

@property (nonatomic, assign) BOOL						isLeft;
@property (nonatomic, assign) BOOL						isRigth;

@property (nonatomic, assign) JRControllerDirection		direction;				// 方向
@property (nonatomic, strong) UITapGestureRecognizer	*tapGesture;			//
@property (nonatomic, assign) CGFloat					otherScale;

@end

@implementation LeftViewController2

- (instancetype)initWithLeftView:(UIViewController *)leftVC
					 andMainView:(UIViewController *)mainVC {
	
	if(self = [super init]){
		
		self.view.backgroundColor = [UIColor whiteColor];
		
		// 0.
		self.speedf = 1.0;							// 滑动速度
		self.leftVC = leftVC;						// 左侧控制器
		self.mainVC = mainVC;						// 主控制器
		self.tapCloseAble = YES;					// 点击关闭
		self.mainPageScale = 0.8;					//
		
		// 1. 滑动手势
		self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
		[self.mainVC.view addGestureRecognizer:self.pan];
		self.pan.delegate			= self;
		self.leftVC.view.hidden		= YES;
		[self.view addSubview:self.leftVC.view];
		[self.view addSubview:self.mainVC.view];
		self.closed = YES;//初始时侧滑窗关闭
	}
	return self;
}

- (instancetype)initWithLeftView:(UIViewController *)leftVC
					 andMainView:(UIViewController *)mainVC
					andRightView:(UIViewController *)rightVC {
	
	if(self = [super init]){
		
		self.view.backgroundColor = [UIColor whiteColor];
		
		// 0.
		self.speedf		= 1.0;					// 滑动速度
		self.leftVC		= leftVC;				// 左侧控制器
		self.rightVC	= rightVC;
		self.mainVC		= mainVC;				// 主控制器
		self.mainPageScale = 0.8;
		
		self.tapCloseAble = YES;				// 点击关闭
		
		self.isLeft		= NO;
		self.isRigth	= NO;
		
		// 1. 滑动手势
		self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
		[self.mainVC.view addGestureRecognizer:self.pan];
		self.pan.delegate			= self;
		
		
		self.leftVC.view.hidden		= YES;
		[self.view addSubview:self.leftVC.view];
		self.rightVC.view.hidden	= YES;
		[self.view addSubview:self.rightVC.view];
		[self.view addSubview:self.mainVC.view];
		self.closed = YES;//初始时侧滑窗关闭
	}
	return self;
}

- (void)setMainPageScale:(CGFloat)mainPageScale {
	_mainPageScale = mainPageScale;
	self.otherScale = 1 - mainPageScale;
}

#pragma mark - 滑动手势
//滑动手势
- (void)handlePan:(UIPanGestureRecognizer *)rec{
	
	CGPoint point		 = [rec translationInView:self.view];					// 偏移位置
	_scalef				 = (point.x * self.speedf + _scalef);					// 横向偏移量

	if (rec.state == UIGestureRecognizerStateBegan) {
		if (point.x < 0) {
			self.direction = jrControllerDirectionLeft;
		} else if(point.x > 0) {
			self.direction = jrControllerDirectionRight;
		} else {
			self.direction = jrControllerDirectionNone;
		}
	} else if (rec.state == UIGestureRecognizerStateChanged) {
		
		if (self.direction == jrControllerDirectionNone) {
			if (point.x < 0) {
				self.direction = jrControllerDirectionLeft;
			} else if(point.x > 0) {
				self.direction = jrControllerDirectionRight;
			}
		}
		if (self.direction == jrControllerDirectionLeft) {

			if (self.isLeft == NO) {
				self.rightVC.view.hidden = NO;

				BOOL rightAble = YES;  //是否还需要跟随手指移动
				if (((self.mainVC.view.x >= 0) && (_scalef >= 0)) ) {
					//边界值管控
					_scalef = 0;
					rightAble = NO;
				}
				if (rightAble && (rec.view.frame.origin.x <= 0)) {
					CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;
					if (recCenterX > kScreenWidth * 0.5 - 2) {
						recCenterX = kScreenWidth * 0.5;
					}
					CGFloat recCenterY	= rec.view.center.y;
					rec.view.center		= CGPointMake(recCenterX,recCenterY);
					[rec setTranslation:CGPointMake(0, 0) inView:self.view];
				}
				
				CGFloat ff = (1 - self.mainPageScale) * (kScreenWidth * 0.5 - self.mainVC.view.center.x)/(kScreenWidth * 0.5);
				if (ff > 1 - self.mainPageScale) {
					ff = 1 - self.mainPageScale;
				}
				self.mainVC.view.transform	= CGAffineTransformScale(CGAffineTransformIdentity, 1 - ff, 1 - ff);
			} else if (self.isLeft == YES) {
				
				BOOL rightAble = YES;  //是否还需要跟随手指移动
				if (((self.mainVC.view.x <= 0) && (_scalef <= 0)) ) {
					//边界值管控
					_scalef = 0;
					rightAble = NO;
				}
				
				if (rightAble && (rec.view.frame.origin.x >= 0)) {
					CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;
					if (recCenterX < kScreenWidth * 0.5 - 2) {
						recCenterX = kScreenWidth * 0.5;
					}
				
//					CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;
					CGFloat recCenterY	= rec.view.center.y;
					rec.view.center		= CGPointMake(recCenterX,recCenterY);
					[rec setTranslation:CGPointMake(0, 0) inView:self.view];
					
					CGFloat ff = (self.mainVC.view.center.x - kScreenWidth * 0.5) / (kOpenLeftCenterX - kMainCenterX) * self.otherScale;
					if (ff < 0) {
						ff = 0;
					}
					self.mainVC.view.transform	= CGAffineTransformScale(CGAffineTransformIdentity, 1 - ff, 1 - ff);
					
				}
			}
			
		} else if (self.direction == jrControllerDirectionRight) {
			
			if (self.isRigth == NO) {
				self.leftVC.view.hidden = NO;
				BOOL rightAble = YES;  //是否还需要跟随手指移动
				if (((self.mainVC.view.x <= 0) && (_scalef <= 0)) ) {
					//边界值管控
					_scalef = 0;
					rightAble = NO;
				}
				if (rightAble && (rec.view.frame.origin.x >= 0)) {
					CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;
					if (recCenterX < kScreenWidth * 0.5 - 2) {
						recCenterX = kScreenWidth * 0.5;
					}
					CGFloat recCenterY	= rec.view.center.y;
					rec.view.center		= CGPointMake(recCenterX,recCenterY);
					[rec setTranslation:CGPointMake(0, 0) inView:self.view];
				}
				
				CGFloat ff = (self.mainVC.view.center.x - (kScreenWidth * 0.5)) / (kOpenLeftCenterX - kMainCenterX) * self.otherScale;
				
				if (ff > 1 - self.mainPageScale) {
					ff = 1 - self.mainPageScale;
				}
				self.mainVC.view.transform	= CGAffineTransformScale(CGAffineTransformIdentity, 1 - ff, 1 - ff);
				
			} else if(self.isRigth == YES) {
				
				BOOL rightAble = YES;  //是否还需要跟随手指移动
				if (((self.mainVC.view.x >= 0) && (_scalef >= 0)) ) {
					//边界值管控
					_scalef = 0;
					rightAble = NO;
				}
				if (rightAble && (rec.view.frame.origin.x <= 0)) {

					CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;
					if (recCenterX > kScreenWidth * 0.5 - 2) {
						recCenterX = kScreenWidth * 0.5;
					}
					CGFloat recCenterY	= rec.view.center.y;
					rec.view.center		= CGPointMake(recCenterX,recCenterY);
					[rec setTranslation:CGPointMake(0, 0) inView:self.view];
					
					CGFloat ff = (kMainCenterX - self.mainVC.view.center.x) / 270 * self.otherScale;
					
					if (ff < 0) {
						ff = 0;
					}
					self.mainVC.view.transform	= CGAffineTransformScale(CGAffineTransformIdentity, 1 - ff, 1 - ff);
				}
			}
		}
		
	} else if (rec.state == UIGestureRecognizerStateEnded) {
		if (self.direction == jrControllerDirectionRight) {
			if ((rec.view.center.x - kScreenWidth * 0.5) > 140) {
				[self openLeftView];
			} else {
				[self openMainView];
			}
		}
		if (self.direction == jrControllerDirectionLeft) {

			if ((rec.view.center.x - kScreenWidth * 0.5) < -140) {
				[self openRightView];
			} else {
				[self openMainView];
			}
		}
		_scalef = 0;
		self.direction = jrControllerDirectionNone;
	}
}

#pragma makr - 点击收拾
- (void)addTapAction {
	if (!self.tapCloseAble) return;
	
	if (self.tapGesture) {
		[self.mainVC.view removeGestureRecognizer:self.tapGesture];
		self.tapGesture = nil;
	}
	self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMainView)];
	[self.mainVC.view addGestureRecognizer:self.tapGesture];
}

- (void)removeTapAction {
	if (!self.tapCloseAble) return;
	if (self.tapGesture) {
		[self.mainVC.view removeGestureRecognizer:self.tapGesture];
		self.tapGesture = nil;
	}
}

#pragma mark - 修改视图位置
- (void)closeLeftView {
	[UIView animateWithDuration:0.2 animations:^{
		self.mainVC.view.transform	= CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
		self.mainVC.view.center		= CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
		self.closed					= YES;
	} completion:^(BOOL finished) {
		self.leftVC.view.hidden = YES;
		self.rightVC.view.hidden = YES;
	}];
}

- (void)openLeftView {
	self.isLeft = YES;
	[UIView animateWithDuration:0.2 animations:^{
		self.mainVC.view.transform	= CGAffineTransformScale(CGAffineTransformIdentity,self.mainPageScale,self.mainPageScale);
		self.mainVC.view.center		= kMainPageCenter;
		self.closed					= NO;
	} completion:^(BOOL finished) {
		[self addTapAction];
	}];
}

- (void)openMainView {
	self.isRigth = NO;
	self.isLeft = NO;
	[UIView animateWithDuration:0.2 animations:^{
		self.mainVC.view.transform	= CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
		self.mainVC.view.center		= CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
		self.closed					= YES;
	} completion:^(BOOL finished) {
		self.leftVC.view.hidden = YES;
		self.rightVC.view.hidden = YES;
		[self removeTapAction];
	}];
}

- (void)openRightView {
	self.isRigth = YES;
	[UIView animateWithDuration:0.2 animations:^{
		self.mainVC.view.transform	= CGAffineTransformScale(CGAffineTransformIdentity,self.mainPageScale,self.mainPageScale);
		self.mainVC.view.center		= kMainPageCenter2;
		self.closed					= NO;
	} completion:^(BOOL finished) {
		[self addTapAction];
	}];
}

#pragma mark - 行为收敛控制
- (void)disableTapButton {
	for (UIButton *tempButton in [_mainVC.view subviews]) {
		[tempButton setUserInteractionEnabled:NO];
	}
	//单击
//	if (!self.sideslipTapGes) {
//		//单击手势
//		self.sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
//		[self.sideslipTapGes setNumberOfTapsRequired:1];
//		
//		[self.mainVC.view addGestureRecognizer:self.sideslipTapGes];
//		self.sideslipTapGes.cancelsTouchesInView = YES;  //点击事件盖住其它响应事件,但盖不住Button;
//	}
}

//关闭行为收敛
- (void)removeSingleTap {
	for (UIButton *tempButton in [self.mainVC.view  subviews]) {
		[tempButton setUserInteractionEnabled:YES];
	}
//	[self.mainVC.view removeGestureRecognizer:self.sideslipTapGes];
//	self.sideslipTapGes = nil;
}

@end





















