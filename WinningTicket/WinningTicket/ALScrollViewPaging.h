//
//  ALScrollViewPaging.h
//  WinningTicket
//
//  Created by Test User on 22/02/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALScrollViewPaging : UIScrollView <UIScrollViewDelegate> {
    BOOL pageControlBeingUsed;
    NSArray *_pages;
    UIPageControl *pageControl;
}

@property (nonatomic) int currentPage;
@property (nonatomic) BOOL hasPageControl;
@property (nonatomic, strong) UIColor *pageControlCurrentPageColor;
@property (nonatomic, strong) UIColor *pageControlOtherPagesColor;

- (id)initWithFrame:(CGRect)frame andPages:(NSArray *)pages;
- (void)addPages:(NSArray *)pages;

@end
