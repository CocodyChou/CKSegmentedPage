//
//  CKSegmentedPageItem.h
//  CKSegmentedPage
//
//  Created by 仇弘扬 on 2016/7/15.
//  Copyright © 2016年 NSRocker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CKSegmentedPageItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIView *displayView;

/*!
 *	@author Cike
 *
 *	@brief 默认为 title 宽度 + 16
 *
 */
@property (nonatomic, assign) CGFloat titleWidth;

/*!
 *	@author Cike
 *
 *	@brief 没有实现哈。
 *
 */
@property (nonatomic, strong) UIView *titleView;

@end
