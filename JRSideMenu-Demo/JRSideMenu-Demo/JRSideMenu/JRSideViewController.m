//
//  JRSideViewController.m
//  JRSideMenu-Demo
//
//  Created by wxiao on 16/1/17.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import "JRSideViewController.h"
#import "UIView+JRExtension.h"

CGFloat const gestureMinimumTranslation = 15.0 ;
// 滑动方向
typedef NS_ENUM(NSInteger, JRControllerDirection) {
	jrControllerDirectionNone,
	jrControllerDirectionUp,
	jrControllerDirectionDown,
	jrControllerDirectionRight,
	jrControllerDirectionLeft,
};

#define kScreenSize           [[UIScreen mainScreen] bounds].size
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height
#define kMainPageDistance	  100   //打开左侧窗时，中视图(右视图)露出的宽度

#define kMainPageDistance   100   //打开左侧窗时，中视图(右视图)露出的宽度
#define kMainPageScale		0.8  //打开左侧窗时，中视图(右视图）缩放比例
#define kMainPageCenter  CGPointMake(kScreenWidth + kScreenWidth * kMainPageScale / 2.0 - kMainPageDistance, kScreenHeight / 2)

#define vCouldChangeDeckStateDistance  (kScreenWidth - kMainPageDistance) / 2.0 - 40 //滑动距离大于此数时，状态改变（关--》开，或者开--》关）
#define vSpeedFloat		1.0		//滑动速度
#define kLeftAlpha		0.9		//左侧蒙版的最大值
#define kLeftCenterX	30		//左侧初始偏移量
#define kLeftScale		0.7		//左侧初始缩放比例

@interface JRSideViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIViewController		*leftVC;
@property (nonatomic, strong) UIViewController		*rightVC;
@property (nonatomic, strong) UIViewController		*mainVC;

@property (nonatomic, assign) CGFloat				speedf;					//滑动速度系数-建议在0.5-1之间。默认为0.5
@property (nonatomic, assign) CGFloat				scalef;					//实时横向位移

@property (nonatomic, assign) BOOL					closed;
@property (nonatomic, assign) JRControllerDirection direction;

/// 主视图比例 (0~1)
@property (nonatomic, assign) CGFloat mainScale;
/// 主视图隐藏后显示比例(0~1)
@property (nonatomic, assign) CGFloat otherScale;

@end

@implementation JRSideViewController

