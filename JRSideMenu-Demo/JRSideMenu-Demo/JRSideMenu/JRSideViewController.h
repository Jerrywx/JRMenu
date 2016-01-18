//
//  JRSideViewController.h
//  JRSideMenu-Demo
//
//  Created by wxiao on 16/1/17.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRSideViewController : UIViewController

- (instancetype)initWithLeftVC:(UIViewController *)leftVC
					   rightVC:(UIViewController *)rightVC
					 andMainVC:(UIViewController *)mainVC;

@end
