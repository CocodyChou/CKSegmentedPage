//
//  CKTitleContainerCell.h
//  CKSegmentedPage
//
//  Created by QiuHY on 16/7/16.
//  Copyright © 2016年 NSRocker. All rights reserved.
//

#import "CKContainerCell.h"

@interface CKTitleContainerCell : CKContainerCell

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleTextColor;
@property (nonatomic, strong) UIColor *titleSelectedTextColor;

@end
