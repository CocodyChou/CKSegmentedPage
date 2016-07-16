//
//  CKSegmentedPage.m
//  CKSegmentedPage
//
//  Created by 仇弘扬 on 2016/7/1self.heightOfBottomIndicator.
//  Copyright © 2016年 NSRocker. All rights reserved.
//

#import "CKSegmentedPage.h"
#import "CKContainerCell.h"
#import "CKTitleContainerCell.h"
#import "Masonry.h"

@interface CKSegmentedPage () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger currentItem;
@property (nonatomic, assign) NSInteger lastItem;
@property (nonatomic, assign) NSInteger targetItem;

@property (nonatomic, strong) UIView *bottomIndicatorOfTitle;

@end

@implementation CKSegmentedPage

- (void)commonInit
{
    UICollectionViewFlowLayout *l = [UICollectionViewFlowLayout new];
    l.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    l.minimumLineSpacing = 0;
    l.minimumInteritemSpacing = 0;
    self.titleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:l];
    [self.titleCollectionView registerClass:[CKTitleContainerCell class] forCellWithReuseIdentifier:@"CKContainerCellTitle"];
    self.titleCollectionView.delegate = self;
    self.titleCollectionView.dataSource = self;
    self.titleCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.titleCollectionView];
    
    UICollectionViewFlowLayout *t = [UICollectionViewFlowLayout new];
    t.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    t.minimumLineSpacing = 0;
    t.minimumInteritemSpacing = 0;
    self.pageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:t];
    [self.pageCollectionView registerClass:[CKContainerCell class] forCellWithReuseIdentifier:@"CKContainerCellPage"];
    self.pageCollectionView.delegate = self;
    self.pageCollectionView.dataSource = self;
    self.pageCollectionView.showsHorizontalScrollIndicator = NO;
    self.pageCollectionView.pagingEnabled = YES;
    self.pageCollectionView.allowsSelection = NO;
    [self addSubview:self.pageCollectionView];
    
    self.titleCollectionView.backgroundColor = [UIColor redColor];
    self.pageCollectionView.backgroundColor = [UIColor orangeColor];
    
    self.targetItem = -1;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self numberOfPagesInSegmented] > 0) {
                [self.titleCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                if ([self.pageDelegate respondsToSelector:@selector(segmentedPage:didShowDisplayViewAtIndex:)]) {
                    [self.pageDelegate segmentedPage:self didShowDisplayViewAtIndex:self.currentItem];
                }
                self.bottomIndicatorOfTitle.frame = CGRectMake(0, [self titleHeight] - self.heightOfBottomIndicator, [self titleWidthAtIndex:0], self.heightOfBottomIndicator);
            }
        });
    }
}

- (void)setTitleHeightOfTotal:(CGFloat)titleHeightOfTotal
{
    NSParameterAssert(titleHeightOfTotal >= 0.01f && titleHeightOfTotal <= 0.99f);
    _titleHeightOfTotal = titleHeightOfTotal;
    [self setNeedsUpdateConstraints];
}

- (CGFloat)titleHeight
{
    return ceil(self.titleHeightOfTotal * CGRectGetHeight(self.frame));
}

- (void)updateConstraints
{
    [self layoutCollectionViews];
    
    [super updateConstraints];
}

- (void)layoutCollectionViews
{
    NSAssert(!(self.titleHeightOfTotal < 0 || self.titleHeightOfTotal > 1), @"比例不正确");
    NSAssert([self.titleCollectionView.superview isEqual:self], @"titleCollectionView 不是自己的子视图");
    NSAssert([self.pageCollectionView.superview isEqual:self], @"pageCollectionView 不是自己的子视图");
    
    __weak typeof(self) weakSelf = self;
    [self.titleCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).with.offset(0);
        make.left.equalTo(weakSelf.mas_left).with.offset(0);
        make.right.equalTo(weakSelf.mas_right).with.offset(0);
        make.height.equalTo(weakSelf.mas_height).with.multipliedBy(weakSelf.titleHeightOfTotal);
    }];
    
    [self.pageCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleCollectionView.mas_bottom).with.offset(0);
        make.left.equalTo(weakSelf.mas_left).with.offset(0);
        make.right.equalTo(weakSelf.mas_right).with.offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(0);
    }];
}

#pragma mark - data srouces methoed
- (NSInteger)numberOfPagesInSegmented
{
    NSAssert([self.pageDataSource respondsToSelector:@selector(numberOfPagesInSegmented:)], @"必须要实现这个方法，返回页数");
    return [self.pageDataSource numberOfPagesInSegmented:self];
}

- (NSString *)titleAtIndex:(NSInteger)index
{
    NSAssert([self.pageDataSource respondsToSelector:@selector(segmentedPage:titleForPageAtIndex:)], @"必须要实现这个方法，返回当前页 title");
    NSString *title = [self.pageDataSource segmentedPage:self titleForPageAtIndex:index];
    return title;
}

