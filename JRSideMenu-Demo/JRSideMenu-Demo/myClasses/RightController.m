//
//  RightController.m
//  窗口视图
//
//  Created by Jerry on 15/6/12.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "RightController.h"

@implementation RightController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blueColor];

}

// cell 行 设置
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//	
//	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//		[cell setSeparatorInset: UIEdgeInsetsZero];
//	}
//	
//	if ([cell respondsToSelector:@selector(setLayoutManager:)]) {
//		[cell setLayoutMargins:UIEdgeInsetsZero];
//	}
//}
//
//- (void)viewDidLayoutSubviews {
//	
//	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//		 [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
//	}
//	
//	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//		[self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
//	}
//	
//}


@end
