#JRMenu#
###介绍 - introduce
####JRMenu 是一款简单的抽屉、侧边菜单效果，可设置所有抽屉控制器。通过左滑或右滑显示，可自定义设置左侧、右侧或左右同时显示。同时设置显示幅度，缩放比例等。<br/>JRMenu is a simple drawer, the side effect of the menu, you can set all the drawers controllers. By sliding left or right slide show, you can customize the settings on the left, right, or left and right simultaneously displayed. And set the display width, scaling and so on.

##效果演示 - show-how



##使用方法 - method
###代码块
####构造方法 initialization
```objc
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

```
####视图控制方法 View control method

```objc
/// 恢复位置
-(void)showMainView;

/// 显示左视图
-(void)showLeftView;

/// 显示右视图
-(void)showRighView;
```

####属性 attribute

```objc
/// 主视图隐藏后显示比例(0~1)
@property (nonatomic, assign) CGFloat otherScale;

/// 主视图比例 (0~1)
@property (nonatomic, assign) CGFloat mainScale;

/// 滑动速度系数-建议在0.5-1之间。默认为0.5
@property (assign,nonatomic) CGFloat speedf;

/// 是否允许点击视图恢复视图位置。默认为yes
@property (strong) UITapGestureRecognizer *sideslipTapGes;
```

##使用方法
#####AppDelegate.m
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	// 1. 创建window
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	// 2. 创建控制器
	MainController *main = [[MainController alloc] init];
	LeftController *left = [[LeftController alloc] init];
	RightController *right = [[RightController alloc] init];
	
	// 3. 创建跟控制器
	JRMenuController *controller = [[JRMenuController alloc] initWithLeftController:left andMainController:main andRightController:right];
	controller.mainScale = 0.8;
	controller.otherScale = 0.6;
	controller.speedf = 0.6;
	// 4. 设置跟控制器
	self.window.rootViewController = controller;
	
	// 5. 显示 window
	[self.window makeKeyAndVisible];
	
	return YES;
}
```
![(App01)](http://image.baidu.com/i?ct=503316480&z=0&tn=baiduimagedetail&ipn=d&word=%E5%9B%BE%E7%89%87&step_word=&pn=23&spn=0&di=86967533620&pi=&rn=1&is=0%2C0&istype=0&ie=utf-8&oe=utf-8&in=25&cl=2&lm=-1&st=undefined&cs=2053879721%2C1127347443&os=2068581640%2C1323630971&adpicid=0&ln=1000&fr=%2Cala&fmq=1434251087443_R&ic=undefined&s=undefined&se=1&sme=0&tab=0&width=&height=&face=undefined&ist=&jit=&cg=&bdtype=0&objurl=http%3A%2F%2Fpic.sucai.com%2Ftp%2Ffoto%2Fimg%2Fxpic1348.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bf7vwt_z%26e3Bv54AzdH3Fp7h7AzdH3Fkjt3tg2p7rtwgAzdH3Fdn8dcn_z%26e3Bip4s)