- (NSInteger)titleWidthAtIndex:(NSInteger)index
{
    NSString *title = [self titleAtIndex:index];
    NSInteger width = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, [self titleHeight]) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : CKSegmentedPageTitleFont} context:nil].size.width + CKSegmentedPageTitleDefaultWidthOffset;
    return width;
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!self.pageDataSource) {
        return 0;
    }
    return [self numberOfPagesInSegmented];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = nil;
    if ([collectionView isEqual:self.titleCollectionView])
    {
        identifier = @"CKContainerCellTitle";
    }
    else
    {
        identifier = @"CKContainerCellPage";
    }
    CKContainerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if ([collectionView isEqual:self.titleCollectionView])
    {
        CKTitleContainerCell *tCell = (CKTitleContainerCell *)cell;
        tCell.title = [self titleAtIndex:indexPath.item];
    }
    else
    {
        NSAssert([self.pageDataSource respondsToSelector:@selector(segmentedPage:displayViewForPageAtIndex:)], @"必须要实现这个方法，返回页当前页");
        cell.displayView = [self.pageDataSource segmentedPage:self displayViewForPageAtIndex:indexPath.item];
    }
    
    static NSArray *colors = nil;
    if (!colors) {
        colors = @[[UIColor whiteColor], [UIColor blueColor], [UIColor cyanColor], [UIColor greenColor], [UIColor purpleColor], [UIColor orangeColor]];
    }
    
    cell.backgroundColor = colors[arc4random() % colors.count];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize toReturn = CGSizeZero;
    
    if ([collectionView isEqual:self.titleCollectionView])
    {
        CGFloat width;
        if ([self.pageDataSource respondsToSelector:@selector(segmentedPage:widthForTitleAtIndex:)]) {
            width = [self.pageDataSource segmentedPage:self widthForTitleAtIndex:indexPath.item];
        }
        else
        {
            width = [self titleWidthAtIndex:indexPath.item];
        }
        toReturn = CGSizeMake(ceil(width), CGRectGetHeight(collectionView.frame));
    }
    else
    {
        toReturn = CGSizeMake(CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame));
    }
    
    return toReturn;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.titleCollectionView]) {
        self.targetItem = indexPath.item;
        [self.titleCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self.pageCollectionView setContentOffset:CGPointMake(indexPath.item * CGRectGetWidth(self.frame), 0) animated:YES];
        if ([self.pageDelegate respondsToSelector:@selector(segmentedPage:didSelectTitleAtIndex:)]) {
            [self.pageDelegate segmentedPage:self didSelectTitleAtIndex:indexPath.item];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.pageCollectionView]) {
        if (self.targetItem != -1 && indexPath.item != self.targetItem) {
            return;
        }
        lastNextItem = indexPath.item;
        if ([self.pageDelegate respondsToSelector:@selector(segmentedPage:willShowDisplayViewAtIndex:)]) {
            [self.pageDelegate segmentedPage:self willShowDisplayViewAtIndex:indexPath.item];
        }
    }
}

static NSInteger lastNextItem = -1;
#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.pageCollectionView]) {
        if (scrollView.contentSize.width <= 0 || CGRectGetWidth(scrollView.frame) <= 0) {
            return;
        }
        
        CGFloat ddd = scrollView.contentOffset.x - scrollView.contentSize.width + CGRectGetWidth(scrollView.frame);
        if (ddd > 0 || scrollView.contentOffset.x < 0) {
            return;
        }
        
        NSInteger nextItem;
        
        if (self.targetItem == -1) {
            nextItem = lastNextItem;
        }
        else
        {
            nextItem = self.targetItem;
        }
        
        UICollectionViewCell *currentCell = [self.titleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentItem inSection:0]];
        
        CGRect currentFrame = currentCell.frame;
        
        UICollectionViewCell *nextCell = [self.titleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]];
        CGRect nextFrame = nextCell.frame;
        
        CGFloat currentWidth = currentFrame.size.width;
        CGFloat nextWidth = nextFrame.size.width;
        
        CGFloat totalWidth = ABS((self.currentItem - nextItem) * CGRectGetWidth(scrollView.frame));
        NSInteger deltaOffset = scrollView.contentOffset.x - CGRectGetWidth(scrollView.frame) * self.currentItem;
        CGFloat widthPercent = ABS(deltaOffset / MAX(CGRectGetWidth(scrollView.frame), totalWidth));
        
//        NSLog(@"%@", @(totalWidth));
        
        CGFloat deltaX = nextFrame.origin.x - currentFrame.origin.x;
        CGFloat deltaWidth = nextWidth - currentWidth;
        
        CGFloat height = self.heightOfBottomIndicator;
        CGFloat width = currentWidth + deltaWidth * widthPercent;
        CGFloat x = currentFrame.origin.x + deltaX * widthPercent;
        
//        NSLog(@"%@, %@, %@ , %@, %@", @(x), @(widthPercent), @(deltaOffset), @(currentWidth), @(nextWidth));
        
        self.bottomIndicatorOfTitle.frame = CGRectMake(x, [self titleHeight] - height, width, self.heightOfBottomIndicator);

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidStop:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidStop:scrollView];
}

- (void)scrollViewDidStop:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.pageCollectionView]) {
        lastNextItem = -1;
        self.targetItem = -1;
        NSInteger currentItem = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        [self.titleCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:currentItem inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
        self.currentItem = currentItem;
        if ([self.pageDelegate respondsToSelector:@selector(segmentedPage:didShowDisplayViewAtIndex:)]) {
            [self.pageDelegate segmentedPage:self didShowDisplayViewAtIndex:currentItem];
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - getters
- (UIView *)bottomIndicatorOfTitle
{
    if (!_bottomIndicatorOfTitle) {
        _bottomIndicatorOfTitle = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomIndicatorOfTitle.backgroundColor = CKSegmentedPageTitleSelectedTextColor;
        [self.titleCollectionView addSubview:_bottomIndicatorOfTitle];
    }
    return _bottomIndicatorOfTitle;
}

#pragma mark - inits
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

@end
