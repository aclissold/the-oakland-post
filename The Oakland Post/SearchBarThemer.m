//
//  SearchBarThemer.m
//  TheOaklandPost
//
//  Created by Andrew Clissold on 2/22/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

#import "SearchBarThemer.h"
#import <UIKit/UIKit.h>

@implementation SearchBarThemer

// Ugly workaround because this method is not available to Swift.
+ (void)theme {
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:
     @{
       NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:15],
    }];
}

@end
