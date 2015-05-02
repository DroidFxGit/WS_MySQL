//
//  UIActivityIndicatorViewWithText.m
//  WS MySQL
//
//  Created by DroidFx on 4/29/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import "UIActivityIndicatorViewWithText.h"

@implementation UIActivityIndicatorViewWithText

- (void) showActivityIndicatorWhileLoading {
    
    if(!_loadingIndicator)
    {
        CGFloat width = self.bounds.size.width * 0.4;
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.bounds.size.width-width)/2, (self.bounds.size.height-width)/2, width , width)];
        _loadingIndicator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _loadingIndicator.layer.cornerRadius = width * 0.1;
        
        CGFloat labelX = (_loadingIndicator.bounds.size.width / 4);
        CGFloat labelY = (_loadingIndicator.bounds.size.height - 40.f);
        CGFloat labelWidth = _loadingIndicator.bounds.size.width;
        CGFloat labelHeight = (_loadingIndicator.bounds.size.height / 4);
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:12.0f];
        label.numberOfLines = 1;
        
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = @"Enviando...";
        
        [_loadingIndicator addSubview:label];
        
    }
    
    [self startLoadingIndicator];
}


-(void)startLoadingIndicator
{
    if(!_loadingIndicator.superview)
    {
        [self addSubview:_loadingIndicator];
    }
    [_loadingIndicator startAnimating];
}
-(void)stopLoadingIndicator
{
    if(_loadingIndicator.superview)
    {
        [_loadingIndicator removeFromSuperview];
    }
    [_loadingIndicator stopAnimating];
}


@end
