//
//  SSMaterialStepView.m
//  SSMaterialCalendarPicker
//
//  Created by Iuri Chiba on 7/22/15.
//  Copyright © 2015 Shoryuken Solutions. All rights reserved.
//

#import "SSMaterialStepView.h"

@implementation SSMaterialStepView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:rect];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, self.shadowDistance);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowPath = shadowPath.CGPath;
}

@end
