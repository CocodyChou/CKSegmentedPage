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

typedef NS_ENUM(NSUInteger, CKSegmentedPageIndicatorWidthType) {
	CKSegmentedPageIndicatorWidthTypeFull,
	CKSegmentedPageIndicatorWidthTypeTextWidth,
};

@interface CKSegmentedPage : UIView <UIAppearanceContainer, UIAppearance>

@property (nonatomic, strong) UICollectionView *titleCollectionView;

@property (nonatomic, strong) UICollectionView *pageCollectionView;

@property (nonatomic, weak) id <CKSegmentedPageDelegate> pageDelegate;
@property (nonatomic, weak) id <CKSegmentedPageDataSource> pageDataSource;

@property (nonatomic, assign) NSInteger currentItem;

/*!
 *	0.01 ~ 0.99之间
 */
@property (nonatomic, assign) CGFloat titleHeightOfTotal UI_APPEARANCE_SELECTOR;

/*!
 *	@author Cike
 *
 *	@brief 设置之后，titleHeightOfTotal 不再起作用
 *
 *	@since 1.0
 */
@property (nonatomic, assign) CGFloat titleHeight UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat heightOfBottomIndicator UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleSelectedTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) NSInteger titleDefaultWidthOffset UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *bottomIndicatorColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CKSegmentedPageIndicatorWidthType indicatorWidthType UI_APPEARANCE_SELECTOR;

@end
