//
//  UIActivityIndicatorViewWithText.h
//  WS MySQL
//
//  Created by DroidFx on 4/29/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActivityIndicatorViewWithText : UIView

@property(nonatomic,readonly) UIActivityIndicatorView *loadingIndicator;

- (void) showActivityIndicatorWhileLoading;

-(void)startLoadingIndicator;

-(void)stopLoadingIndicator;

@end