- (instancetype)initWithLeftVC:(UIViewController *)leftVC
					   rightVC:(UIViewController *)rightVC
					 andMainVC:(UIViewController *)mainVC {

	if (self = [super init]) {
		self.leftVC		= leftVC;
		self.rightVC	= rightVC;
		self.mainVC		= mainVC;
		self.speedf		= 1.0;
		self.mainScale	= 1.0;
		self.otherScale = 0.5;
		
		[self.view addSubview:self.leftVC.view];
		[self.view addSubview:self.rightVC.view];
		[self.view addSubview:self.mainVC.view];
		
		if (self.leftVC  != nil)	[self addChildViewController:self.leftVC];
		if (self.rightVC != nil)	[self addChildViewController:self.rightVC];
		if (self.mainVC  != nil)	[self addChildViewController:self.mainVC];
		
		self.leftVC.view.hidden		= YES;
		self.rightVC.view.hidden	= YES;
		
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
																			  action:@selector(handlePan:)];
		[pan setCancelsTouchesInView:YES];
		pan.delegate = self;
		[self.mainVC.view addGestureRecognizer:pan];		// add to nav
		
		UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
		[tap setNumberOfTapsRequired:1];
		tap.delaysTouchesBegan = NO;
		tap.delaysTouchesEnded = NO;
		[self.mainVC.view addGestureRecognizer:tap];
		
		self.closed = YES;//初始时侧滑窗关闭
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
	
//	NSLog(@"=================== %@", NSStringFromCGRect(gesture.view.frame));
//	NSLog(@"----------------------------------- %f", [gesture translationInView:self.view].x);
	
	CGPoint point		 = [gesture translationInView:self.view];					// 偏移位置
	
	if (gesture.state == UIGestureRecognizerStateBegan) {

		self.direction = jrControllerDirectionNone;
		
		if (gesture.view.frame.origin.x == 0) {
			if ([gesture velocityInView:self.view].x < 0) {
				self.leftVC.view.hidden		= YES;
				self.rightVC.view.hidden	= NO;
			} else if ([gesture velocityInView:self.view].x > 0) {
				self.leftVC.view.hidden		= NO;
				self.rightVC.view.hidden	= YES;
			}
		}
	} else if (gesture.state == UIGestureRecognizerStateChanged && self.direction == jrControllerDirectionNone) {
		// 获取 方向
		self.direction = [ self determineCameraDirectionIfNeeded:point];
	} else if (self.direction == jrControllerDirectionRight && self.leftVC != nil) {
		
		self.scalef				 = (point.x * self.speedf + self.scalef);					// 横向偏移量
		NSLog(@"==========2 %f - %f - %f, %f", point.x * self.speedf, point.x, self.speedf, self.scalef);
		
		BOOL needMoveWithTap = YES;  //是否还需要跟随手指移动
		if (((self.mainVC.view.x <= 0) && (_scalef <= 0)) || ((self.mainVC.view.x >= (kScreenWidth - kMainPageDistance ))
															  && (_scalef >= 0))) {
			
			//边界值管控
			_scalef = 0;
			needMoveWithTap = NO;
		}
		if (needMoveWithTap) {
			[self handlePanToSide:gesture];
		}
	} else if (self.direction == jrControllerDirectionLeft && self.rightVC != nil) {
		self.scalef				 = (point.x * self.speedf + self.scalef);					// 横向偏移量
		NSLog(@"==========3 %f - %f - %f, %f", point.x * self.speedf, point.x, self.speedf, self.scalef);
		
		BOOL needMoveWithTap = YES;  //是否还需要跟随手指移动
		if (((self.mainVC.view.x >= 0) && (_scalef >= 0)) || ((self.mainVC.view.x <= (kScreenWidth - kMainPageDistance ))
															  && (_scalef >= 0))) {
			NSLog(@"sadasdasd");
			//边界值管控
			_scalef = 0;
			needMoveWithTap = NO;
		}
		if (needMoveWithTap) {
			[self handlePanToSide:gesture];
		}
	}
	
	if (gesture.state == UIGestureRecognizerStateEnded) {
		
		NSLog(@"===========================");
		CGFloat x = self.mainVC.view.frame.origin.x;
		if (x > 140 * self.speedf && self.leftVC != nil){
			
			[self showLeftView];
		}
		else if (x < -140 * self.speedf  && self.rightVC != nil) {
			
			[self showRighView];
		} else {
			[self showMainView];
			self.scalef = 0;
		}
		
		//		if (self.scalef > 140 * self.speedf && self.leftVC != nil){
		//
		//			[self showLeftView];
		//		}
		//		else if (self.scalef < -140 * self.speedf  && self.rightVC != nil) {
		//
		//			[self showRighView];
		//		} else {
		//			[self showMainView];
		//			self.scalef = 0;
		//		}
	}
}

#pragma mark - 滑动手势
// 滑动手势
- (void)handlePanToSide:(UIPanGestureRecognizer *)rec{
	
	CGPoint point = [rec translationInView:self.view];
//	self.scalef = (point.x * self.speedf + self.scalef);
	
	//根据视图位置判断是左滑还是右边滑动
	if (rec.view.frame.origin.x >= 0){

		CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;

		CGFloat recCenterY	= rec.view.center.y;
		rec.view.center		= CGPointMake(recCenterX,recCenterY);
		//scale 1.0~kMainPageScale
		CGFloat scale		= 1 - (1 - kMainPageScale) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
		rec.view.transform	= CGAffineTransformScale(CGAffineTransformIdentity,scale, 1.0);
		[rec setTranslation:CGPointMake(0, 0) inView:self.view];
		
	} else {
		
		CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;
		CGFloat recCenterY	= rec.view.center.y;
		rec.view.center		= CGPointMake(recCenterX, recCenterY);
		[rec setTranslation:CGPointMake(0, 0) inView:self.view];
	}
	//手势结束后修正位置
	if (rec.state == UIGestureRecognizerStateEnded) {
		
		NSLog(@"===========================");
		CGFloat x = self.mainVC.view.frame.origin.x;
		if (x > 140 * self.speedf && self.leftVC != nil){
			
			[self showLeftView];
		}
		else if (x < -140 * self.speedf  && self.rightVC != nil) {
			
			[self showRighView];
		} else {
			[self showMainView];
			self.scalef = 0;
		}
		
//		if (self.scalef > 140 * self.speedf && self.leftVC != nil){
//			
//			[self showLeftView];
//		}
//		else if (self.scalef < -140 * self.speedf  && self.rightVC != nil) {
//			
//			[self showRighView];
//		} else {
//			[self showMainView];
//			self.scalef = 0;
//		}
	}
}

