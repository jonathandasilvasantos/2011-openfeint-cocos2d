//
//  AppDelegate.h
//  OpenFeintCocos2D Template
//
//  Created by Jonathan da Silva Santos on 17/10/11.
//  Copyright JSS Games 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class SampleOFDelegate;
@class SampleOFNotificationDelegate;
@class SampleOFChallengeDelegate;
@class SampleOFBragDelegate;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
	SampleOFDelegate *ofDelegate;
	SampleOFNotificationDelegate *ofNotificationDelegate;
	SampleOFChallengeDelegate *ofChallengeDelegate;
	SampleOFBragDelegate *ofBragDelegate;
    
}

@property (nonatomic, retain) UIWindow *window;

@end
