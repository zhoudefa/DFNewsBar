//
//  DFNewBarView.m
//  DFNewsBar
//
//  Created by 周德发 on 2017/4/5.
//  Copyright © 2017年 周德发. All rights reserved.
//

#import "DFNewBarView.h"

@interface DFNewBarView ()

@property (nonatomic ,strong)UIView *slideView;
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,strong)UIView *bottomLineView;
@property (nonatomic ,strong)UIView *topLineView;


@end

@implementation DFNewBarView


-(DFNewBarView *)initWithFrame:(CGRect )frame titleArray:(NSArray<NSString *> *)titleArray
{
    if (self = [super initWithFrame:frame]) {
        
        
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.showsHorizontalScrollIndicator = NO;
//        self.scrollView.bounces = NO;
        [self addSubview:self.scrollView];
        
        self.topLineView = [[UIView alloc] init];
        self.topLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.topLineView];
        
        self.bottomLineView = [[UIView alloc] init];
        self.bottomLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.bottomLineView];
        
       
        
        
        _titleArray = titleArray;
        
        
        

        
        [self initData];
        
        [self layoutOtherSubviews];
        
    }
    return self;
}


-(void)layoutOtherSubviews
{
    if (_titleArray == nil ||_titleArray.count == 0) {
        return;
    }
    
    
    self.bottomLineView.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
    self.bottomLineView.frame = CGRectMake(0, 0, self.bounds.size.width, 1);
    
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.topLineView.frame), self.bounds.size.width, self.bounds.size.height - self.bottomLineView.bounds.size.height - self.topLineView.bounds.size.height);
    
    
    CGFloat slideViewW = self.bounds.size.width / self.displayQuantity;
    if ( slideViewW > 80) {
        slideViewW = 80;
    }
    
    
    
    for (UIView *obj in self.scrollView.subviews) {
        [obj removeFromSuperview];
    }
    
    
    
    if (self.titleArray.count < self.displayQuantity) {
        _displayQuantity = self.titleArray.count;
    }
    
    
    self.slideView = [[UIView alloc]init];
    self.slideView.frame = CGRectMake(0, self.scrollView.bounds.size.height - 2, slideViewW, 2);
    self.slideView.backgroundColor = self.slideLineColor;
    
    
    
    

    CGFloat buttonH = self.scrollView.bounds.size.height;
    CGFloat buttonW = (self.bounds.size.width - ((NSInteger )self.displayQuantity - 1)) / self.displayQuantity;
    
    self.scrollView.contentSize = CGSizeMake(buttonW * self.titleArray.count + (self.titleArray.count - 1), 0);
    
    
    for (NSInteger i = 0 ; i < self.titleArray.count ; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tintColor = [UIColor clearColor];
        button.frame = CGRectMake((buttonW+1) * i , 0, buttonW, buttonH);
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
        [button setTitleColor:self.currentTitleColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000 + i;
        if (i == self.selectedIndex) {
            button.selected = YES;
            button.titleLabel.font = self.currentTitleFont;
            button.backgroundColor = self.currentBackgroundColor;
            
            
        }else{
            button.selected = NO;
            button.titleLabel.font = self.normalTitleFont;
            button.backgroundColor = self.normalBackgroundColor;
        }
        [self.scrollView addSubview:button];
        
        
        if (self.hasSeparateLines && i != self.titleArray.count - 1) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 0, 1, buttonH)];
            view.backgroundColor = self.separateLinesColor;
            [self.scrollView addSubview:view];
            view.tag = 2000+i;
            
        }
        
        if (self.hasSlideLine) {
            [self.scrollView addSubview:self.slideView];

            UIButton *btn = [self.scrollView viewWithTag:self.selectedIndex + 1000];
            dispatch_async(dispatch_get_main_queue(), ^{
                CGPoint slideViewCenter = self.slideView.center;
                slideViewCenter.x = btn.center.x;
                self.slideView.center = slideViewCenter;
            });
            
        }else{
            self.slideView = nil;
        }
        
        
    }
    
    
    
    
}



-(void)buttonAction:(UIButton *)sender
{
    for (NSInteger i = 0 ; i < _titleArray.count ; i++ ) {
        
        UIButton *button = [self.scrollView viewWithTag:i+1000];
        button.selected = NO;
        button.titleLabel.font = self.normalTitleFont;
        button.backgroundColor = self.normalBackgroundColor;
    }
    
    sender.selected = YES;
    sender.titleLabel.font = self.currentTitleFont;
    sender.backgroundColor = self.currentBackgroundColor;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint slideViewCenter = _slideView.center;
        slideViewCenter.x = sender.center.x;
        _slideView.center = slideViewCenter;
    }];
    
    _selectedIndex = sender.tag - 1000;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dfNewBarView:selectedIndex:)]) {
        [self.delegate dfNewBarView:self selectedIndex:sender.tag - 1000];
    }
    
    
    [self scrollItem:sender];

    
}

