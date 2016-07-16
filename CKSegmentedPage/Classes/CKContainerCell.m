//
//  CKContainerCell.m
//  CKSegmentedPage
//
//  Created by 仇弘扬 on 2016/7/14.
//  Copyright © 2016年 NSRocker. All rights reserved.
//

#import "CKContainerCell.h"
#import <Masonry/Masonry.h>

@implementation CKContainerCell

- (void)prepareForReuse
{
	[super prepareForReuse];
	[self.displayView removeFromSuperview];
	self.displayView = nil;
}

- (void)setDisplayView:(UIView *)displayView
{
	if (!displayView) {
		return;
	}
	if (displayView.superview) {
		[displayView removeFromSuperview];
	}
	[self.contentView addSubview:displayView];
	_displayView = displayView;
	[self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
	if (_displayView) {
		__weak typeof(self) weakSelf = self;
		[_displayView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsZero);
		}];
	}
	[super updateConstraints];
}

@end
