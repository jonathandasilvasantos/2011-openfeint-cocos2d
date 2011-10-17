//
//  AppDelegate.m
//  OpenFeintCocos2D Template
//
//  Created by Jonathan da Silva Santos on 17/10/11.
//  Copyright JSS Games 2011. All rights reserved.
//

#import "cocos2d.h"
#import "AppDelegate.h"
#import "GameConfig.h"
#import "HelloWorldScene.h"
#import "RootViewController.h"

// OpenFeint
#import "OpenFeint/OpenFeint.h"ß
#import "SampleOFDelegate.h"
#import "SampleOFNotificationDelegate.h"
#import "SampleOFChallengeDelegate.h"
#import "SampleOFBragDelegate.h"
#import "OpenFeint/OFControllerLoaderObjC.h"


@implementation AppDelegate

@synthesize window;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
//#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
/*#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif*/
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [HelloWorld scene]];

    
	NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithInt:UIInterfaceOrientationPortrait], OpenFeintSettingDashboardOrientation,
							  @"SampleApp", OpenFeintSettingShortDisplayName,
							  [NSNumber numberWithBool:YES], OpenFeintSettingEnablePushNotifications,
							  [NSNumber numberWithBool:NO], OpenFeintSettingDisableUserGeneratedContent,
  							  [NSNumber numberWithBool:NO], OpenFeintSettingAlwaysAskForApprovalInDebug,
#ifdef DEBUG
                              [NSNumber numberWithInt:OFDevelopmentMode_DEVELOPMENT], OpenFeintSettingDevelopmentMode,
#else
                              [NSNumber numberWithInt:OFDevelopmentMode_RELEASE], OpenFeintSettingDevelopmentMode,
#endif
							  window, OpenFeintSettingPresentationWindow,
#ifdef DEBUG
							  [NSNumber numberWithInt:OFDevelopmentMode_DEVELOPMENT], OpenFeintSettingDevelopmentMode,
#else
							  [NSNumber numberWithInt:OFDevelopmentMode_RELEASE], OpenFeintSettingDevelopmentMode,
#endif
							  nil
							  ];
	ofDelegate = [SampleOFDelegate new];
	ofNotificationDelegate = [SampleOFNotificationDelegate new];
	ofChallengeDelegate = [SampleOFChallengeDelegate new];
	ofBragDelegate = [SampleOFBragDelegate new];
    
	OFDelegatesContainer* delegates = [OFDelegatesContainer containerWithOpenFeintDelegate:ofDelegate
																	  andChallengeDelegate:ofChallengeDelegate
																   andNotificationDelegate:ofNotificationDelegate];
	delegates.bragDelegate = ofBragDelegate;
    
	[OpenFeint initializeWithProductKey:@"PRODUCT_KEY"
							  andSecret:@"SECRET_KEY"
						 andDisplayName:@"DISPLAY_NAME"
							andSettings:settings
						   andDelegates:delegates];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	[OpenFeint applicationDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	[OpenFeint applicationDidFailToRegisterForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	[OpenFeint applicationDidReceiveRemoteNotification:userInfo];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	[OpenFeint shutdown];	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[ofDelegate release];
	[ofNotificationDelegate release];
	[ofChallengeDelegate release];
	[ofBragDelegate release];    
	[window release];
	[super dealloc];
}

@end