- (JRControllerDirection)determineCameraDirectionIfNeeded:(CGPoint)translation {
	if (self.direction != jrControllerDirectionNone)
		return self.direction;
	
	if (fabs(translation.x) > gestureMinimumTranslation) {
		BOOL gestureHorizontal = NO;
		if (translation.y == 0.0 )
			gestureHorizontal = YES;
		else
			gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
		if (gestureHorizontal) {
			if (translation.x > 0.0 )
				return jrControllerDirectionRight;
			else
				return jrControllerDirectionLeft;
		}
	} else if (fabs(translation.y) > gestureMinimumTranslation) {
		BOOL gestureVertical = NO;
		if (translation.x == 0.0 )
			gestureVertical = YES;
		else
			gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
		if (gestureVertical) {
			if (translation.y > 0.0 )
				return jrControllerDirectionDown;
			else
				return jrControllerDirectionUp;
		}
	}
	return self.direction;
}

#pragma mark - 修改视图位置
- (void)closeLeftView {
	
	[UIView beginAnimations:nil context:nil];
	self.mainVC.view.transform	= CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
	self.mainVC.view.center		= CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
	self.closed					= YES;
	
	self.leftVC.view.center	 = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
	self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,1.0);
//	self.contentView.alpha		 = kLeftAlpha;
	
	[UIView commitAnimations];
//	[self removeSingleTap];
}

- (void)openLeftView {
	[UIView beginAnimations:nil context:nil];
	self.mainVC.view.transform	= CGAffineTransformScale(CGAffineTransformIdentity,kMainPageScale,1.0);
	self.mainVC.view.center		= kMainPageCenter;
	self.closed					= NO;
	
	self.leftVC.view.center	 = CGPointMake((kScreenWidth - kMainPageDistance) * 0.5, kScreenHeight * 0.5);
	self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
//	self.contentView.alpha		 = 0;
	
	[UIView commitAnimations];
//	[self disableTapButton];
}

#pragma mark - 修改视图位置
// 恢复位置
-(void)showMainView{
	[UIView beginAnimations:nil context:nil];
	self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
	self.mainVC.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,([UIScreen mainScreen].bounds.size.height)/2);
	[UIView commitAnimations];
}

// 显示左视图
-(void)showLeftView{
	
	[UIView beginAnimations:nil context:nil];
	self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.mainScale, self.mainScale);
	CGFloat with = [UIScreen mainScreen].bounds.size.width * 0.5;
	self.mainVC.view.center = CGPointMake(with  + (with  * self.otherScale*2), ([UIScreen mainScreen].bounds.size.height)/2);
	
	[UIView commitAnimations];
}

// 显示右视图
-(void)showRighView{
	[UIView beginAnimations:nil context:nil];
	
	self.rightVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.mainScale, self.mainScale);
	CGFloat with = [UIScreen mainScreen].bounds.size.width * 0.5;
	self.mainVC.view.center = CGPointMake(with - (with  * self.otherScale * 2),([UIScreen mainScreen].bounds.size.height)/2);
	
	[UIView commitAnimations];
}

- (void)handleTap:(UIPanGestureRecognizer *)gesture {
	NSLog(@"========");
}

#pragma mark -

#pragma mark - Private Methond
- (CGFloat)screenWidth {
	static CGFloat screenWidth = 0.0;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		screenWidth = [UIScreen mainScreen].bounds.size.width;
	});
	return screenWidth;
}

- (CGFloat)screnHeight {
	static CGFloat screenHeight = 0.0;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		screenHeight = [UIScreen mainScreen].bounds.size.height;
	});
	return screenHeight;
}

@end








