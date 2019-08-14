//
//  FluidTabs.x
//  FluidTabs
//
//  Created by tomt000 on 12/08/2019.
//  Copyright © 2019 tomt000. All rights reserved.
//

#import "FluidTabs.h"

static NSString *options = @"/private/var/mobile/Library/Preferences/me.tomt000.fluidtabs.plist";

static bool noAnimation = false;

/**
  Makes a springboard fade-out animation used for respring in the settings apps
*/
void fluidtabsNotificationCallback(CFNotificationCenterRef center, void * observer, CFStringRef name, void const * object, CFDictionaryRef userInfo) {
    NSArray<UIWindow*> *allWindows = [UIWindow allWindowsIncludingInternalWindows:YES onlyVisibleWindows:NO];
    UIWindow *rootWindow;

    for (UIWindow *window in allWindows)
        if ([NSStringFromClass([window class]) isEqualToString: @"FBRootWindow"])
          rootWindow = window;

    [UIView animateWithDuration:0.23f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
      if(rootWindow){
         rootWindow.alpha = 0.0f;
         rootWindow.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
      }
    } completion:nil];
}

/**
  Adds a white background to these apps as they entirely rely on the tabs backgrounds for the apps color :(
  TODO: Get the color based on the different tabs in the app?
*/
bool shouldUseWhiteBackground(NSString *bundleID){

  NSArray *whiteApps = [NSArray arrayWithObjects:
      @"com.apple.mobilephone",
      @"com.apple.mobileslideshow",
      @"com.alibaba.iAliexpress",
      @"fr.leboncoin.Leboncoin",
      @"net.whatsapp.WhatsApp",
      @"com.saurik.Cydia",
      @"com.apple.music", //iOS 7
  nil];

  for(NSString *bundle in whiteApps)
    if([bundleID isEqualToString:bundle]) return true;

  return false;
}

/**
  Gets the next tab to switch to depending on the swipe type
  If the tab get to their end, then it jumps back to the begining
  TODO: Skip fake tabs used as buttons in apps (Reddit)
*/
int getNextAvailableTab(UITabBarController *controller, BOOL isRight){
  UITabBar *tabBar = controller.tabBar;

  // Fix for the iTunes Store
  // Somehow iTunes sets the tab index to the max long value when on the last tab, like wtf???
  int selectedTab = fmax(0,fmin([tabBar.items count]-1,controller.selectedIndex));

  int goTo = isRight ? selectedTab - 1 : selectedTab + 1;

  if([tabBar.items count] <= selectedTab+1 && !isRight)
    goTo = 0;
  else if(selectedTab == 0 && isRight)
    goTo = [tabBar.items count]-1;

  return goTo;
}

%hook UITabBarController

-(void)viewDidAppear:(BOOL)animated {
  %orig;

  if(shouldUseWhiteBackground([[NSBundle mainBundle] bundleIdentifier])) self.view.backgroundColor = [UIColor whiteColor];

  UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextView:)];
  swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
  [self.view addGestureRecognizer: swipeRight];

  UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextView:)];
  swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.view addGestureRecognizer: swipeLeft];

  self.view.userInteractionEnabled = YES;
}


/**
  Function called by the gesture recognizer to switch tabs
*/
%new -(void)nextView: (UISwipeGestureRecognizer *)recognizer {

  BOOL isRight = recognizer.direction == UISwipeGestureRecognizerDirectionRight;

  UITabBarItem *item = self.tabBar.items[getNextAvailableTab(self, isRight)];

  if(noAnimation){
    [self _tabBarItemClicked: item];
    return;
  }

  CGRect f = [self _transitionView].frame;
  int direction = f.size.width/2 * (isRight ? -1 : 1);

  /**
    0 > 50% Makes the old tab fade out and go left/isRight
    50% Switches view and offsets the view left/right
    50% > 100% Fades in the new tab and makes it got the original position
  */
  [UIView animateWithDuration:0.05 delay:0 options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionPreferredFramesPerSecond60 | UIViewAnimationOptionAllowUserInteraction) animations:^{

    [[self _transitionView] setFrame:CGRectMake(f.origin.x - direction, f.origin.y, f.size.width, f.size.height)];
    [self _transitionView].alpha = 0;

  }completion:^(BOOL finished) {

    [self _tabBarItemClicked: item];
    [[self _transitionView] setFrame:CGRectMake(f.origin.x + direction, f.origin.y, f.size.width, f.size.height)];

    [UIView animateWithDuration:0.39 delay:0 usingSpringWithDamping:0.714 initialSpringVelocity:0.1 options:UIViewAnimationOptionAllowUserInteraction animations:^{

      [[self _transitionView] setFrame:CGRectMake(0, f.origin.y, f.size.width, f.size.height)];
      [self _transitionView].alpha = 1;

    } completion:nil];

  }];

}

%end

%group SpringBoardHooks

%hook SpringBoard

/**
  Registers the darwin notification used for resprings
*/
-(id)init {
  self = %orig;

  CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
  CFStringRef str = (__bridge CFStringRef)@"me.tomt000.fluidtabs.respring";
  CFNotificationCenterRemoveObserver(center, (__bridge const void *)(self), str, NULL);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), fluidtabsNotificationCallback, str, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  return self;
}

%end

%end

/**
  Loads the config if not already loaded and checks if the injected process is an app
  TODO: Add more options in config?
*/
%ctor {

    bool loadedConfig = false;
    bool enabledTweak = true;

    if(!loadedConfig){
      NSMutableDictionary *prefs = [NSMutableDictionary new];
      if([[NSFileManager defaultManager] fileExistsAtPath:options]) prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:options];
      enabledTweak = ([prefs objectForKey:@"Enable"] ? [[prefs objectForKey:@"Enable"] boolValue] : YES);
      noAnimation = ([prefs objectForKey:@"NoAnimation"] ? [[prefs objectForKey:@"NoAnimation"] boolValue] : NO);

      /**
        Makes sure the tweak bundle id is installed for anti piracy reasons
      */
      if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.tomt000.fluidtabs.list"]) loadedConfig = true;
    }

    if(!enabledTweak || !loadedConfig) return;

    NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
    if (args.count != 0) {
      NSString *executablePath = args[0];
      if(!executablePath)
        return;
      else if([executablePath rangeOfString:@".app/"].location == NSNotFound && [executablePath rangeOfString:@"/Application/"].location == NSNotFound && [executablePath rangeOfString:@"/Applications/"].location == NSNotFound)
        return;
      else if([executablePath rangeOfString:@"SpringBoard"].location != NSNotFound)
        %init(SpringBoardHooks);
    }

   %init(_ungrouped);
}
