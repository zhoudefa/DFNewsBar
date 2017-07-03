//
//  DFNewBarView.h
//  DFNewsBar
//
//  Created by 周德发 on 2017/4/5.
//  Copyright © 2017年 周德发. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DFNewBarView;

@protocol DFNewBarViewDelegate <NSObject>

-(void)dfNewBarView:(DFNewBarView *)newBarView selectedIndex:(NSInteger )selectedIndex;

@end




@interface DFNewBarView : UIView

-(DFNewBarView *)initWithFrame:(CGRect )frame titleArray:(NSArray<NSString *> *)titleArray;

@property (nonatomic ,weak) id<DFNewBarViewDelegate> delegate;

@property (nonatomic ,assign) NSInteger selectedIndex;
@property (nonatomic ,assign) CGFloat displayQuantity;
@property (nonatomic ,assign) CGFloat itemWidth;

@property (nonatomic ,assign ,getter=isHasSlideLine) BOOL hasSlideLine;
@property (nonatomic ,strong) UIColor *slideLineColor;


@property (nonatomic ,assign ,getter=isHasSeparateLines) BOOL hasSeparateLines;
@property (nonatomic ,strong) UIColor *separateLinesColor;


@property (nonatomic ,strong) UIColor *currentTitleColor;
@property (nonatomic ,strong) UIColor *currentBackgroundColor;
@property (nonatomic ,strong) UIFont *currentTitleFont;

@property (nonatomic ,strong) UIColor *normalTitleColor;
@property (nonatomic ,strong) UIColor *normalBackgroundColor;
@property (nonatomic ,strong) UIFont *normalTitleFont;

@property (nonatomic ,strong) NSArray<NSString *> *titleArray;

-(void)clickItemWithIndex:(NSInteger )index;

@end
