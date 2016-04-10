//
//  KMATutorialView.m
//  Loop
//
//  Created by Carolyn Lee on 4/5/16.
//  Copyright (c) 2016 Keion Anvaripour. All rights reserved.
//

#import "KMATutorialView.h"

@interface KMATutorialView () <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIButton *doneButton;

@property (strong, nonatomic) UIView *viewOne;
@property (strong, nonatomic) UIView *viewTwo;


@end
@implementation KMATutorialView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        
        [self.scrollView addSubview:self.viewOne];
        [self.scrollView addSubview:self.viewTwo];
        
        
        //Done Button
        [self addSubview:self.doneButton];
        
        
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);
    
}

-(UIView *)viewOne {
    if (!_viewOne) {
        
        _viewOne = [[UIView alloc] initWithFrame:self.frame];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.05, self.frame.size.width*.8, 60)];
        titleLabel.center = CGPointMake(self.center.x, self.frame.size.height*.1);
        titleLabel.text = [NSString stringWithFormat:@"Tutorial Image 1"];
        titleLabel.font = [UIFont systemFontOfSize:40.0];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment =  NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [_viewOne addSubview:titleLabel];
        
        /*UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.1, self.frame.size.height*.1, self.frame.size.width*.8, self.frame.size.width)];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:@"Intro_Screen_One"];
        [_viewOne addSubview:imageview];
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*.1, self.frame.size.height*.7, self.frame.size.width*.8, 60)];
        descriptionLabel.text = [NSString stringWithFormat:@"Description for First Screen."];
        descriptionLabel.font = [UIFont systemFontOfSize:18.0];
        descriptionLabel.textColor = [UIColor whiteColor];
        descriptionLabel.textAlignment =  NSTextAlignmentCenter;
        descriptionLabel.numberOfLines = 0;
        [descriptionLabel sizeToFit];
        [_viewOne addSubview:descriptionLabel];
        
        CGPoint labelCenter = CGPointMake(self.center.x, self.frame.size.height*.7);
        descriptionLabel.center = labelCenter;*/
        
    }
    return _viewOne;
    
}

-(UIView *)viewTwo {
    if (!_viewTwo) {
        CGFloat originWidth = self.frame.size.width;
        CGFloat originHeight = self.frame.size.height;
        
        _viewTwo = [[UIView alloc] initWithFrame:CGRectMake(originWidth, 0, originWidth, originHeight)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.05, self.frame.size.width*.8, 60)];
        titleLabel.center = CGPointMake(self.center.x, self.frame.size.height*.1);
        titleLabel.text = [NSString stringWithFormat:@"Tutorial Image 2"];
        titleLabel.font = [UIFont systemFontOfSize:40.0];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment =  NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [_viewTwo addSubview:titleLabel];
        
        /*UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.1, self.frame.size.height*.1, self.frame.size.width*.8, self.frame.size.width)];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:@"Intro_Screen_Two"];
        [_viewTwo addSubview:imageview];
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*.1, self.frame.size.height*.7, self.frame.size.width*.8, 60)];
        descriptionLabel.text = [NSString stringWithFormat:@"Description for Second Screen."];
        descriptionLabel.font = [UIFont systemFontOfSize:18.0];
        descriptionLabel.textColor = [UIColor whiteColor];
        descriptionLabel.textAlignment =  NSTextAlignmentCenter;
        descriptionLabel.numberOfLines = 0;
        [descriptionLabel sizeToFit];
        [_viewTwo addSubview:descriptionLabel];
        
        CGPoint labelCenter = CGPointMake(self.center.x, self.frame.size.height*.7);
        descriptionLabel.center = labelCenter;*/
    }
    return _viewTwo;
    
}


-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setContentSize:CGSizeMake(self.frame.size.width*2, self.scrollView.frame.size.height)];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-80, self.frame.size.width, 10)];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:0.129 green:0.588 blue:0.953 alpha:1.000]];
        [_pageControl setNumberOfPages:2];
    }
    return _pageControl;
}

-(UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-60, self.frame.size.width, 60)];
        [_doneButton setTintColor:[UIColor whiteColor]];
        [_doneButton setTitle:@"Skip" forState:UIControlStateNormal];
        [_doneButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [_doneButton setBackgroundColor:[UIColor colorWithRed:0.129 green:0.588 blue:0.953 alpha:1.000]];
        [_doneButton addTarget:self.delegate action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}


@end
