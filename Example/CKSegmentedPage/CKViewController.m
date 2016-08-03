//
//  CKViewController.m
//  CKSegmentedPage
//
//  Created by Cocody on 07/16/2016.
//  Copyright (c) 2016 Cocody. All rights reserved.
//

#import "CKViewController.h"
#import <Masonry/Masonry.h>
#import <CKSegmentedPage/CKSegmentedPage.h>

@interface CKViewController ()<CKSegmentedPageDataSource, CKSegmentedPageDelegate>

@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) NSMutableArray <UIView *> *views;

@end

@implementation CKViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	CKSegmentedPage *page = [[CKSegmentedPage alloc] init];
	page.pageDataSource = self;
	page.pageDelegate = self;
	
//	page.titleHeightOfTotal = 0.0618;
	page.titleHeight = 44;
	page.heightOfBottomIndicator = 3;
	
	self.titles = @[@"1asd", @"asd2", @"asdfasdf3",
//					@"4", @"5", @"6", @"7asdf", @"8", @"qwe9"
					];
	
	self.views = [NSMutableArray arrayWithCapacity:self.titles.count];
	for (int i = 0; i < self.titles.count; i++) {
		UIView *view = [UIView new];
		UILabel *label = [UILabel new];
		label.text = [NSString stringWithFormat:@"%@", @(i + 1)];
		label.font = [UIFont fontWithName:@"Arial" size:15];
		[label sizeToFit];
		[view addSubview:label];
		[self.views addObject:view];
	}
	
	[self.view addSubview:page];
	self.view.backgroundColor = [UIColor greenColor];
	
	__weak typeof(self) weakSelf = self;
	[page mas_makeConstraints:^(MASConstraintMaker *make) {
		UIEdgeInsets insets = UIEdgeInsetsMake(64, 0, 0, 0);
		make.edges.equalTo(weakSelf.view).with.insets(insets);
	}];
	
}

- (void)segmentedPage:(CKSegmentedPage *)page didSelectTitleAtIndex:(NSInteger)index
{
	NSLog(@"－－－ didSelecteTitleAtIndex, %@", @(index));
}

- (void)segmentedPage:(CKSegmentedPage *)page didSelectDisplayViewAtIndex:(NSInteger)index
{
	NSLog(@"＋＋＋ didSelecteDisplayViewAtIndex, %@", @(index));
}

- (void)segmentedPage:(CKSegmentedPage *)page willShowDisplayViewAtIndex:(NSInteger)index
{
	NSLog(@"＝＝＝ willShowDisplayViewAtIndex, %@", @(index));
}
- (void)segmentedPage:(CKSegmentedPage *)page didShowDisplayViewAtIndex:(NSInteger)index
{
	NSLog(@"＊＊＊ didShowDisplayViewAtIndex, %@", @(index));
}

- (NSInteger)numberOfPagesInSegmented:(CKSegmentedPage *)page
{
	return self.titles.count;
}

- (NSString *)segmentedPage:(CKSegmentedPage *)page titleForPageAtIndex:(NSInteger)index
{
	return self.titles[index];
}

- (UIView *)segmentedPage:(CKSegmentedPage *)page displayViewForPageAtIndex:(NSInteger)index
{
	return self.views[index];
}

- (NSInteger)segmentedPage:(CKSegmentedPage *)page widthForTitleAtIndex:(NSInteger)index
{
	return (NSInteger)([UIScreen mainScreen].bounds.size.width / self.titles.count);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
