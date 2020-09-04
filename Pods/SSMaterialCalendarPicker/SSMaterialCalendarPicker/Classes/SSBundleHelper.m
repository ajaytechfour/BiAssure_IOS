//
//  SSBundleHelper.m
//  SSMaterialCalendarPicker
//
//  Created by Iuri Chiba on 7/11/16.
//  Copyright © 2016 Shoryuken Solutions. All rights reserved.
//

#import "SSBundleHelper.h"

@implementation SSBundleHelper

+ (NSBundle *)calendarBundle {
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CalendarViews" ofType:@"bundle"]];
}

@end
