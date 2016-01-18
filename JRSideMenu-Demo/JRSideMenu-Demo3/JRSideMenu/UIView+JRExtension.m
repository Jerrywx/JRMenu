//
//  UIView+JRExtension.m
//  JRSideMenu-Demo
//
//  Created by wxiao on 16/1/18.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import "UIView+JRExtension.h"

@implementation UIView (JRExtension)


@dynamic x;
@dynamic y;
@dynamic width;
@dynamic height;
@dynamic origin;
@dynamic size;

#pragma mark ---------------- Setters-----------------
-(void)setX:(CGFloat)x{
	CGRect r        = self.frame;
	r.origin.x      = x;
	self.frame      = r;
}

-(void)setY:(CGFloat)y{
	CGRect r        = self.frame;
	r.origin.y      = y;
	self.frame      = r;
}

-(void)setWidth:(CGFloat)width{
	CGRect r        = self.frame;
	r.size.width    = width;
	self.frame      = r;
}

-(void)setHeight:(CGFloat)height{
	CGRect r        = self.frame;
	r.size.height   = height;
	self.frame      = r;
}

-(void)setOrigin:(CGPoint)origin{
	self.x          = origin.x;
	self.y          = origin.y;
}

-(void)setSize:(CGSize)size{
	self.width      = size.width;
	self.height     = size.height;
}

-(void)setRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

-(void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

-(void)setCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}

-(void)setCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}

#pragma mark ---------------- Getters-----------------
-(CGFloat)x{
	return self.frame.origin.x;
}

-(CGFloat)y{
	return self.frame.origin.y;
}

-(CGFloat)width{
	return self.frame.size.width;
}

-(CGFloat)height{
	return self.frame.size.height;
}

-(CGPoint)origin{
	return CGPointMake(self.x, self.y);
}

-(CGSize)size{
	return CGSizeMake(self.width, self.height);
}

-(CGFloat)right {
	return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}

-(CGFloat)centerX {
	return self.center.x;
}

-(CGFloat)centerY {
	return self.center.y;
}

-(UIView *)lastSubviewOnX{
	if(self.subviews.count > 0){
		UIView *outView = self.subviews[0];
		
		for(UIView *v in self.subviews)
			if(v.x > outView.x)
				outView = v;
		
		return outView;
	}
	
	return nil;
}

-(UIView *)lastSubviewOnY{
	if(self.subviews.count > 0){
		UIView *outView = self.subviews[0];
		
		for(UIView *v in self.subviews)
			if(v.y > outView.y)
				outView = v;
		
		return outView;
	}
	
	return nil;
}

@end
