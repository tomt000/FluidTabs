//
//  Banner.mm
//  FluidTabs
//
//  Created by tomt000 on 12/08/2019.
//  Copyright © 2019 tomt000. All rights reserved.
//


#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSViewController.h>
#import <Preferences/PSTableCell.h>

@interface BannerController : PSTableCell

@property (nonatomic, retain) UIImageView *CLImage;

@end


@implementation BannerController


-(id)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(NSString *)arg2 specifier:(PSSpecifier *)arg3 {
    self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.74 green:0.54 blue:0.39 alpha:1.0];

        self.CLImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,114)];
      	self.CLImage.contentMode = UIViewContentModeScaleAspectFill;
      	self.CLImage.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/FluidTabs.bundle/copylog.png"];
      	self.CLImage.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:self.CLImage];
      	[NSLayoutConstraint activateConstraints:@[
      			[self.CLImage.topAnchor constraintEqualToAnchor:self.topAnchor],
            [self.CLImage.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      			[self.CLImage.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      			[self.CLImage.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.CLImage.heightAnchor constraintEqualToConstant:114]
      	]];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tap];

    }

    return self;
}


- (void) tapGesture: (id)sender
{
  NSArray *urls = [NSArray arrayWithObjects: @"sileo://package/me.tomt000.copylog", @"cydia://package/me.tomt000.copylog", @"https://repo.packix.com/package/me.tomt000.copylog/", nil];
  for(NSString *url in urls)
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (CGFloat)preferredHeightForWidth:(double)arg1 inTableView:(id)arg2 {
    return 114;
}

@end
