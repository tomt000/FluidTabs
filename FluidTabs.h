//
//  FluidTabs.h
//  FluidTabs
//
//  Created by tomt000 on 12/08/2019.
//  Copyright © 2019 tomt000. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIWindow (Private)
  + (UIWindow *)keyWindow;
  + (NSArray *)allWindowsIncludingInternalWindows:(BOOL)internalWindows onlyVisibleWindows:(BOOL)onlyVisibleWindows;
  - (void)_updateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(double)duration force:(BOOL)force;
  - (void)_setRotatableViewOrientation:(UIInterfaceOrientation)orientation updateStatusBar:(BOOL)updateStatusBar duration:(CGFloat)duration force:(BOOL)force;
  @property BOOL keepContextInBackground;
  @property (getter=_isSecure, setter=_setSecure:) BOOL _secure;
  @property (nonatomic, retain, readonly) UIResponder *firstResponder;
@end

@interface UITabBarController ()
  -(UIView*)_transitionView;
  -(void)_tabBarItemClicked:(id)clicked;
@end
