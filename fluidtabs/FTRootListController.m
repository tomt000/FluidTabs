//
//  FTRootListController.m
//  FluidTabs
//
//  Created by tomt000 on 12/08/2019.
//  Copyright © 2019 tomt000. All rights reserved.
//

#include "FTRootListController.h"

@implementation FTRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

-(void)viewDidLoad {
	[super viewDidLoad];

	//Removes the white border
	[_table setSeparatorColor:[UIColor clearColor]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	//Fixes Noctis / Eclipse design conflicts
	//Very hacky lol
	double delayInSeconds = 0.05;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		UINavigationBar *bar = self.navigationController.navigationController.navigationBar;
		if([bar _backgroundView]) [bar _backgroundView].backgroundColor = [UIColor colorWithRed:0.60 green:0.80 blue:0.32 alpha:1.0];

		for(UIView *view in bar.subviews){
			if([NSStringFromClass ([view class]) isEqualToString:@"_UIBarBackground"]){
				NSLog(@"Removed eclipse design conflict");
				view.backgroundColor = [UIColor colorWithRed:0.60 green:0.80 blue:0.32 alpha:1.0];
				break;
			}
		}
	});

}

//Resets the navigation bar properies
- (void)viewWillDisappear:(BOOL)arg{
	[super viewWillDisappear:arg];
	[self.navigationController.navigationController.navigationBar setBarTintColor:nil];
	[self.navigationController.navigationController.navigationBar setTintColor:nil];
	[self.navigationController.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor blackColor]}];
	[self.navigationController.navigationController.navigationBar setShadowImage:nil];
	[self.navigationController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

	[self.navigationController.navigationBar setBarTintColor:nil];
	[self.navigationController.navigationBar setTitleTextAttributes: nil];
	[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar setShadowImage:nil];
	[self.navigationController.navigationBar setTranslucent:YES];
	[self.navigationController.navigationBar setBackgroundColor:nil];
	[self.navigationController.navigationBar setTintColor:nil];
	[self.navigationController.view setBackgroundColor:nil];

	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
}


-(void)viewWillAppear:(BOOL)animated
{
	self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,214)];
	self.banner = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,214)];

	[self.banner setImage: [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/FluidTabs.bundle/banner.png"]];
	[self.banner setTranslatesAutoresizingMaskIntoConstraints: NO];
	[self.banner setContentMode: UIViewContentModeScaleAspectFill];

	[self.headerView addSubview:self.banner];
	[NSLayoutConstraint activateConstraints:@[
			[self.banner.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
			[self.banner.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
			[self.banner.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
			[self.banner.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor]
	]];

	//self.headerView.layer.zPosition = -20;

	_table.tableHeaderView = self.headerView;

	[[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Respring" style:0x0 target:self action:@selector(respring)]];

	UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 71, 20.34)];
	title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
	title.text = @"FluidTabs";
	title.textColor = [UIColor whiteColor];
	title.textAlignment = NSTextAlignmentCenter;

	self.navigationItem.titleView = title;
	self.navigationItem.titleView.alpha = 1;

	[self.view setTintColor:[UIColor colorWithRed:0.28 green:0.16 blue:0.07 alpha:1.0]];
	[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor colorWithRed:0.60 green:0.80 blue:0.32 alpha:1.0];

	//iPhone
	[self.navigationController.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	[self.navigationController.navigationController.navigationBar setShadowImage:[UIImage new]];
	[self.navigationController.navigationController.navigationBar setTranslucent:NO];
	[self.navigationController.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:0.60 green:0.80 blue:0.32 alpha:1.0]];
	[self.navigationController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
	[self.navigationController.navigationController.view setBackgroundColor:[UIColor colorWithRed:0.60 green:0.80 blue:0.32 alpha:1.0]];

	//iPad
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.60 green:0.80 blue:0.32 alpha:1.0]];
	[self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar setShadowImage:[UIImage new]];
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:0.60 green:0.80 blue:0.32 alpha:1.0]];
	[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
	[self.navigationController.view setBackgroundColor:[UIColor colorWithRed:0.60 green:0.80 blue:0.32 alpha:1.0]];

	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];


	/**
		Simple pirate repo protection
		I didn't even test that, just slapped my code from copylog lmao so it might not work idk
	*/
	if(![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.tomt000.fluidtabs.list"]){
		UIViewController * vc = [[UIViewController alloc] init];

		vc.view.backgroundColor = [UIColor blackColor];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0,130, self.view.frame.size.width, 50)];
    title.font = [UIFont boldSystemFontOfSize:36];
    title.text = @"Sorry!";
    title.alpha = 0.95;
		title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [vc.view addSubview: title];


		UITextView *small = [[UITextView alloc] initWithFrame:CGRectMake(57,180, self.view.frame.size.width - 114, 300)];
		small.font = [UIFont systemFontOfSize:19];
		small.text = @"This copy of FluidTabs wasn't downloaded from it's original repo... \n\nIf you believe this is an error, just hmu on twitter @tomt000";
		small.alpha = 0.75;
		small.textAlignment = NSTextAlignmentCenter;
		small.textColor = [UIColor whiteColor];
		small.backgroundColor = [UIColor clearColor];
		small.userInteractionEnabled = NO;
		[vc.view addSubview: small];

		[self pushController:vc];
	}

}

//Detects the delegate scrolls, and adapts the banner height to create a nice scroll animation
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float offsetY = scrollView.contentOffset.y > 0 ? 0 : scrollView.contentOffset.y;
    self.banner.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 214 - offsetY/2.1f);
}

- (void)respring {

	[self reload];
	[self clearCache];

	//Forces the Preferences to save, best solution i've found so far :(
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.tomt000.fluidtabs.plist"];
	if(!prefs ) prefs = [NSMutableDictionary new];

	for(PSSpecifier *sp in [self specifiers]){
		NSDictionary *properties = [sp properties];
		NSString *key = [properties objectForKey:@"key"];
		NSObject *value = [properties objectForKey:@"value"];
		if(key && value) [prefs setObject:value forKey:key];
	}

	[prefs writeToFile:@"/var/mobile/Library/Preferences/me.tomt000.fluidtabs.plist" atomically:YES];

	/**
		Sends a darwin notificaion to the SpringBoard to create a nice Respring transition
		Credit to Cephei for making me discover the SpringBoardServices resrping method :)
	*/

	CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
	CFDictionaryRef const userInfo = NULL;
	BOOL const deliverImmediately = YES;
	CFStringRef str = (__bridge CFStringRef)@"me.tomt000.fluidtabs.respring";
	CFNotificationCenterPostNotification(center, str, NULL, userInfo, deliverImmediately);

	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.24 * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/SpringBoardServices.framework"] load];
	 SBSRelaunchAction *restartAction = [objc_getClass("SBSRelaunchAction") actionWithReason:@"RestartRenderServer" options:SBSRelaunchActionOptionsFadeToBlackTransition targetURL:[NSURL URLWithString:@"prefs:root=FluidTabs"]];
	 [[objc_getClass("FBSSystemService") sharedService] sendActions:[NSSet setWithObject:restartAction] withResult:nil];
	});



}

- (void)twitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/tomt000"]];
}

@end
