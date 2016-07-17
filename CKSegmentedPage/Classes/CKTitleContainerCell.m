//
//  CKTitleContainerCell.m
//  CKSegmentedPage
//
//  Created by QiuHY on 16/7/16.
//  Copyright © 2016年 NSRocker. All rights reserved.
//

#import "CKTitleContainerCell.h"
#import "CKSegmentedPage.h"

@interface CKTitleContainerCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation CKTitleContainerCell

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    if (!_title) {
        return;
    }
    self.label.text = title;
    self.displayView = self.label;
}

- (UILabel *)label
{
    if (!_label) {
        UILabel *label = [UILabel new];
        label.font = [CKSegmentedPage appearance].titleFont;
		label.textColor = [CKSegmentedPage appearance].titleTextColor;
		label.highlightedTextColor = [CKSegmentedPage appearance].titleSelectedTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _label = label;
    }
    return _label;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
