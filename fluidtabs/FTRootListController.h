//
//  FTRootListController.h
//  FluidTabs
//
//  Created by tomt000 on 12/08/2019.
//  Copyright © 2019 tomt000. All rights reserved.
//

#import "header/PSListController.h"
#import "header/PSSpecifier.h"
#import "NSTask.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoardServices/SBSRestartRenderServerAction.h>
#import <FrontBoardServices/FBSSystemService.h>
#import <objc/runtime.h>
#import <math.h>

@interface FTRootListController : PSListController
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *banner;

@end
@interface UINavigationBar (CopyLog)

-(UIView*)_backgroundView;

@end
