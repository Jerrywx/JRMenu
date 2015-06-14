#JRMenu#
##介绍##
###JRMenu 是一款简单的抽屉、侧边菜单效果，可设置所有抽屉控制器。通过左滑或右滑显示，可自定义设置左侧、右侧或左右同时显示。同时设置显示幅度，缩放比例等。<br/>JRMenu is a simple drawer, the side effect of the menu, you can set all the drawers controllers. By sliding left or right slide show, you can customize the settings on the left, right, or left and right simultaneously displayed. And set the display width, scaling and so on.###
##使用方法##
###代码块
`/// 构造方法(左控制器 & 右控制器 & 背景图片) <br/>-(instancetype)initWithLeftController:(UIViewController *)leftController	
andMainController:(UIViewController *)mainController	
andRightController:(UIViewController *)rightController	
andBackgroundImage:(UIImage *)image;
/// 构造方法(左控制器 & 右控制器)	
-(instancetype)initWithLeftController:(UIViewController *)leftController	
andMainController:(UIViewController *)mainController	
andRightController:(UIViewController *)rightController;	
/// 构造方法(左控制器 & 右控制器)	
-(instancetype)initWithLeftController:(UIViewController *)leftController andMainView:(UIViewController *)mainController;	/// 构造方法(右控制器)	
-(instancetype)initWithRightView:(UIViewController *)rightController andMainView:(UIViewController *)mainController;`
