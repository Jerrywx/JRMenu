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
