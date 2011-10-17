
#import "GLSampleRootController.h"

#import "OpenFeint/OFControllerLoaderObjC.h"
#import "OpenFeint/UIView+OpenFeint.h"
#import "OpenFeint/OpenFeint.h"
#import "OpenFeint/OFWebUIController.h"

#import "OpenFeint/OpenFeint+NSNotification.h"
#import "OpenFeint/UIButton+OpenFeint.h"
#import "OpenFeint/OpenFeint+Private.h"
#import "OpenFeint/OFGameFeedView.h"
#import "OpenFeint/OFSettings.h"
#import "OpenFeint/OFGameFeedSettingsInternal.h"

//#define ALLOW_LAYER_ROTATION

@interface GLSampleRootController ()


@end

@implementation GLSampleRootController

@synthesize gameFeed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.gameFeed = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"TestEAGLView" owner:@"" options:nil];
    id openGLViewObj = [nibViews objectAtIndex:0];
    if ([openGLViewObj isKindOfClass:[UIView class]])
    {
        self.view = openGLViewObj;
    }
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
#ifdef ALLOW_LAYER_ROTATION
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
#endif
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[OpenFeint setDashboardOrientation:toInterfaceOrientation];
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (BOOL)useLocalConfig
{
    if([[OFSettings instance] getSetting:@"use_local_game_feed_config"] &&
       [[[OFSettings instance] getSetting:@"use_local_game_feed_config"] isEqualToString:@"true"])
    {
        return YES;
    }
    return NO;
}

- (BOOL)useLocalItems
{
    if([[OFSettings instance] getSetting:@"use_local_game_feed_items"] &&
       [[[OFSettings instance] getSetting:@"use_local_game_feed_items"] isEqualToString:@"true"])
    {
        return YES;
    }
    return NO;
}

- (void)setupGameFeed
{
    NSMutableDictionary* settings = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:YES], OFGameFeedSettingAnimateIn,
                                     nil];
    
    [settings setObject:[NSNumber numberWithInt:OFGameFeedAlignment_BOTTOM] forKey:OFGameFeedSettingAlignment];
    
    
    self.gameFeed = [OFGameFeedView gameFeedViewWithSettings:settings];
    
    [self.view addSubview:gameFeed];
}

@end