-(void)clickItemWithIndex:(NSInteger )index
{

    self.selectedIndex = index;
    for (NSInteger i = 0 ; i < _titleArray.count ; i++ ) {
        
        UIButton *button = [_scrollView viewWithTag:i+1000];
        button.selected = NO;
        button.titleLabel.font = _normalTitleFont;
        button.backgroundColor = _normalBackgroundColor;
    }
    UIButton *sender = [_scrollView viewWithTag:index+1000];
    sender.selected = YES;
    sender.titleLabel.font = _currentTitleFont;
    sender.backgroundColor = _currentBackgroundColor;
    [UIView animateWithDuration:0.2 animations:^{
        
        CGPoint slideViewCenter = _slideView.center;
        slideViewCenter.x = sender.center.x;
        
        _slideView.center = slideViewCenter;
        
    }];
    
    _selectedIndex = sender.tag - 1000;
    
    [self scrollItem:sender];
}


-(void)scrollItem:(UIButton *)sender
{
    if (self.scrollView.contentSize.width <= self.bounds.size.width) {
        return ;
    }
    
    if (sender.tag - 1000 >= self.titleArray.count/2) {
        if (sender.tag - 1000 != self.titleArray.count - 1) {
            if ((((CGFloat)sender.tag - 1000 - self.displayQuantity + 2) * sender.bounds.size.width + sender.tag - 1000)<0) {
                [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

            }else{
                [self.scrollView setContentOffset:CGPointMake(((CGFloat)sender.tag - 1000 - self.displayQuantity + 2) * sender.bounds.size.width + sender.tag - 1000, 0) animated:YES];

            }
        }else{
            if ((((CGFloat)sender.tag - 1000 - self.displayQuantity + 2) * sender.bounds.size.width + sender.tag - 1000)<0) {
                [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                
            }else{
                [self.scrollView setContentOffset:CGPointMake(((CGFloat)sender.tag - 1000 - self.displayQuantity + 1) * sender.bounds.size.width + sender.tag - 1000, 0) animated:YES];
                
            }
        }
        
    }else{
        if (sender.tag - 1000 != 0) {
            
            if (((sender.tag - 1000 - 1) * sender.bounds.size.width + sender.tag - 1000)<0 ) {
                [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                
            }else{
                
                [self.scrollView setContentOffset:CGPointMake((sender.tag - 1000 - 1) * sender.bounds.size.width + sender.tag - 1000 , 0) animated:YES];

            }
        }
    }
    
    
    
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    self.bottomLineView.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
    self.topLineView.frame = CGRectMake(0, 0, self.bounds.size.width, 1);

    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.topLineView.frame), self.bounds.size.width, self.bounds.size.height - self.bottomLineView.bounds.size.height - self.topLineView.bounds.size.height);
    
    CGFloat slideViewW = self.bounds.size.width / self.displayQuantity;
    if ( slideViewW > 80) {
        slideViewW = 80;
    }
    self.slideView.frame = CGRectMake(0, self.scrollView.bounds.size.height - 2, slideViewW, 2);
}


-(void)initData
{
    self.displayQuantity = 4;
    
    self.hasSlideLine = YES;
    self.slideLineColor = [UIColor redColor];
    
    self.hasSeparateLines = YES;
    self.separateLinesColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    self.normalTitleFont = [UIFont systemFontOfSize:15.0];
    self.normalTitleColor = [UIColor darkGrayColor];
    self.normalBackgroundColor = [UIColor whiteColor];
    
    self.currentTitleFont = [UIFont systemFontOfSize:15.0];
    self.currentTitleColor = [UIColor redColor];
    self.currentBackgroundColor = [UIColor whiteColor];
    
    self.selectedIndex = 0;
    
}

-(void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    _displayQuantity = self.bounds.size.width/itemWidth;
    [self layoutOtherSubviews];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self layoutOtherSubviews];
}
-(void)setDisplayQuantity:(CGFloat )displayQuantity
{
    _displayQuantity = displayQuantity;
    [self layoutOtherSubviews];

}
-(void)setTitleArray:(NSArray<NSString *> *)titleArray
{
    _titleArray = titleArray;
    [self layoutOtherSubviews];

}

-(void)setSlideLineColor:(UIColor *)slideLineColor
{
    _slideLineColor = slideLineColor;
    [self layoutOtherSubviews];

}

-(void)setHasSlideLine:(BOOL)hasSlideLine
{
    _hasSlideLine = hasSlideLine;
    [self layoutOtherSubviews];

}

-(void)setHasSeparateLines:(BOOL)hasSeparateLines
{
    _hasSeparateLines = hasSeparateLines;
    [self layoutOtherSubviews];

}

-(void)setSeparateLinesColor:(UIColor *)separateLinesColor
{
    _separateLinesColor = separateLinesColor;
    [self layoutOtherSubviews];

}

-(void)setNormalTitleFont:(UIFont *)normalTitleFont
{
    _normalTitleFont = normalTitleFont;
    [self layoutOtherSubviews];

}
-(void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    _normalTitleColor = normalTitleColor;
    [self layoutOtherSubviews];

}
-(void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor
{
    _normalBackgroundColor = normalBackgroundColor;
    [self layoutOtherSubviews];

}
-(void)setCurrentTitleFont:(UIFont *)currentTitleFont
{
    _currentTitleFont= currentTitleFont;
    [self layoutOtherSubviews];

}
-(void)setCurrentTitleColor:(UIColor *)currentTitleColor
{
    _currentTitleColor = currentTitleColor;
    [self layoutOtherSubviews];

}

-(void)setCurrentBackgroundColor:(UIColor *)currentBackgroundColor
{
    _currentBackgroundColor = currentBackgroundColor;
    [self layoutOtherSubviews];
}

@end
