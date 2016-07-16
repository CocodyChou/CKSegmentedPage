//
//  CKSegmentedPage.h
//  CKSegmentedPage
//
//  Created by 仇弘扬 on 2016/7/14.
//  Copyright © 2016年 NSRocker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKSegmentedPageDefine.h"

/*
 *	TODO List
 *
 *  放大字体 // delay
 *
 */

@class CKSegmentedPage;
@protocol CKSegmentedPageDelegate <NSObject>

@optional
- (void)segmentedPage:(CKSegmentedPage *)page didSelectTitleAtIndex:(NSInteger)index;

- (void)segmentedPage:(CKSegmentedPage *)page didSelectDisplayViewAtIndex:(NSInteger)index;

- (void)segmentedPage:(CKSegmentedPage *)page willShowDisplayViewAtIndex:(NSInteger)index;
- (void)segmentedPage:(CKSegmentedPage *)page didShowDisplayViewAtIndex:(NSInteger)index;

@end

@protocol CKSegmentedPageDataSource <NSObject>

- (NSInteger)numberOfPagesInSegmented:(CKSegmentedPage *)page;

- (NSString *)segmentedPage:(CKSegmentedPage *)page titleForPageAtIndex:(NSInteger)index;

/*!
 *	@author Cike
 *
 *	@brief Page 不会保持这个 view，所以为了避免每次创建，可能需要自己做保持。
 *
 *	@param page	当前的 segmented page
 *	@param index	页数
 *
 *	@return 要在这个page显示的view
 *
 */
- (UIView *)segmentedPage:(CKSegmentedPage *)page displayViewForPageAtIndex:(NSInteger)index;

@optional
/*!
 *	@author Cike
 *
 *	@brief Title的宽度，整型数整型数整型数！！！
 *
 */
- (NSInteger)segmentedPage:(CKSegmentedPage *)page widthForTitleAtIndex:(NSInteger)index;

@end

@interface CKSegmentedPage : UIView

@property (nonatomic, strong) UICollectionView *titleCollectionView;

@property (nonatomic, strong) UICollectionView *pageCollectionView;

@property (nonatomic, weak) id <CKSegmentedPageDelegate> pageDelegate;
@property (nonatomic, weak) id <CKSegmentedPageDataSource> pageDataSource;

/*!
 *	0.01 ~ 0.99之间
 */
@property (nonatomic, assign) CGFloat titleHeightOfTotal;

@property (nonatomic, assign) CGFloat heightOfBottomIndicator;

@end
