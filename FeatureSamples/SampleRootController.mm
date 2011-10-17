#import "SampleRootController.h"

#import "OpenFeint/OFControllerLoaderObjC.h"
#import "OpenFeint/UIView+OpenFeint.h"
#import "OpenFeint/OpenFeint.h"
#import "OpenFeint/OFWebUIController.h"

#import "SampleUserViewController.h"
#import "SampleFeaturedGamesController.h"
#import "OpenFeint/OFTimeStamp.h"

// temp
#import "OpenFeint/OFHighScoreService.h"
#import "OpenFeint/OFCloudStorageService.h"
#import "OpenFeint/OFAnnouncement.h"

#ifdef __IPHONE_4_1
#import "OpenFeint/OpenFeint+GameCenter.h"
#import "GameKit/GameKit.h"
#endif


#import "OpenFeint/OpenFeint+NSNotification.h"
#import "OpenFeint/UIButton+OpenFeint.h"
#import "OpenFeint/OpenFeint+Private.h"
#import "OpenFeint/OFGameFeedView.h"
#import "OpenFeint/OFSettings.h"
#import "OpenFeint/OFDependencies.h"


static OFGameFeedAlignment gameFeedAlignment = OFGameFeedAlignment_BOTTOM;

// Switch which one is commented to test this feature
//static OFGameFeedAlignment gameFeedAlignment = OFGameFeedAlignment_TOP;
//static OFGameFeedAlignment gameFeedAlignment = OFGameFeedAlignment_CUSTOM;


@interface SampleRootController ()
	- (void)_push:(NSString*)name;
    - (void)addBadgeCount;
    - (void)badgeCountChanged;

- (void)removeGameFeed;
@property (nonatomic, retain) OFGameFeedView* gameFeed;
@property (nonatomic, retain) NSDictionary* customSettings;

@end

@implementation SampleRootController

@synthesize scrollView = mScrollView;
@synthesize gameFeed;
@synthesize isGameFeedViewReady;
@synthesize customSettings;

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
                                     
    [settings setObject:[NSNumber numberWithInt:gameFeedAlignment] forKey:OFGameFeedSettingAlignment];
    
    if (self.customSettings)
    {
        [settings addEntriesFromDictionary:self.customSettings];
    }
    
    
    self.gameFeed = [OFGameFeedView gameFeedViewWithSettings:settings];
    
    if(gameFeedAlignment == OFGameFeedAlignment_CUSTOM)
    {
        CGRect frame = self.gameFeed.frame;
        self.gameFeed.frame = CGRectMake(0, 100, frame.size.width, frame.size.height);
    }
    
    [self.view addSubview:gameFeed];
    CGRect frame = mScrollView.frame;
    if (gameFeedAlignment == OFGameFeedAlignment_BOTTOM) {
        frame.size.height -= gameFeed.frame.size.height;
        mScrollView.frame = frame;
    }
    else if(gameFeedAlignment == OFGameFeedAlignment_TOP)
    {
        frame.origin.y += gameFeed.frame.size.height;
        mScrollView.frame = frame;
    }
}

- (void)removeGameFeed
{
    if(gameFeed)
    {
        [gameFeed animateOutAndRemoveFromSuperview];
        [gameFeed release];
        gameFeed = nil;
        CGRect frame = mScrollView.frame;
        frame.origin.y = 0;
        frame.size.height = self.view.frame.size.height;
        mScrollView.frame = frame;
    }
}

-(void) switchGameFeed
{
    if(gameFeed)
    {
        [self removeGameFeed];
    }
    else
    {
        [self setupGameFeed];
    }
}

- (void) _push:(NSString*)name
{
	[self.navigationController pushViewController:[[OFControllerLoaderObjC loader] load:name] /*load(name)*/ animated:YES];
}

- (UIButton*)addButtonWithTitle:(NSString*)title andSelector:(SEL)selector
{
	UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[b setTitleForAllStates:title];
	[b addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
	b.frame = CGRectMake(20, mFillY, 280, 37);
	mFillY += 40;
	[mScrollView addSubview:b];
    return b;
}

- (void)addBadgeCount
{
    UILabel* badgeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, mFillY, 120, 30)];
    badgeCountLabel.text = @"Badge Count:";
    [mScrollView addSubview:badgeCountLabel];
    badgeCountLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
    badgeCountLabel.font = [UIFont boldSystemFontOfSize:14];
    badgeCountLabel.textAlignment = UITextAlignmentCenter;
    [badgeCountLabel release];
    
    mBadgeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, mFillY, 150, 30)];
    [mScrollView addSubview:mBadgeCountLabel];
    mFillY += 40;
    mBadgeCountLabel.text = [NSString stringWithFormat:@"%d", [OFCurrentUser OpenFeintBadgeCount]];
    mBadgeCountLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
    mBadgeCountLabel.font = [UIFont boldSystemFontOfSize:14];
    mBadgeCountLabel.textAlignment = UITextAlignmentCenter;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badgeCountChanged) name:OFNSNotificationUnreadInboxCountChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badgeCountChanged) name:OFNSNotificationUnviewedChallengeCountChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badgeCountChanged) name:OFNSNotificationPendingFriendCountChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badgeCountChanged) name:OFNSNotificationUnreadAnnouncementCountChanged object:nil];

}

- (void)badgeCountChanged
{
    mBadgeCountLabel.text = [NSString stringWithFormat:@"%d", [OFCurrentUser OpenFeintBadgeCount]];
}

- (void)loadView
{
	mFillY = 20.f;
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)] autorelease];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |
    UIViewAutoresizingFlexibleWidth       |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin   ;
	mScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)] autorelease];

	mScrollView.autoresizingMask =
		UIViewAutoresizingFlexibleWidth       |
        UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:mScrollView];
	self.view.autoresizesSubviews = YES;

	mScrollView.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1.0];

	[self addButtonWithTitle:@"Launch OpenFeint Dashboard"     andSelector:@selector(onLaunchDashboard)];
	[self addButtonWithTitle:@"Explore Challenges"             andSelector:@selector(onExploreChallenges)];
	[self addButtonWithTitle:@"Explore Leaderboards"           andSelector:@selector(onExploreLeaderboards)];
	[self addButtonWithTitle:@"Explore Achievements"           andSelector:@selector(onExploreAchivements)];
	[self addButtonWithTitle:@"Explore Social Network Posts"   andSelector:@selector(onExploreSocialNetworkPosts)];
	[self addButtonWithTitle:@"Explore Cloud Storage"          andSelector:@selector(onExploreCloudStorage)];
	[self addButtonWithTitle:@"Explore Current User"           andSelector:@selector(onExploreUser)];
	[self addButtonWithTitle:@"Explore Invites"                andSelector:@selector(onExploreInvites)];
	[self addButtonWithTitle:@"Explore Featured Games"         andSelector:@selector(onExploreFeaturedGames)];
	[self addButtonWithTitle:@"Explore Announcements"          andSelector:@selector(onExploreAnnouncements)];
	[self addButtonWithTitle:@"Explore Launch Dashboard Pages" andSelector:@selector(onExploreLaunchDashboardPages)];
	[self addButtonWithTitle:@"Explore Game Center"            andSelector:@selector(onExploreGameCenterLeaderboard)];
	[self addButtonWithTitle:@"Explore GC Achievements"        andSelector:@selector(onExploreGameCenterAchievements)];
	[self addButtonWithTitle:@"Explore Scores Near Me"		   andSelector:@selector(onExploreScoresNearMe)];
	[self addButtonWithTitle:@"Print Server Timestamp"         andSelector:@selector(onPrintTimestamp)];
    [self addButtonWithTitle:@"Switch Game Feed"                andSelector:@selector(onSwitchGameFeed)];
    [self addButtonWithTitle:@"Refresh Game Feed"               andSelector:@selector(onRefreshGameFeed)];
    [self addButtonWithTitle:@"Switch Customize Game Feed"      andSelector:@selector(onSwitchGameFeedCustomization)];
//This comment is needed because there is a problem with the #ifdef OF_INTERNAL striping out one character between #ifdef OF_INTERNAL
//Developers can safely ignore this comment.

	
#ifdef __IPHONE_4_1
	gameCenterCommonDelegate = [[GameCenterCommonDelegate alloc] init];
#endif

    [self addBadgeCount];
    
	[OFTimeStamp setDelegate:self];
	
	mScrollView.contentSize = [mScrollView sizeThatFitsTight];
	mScrollView.scrollEnabled = YES;
}

- (void)dealloc
{
#ifdef __IPHONE_4_1
	OFSafeRelease(gameCenterCommonDelegate);
#endif
	[OFTimeStamp setDelegate:nil];
    [mBadgeCountLabel release];
	self.view = nil;
    self.gameFeed = nil;
    self.customSettings = nil;
	[super dealloc];
}

- (IBAction) onLaunchDashboard
{
	[OpenFeint launchDashboard];
}

- (IBAction) onExploreChallenges
{
	[self _push:@"SendSampleChallenge"];

}

- (IBAction) onExploreLeaderboards
{
	[self _push:@"SampleLeaderboardList"];
}

- (IBAction) onExploreAchivements
{
	[self _push:@"SampleAchievementList"];
}

- (IBAction) onExploreSocialNetworkPosts
{
	[self _push:@"PostToSocialNetworkSample"];
}

- (IBAction) onExploreCloudStorage
{
	[self _push:@"CloudStorageDemo"];
}

- (IBAction) onExploreInvites
{
	[self _push:@"SampleInvite"];
}

- (IBAction) onExploreAnnouncements
{
	[self _push:@"SampleAnnouncement"];
}

- (IBAction) onExploreUser
{
	SampleUserViewController *controller = [[SampleUserViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (IBAction) onExploreFeaturedGames
{
	[self _push:@"SampleFeaturedGames"];
}

- (IBAction) onExploreLaunchDashboardPages
{
	[self _push:@"SampleLaunchDashbaordPages"];
}

- (IBAction) onExploreScoresNearMe
{
	[self _push:@"SampleScoresNearMe"];
}

- (IBAction) onExploreGameCenterLeaderboard 
{
#ifdef __IPHONE_4_1
    if([OpenFeint isUsingGameCenter] && [GKLocalPlayer localPlayer].authenticated) 
	{
        GKLeaderboardViewController *gkController = [GKLeaderboardViewController new];
        gkController.leaderboardDelegate = gameCenterCommonDelegate;
        [self.navigationController presentModalViewController:gkController animated:YES];
        [gkController release];
    }
#endif
}

- (IBAction) onExploreGameCenterAchievements 
{
#ifdef __IPHONE_4_1
    if([OpenFeint isUsingGameCenter] && [GKLocalPlayer localPlayer].authenticated) 
	{
        GKAchievementViewController *gkController = [GKAchievementViewController new];
        gkController.achievementDelegate = gameCenterCommonDelegate;
        [self.navigationController presentModalViewController:gkController animated:YES];
        [gkController release];
    }
#endif
}

- (IBAction) onWebUI {
    OFWebUIController *webui = [[[OFWebUIController alloc] initWithPath:@"debug/index"] autorelease];
    [self.navigationController presentModalViewController:webui animated:YES];
}


- (IBAction) onPrintTimestamp
{
	OFRequestHandle* handle = [OFTimeStamp getServerTime];
	if(!handle)
	{
		[[[[UIAlertView alloc] initWithTitle:@"No OpenFeint" message:@"You have not approved OpenFeint, or OpenFeint is disabled.  Your request will not process." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
		OFLog(@"Did not get request handle for OFTimeStamp's getServerTime");
	}
}

- (IBAction) onSwitchGameFeed
{
    if (!self.isGameFeedViewReady) {
        return;
    }
    [self switchGameFeed];
}

- (IBAction) onRefreshGameFeed
{
    if (!self.isGameFeedViewReady) {
        return;
    }
    [self.gameFeed refresh];
}

- (IBAction) onSwitchGameFeedCustomization
{
    if (!self.isGameFeedViewReady) {
        return;
    }

    [self removeGameFeed];

    if (self.customSettings == nil)
    {
       self.customSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIImage imageNamed:@"GameFeedBackgroundPortrait.png"], OFGameFeedSettingFeedBackgroundImagePortrait,
                                         [UIImage imageNamed:@"CellBackgroundPortrait.png"], OFGameFeedSettingCellBackgroundImagePortrait,
                                         [UIImage imageNamed:@"GameFeedHitPortrait.png"], OFGameFeedSettingCellHitImagePortrait,
                                         [UIImage imageNamed:@"CellBackgroundLandscape.png"], OFGameFeedSettingCellBackgroundImageLandscape,
                                         [UIImage imageNamed:@"GameFeedHitLandscape.png"], OFGameFeedSettingCellHitImageLandscape,
                                         [UIImage imageNamed:@"ProfileFrame.png"], OFGameFeedSettingProfileFrameImage,
                                         [UIImage imageNamed:@"CellDividerPortrait.png"], OFGameFeedSettingCellDividerImagePortrait,
                                         [UIImage imageNamed:@"GameFeedBackgroundLandscape.png"], OFGameFeedSettingFeedBackgroundImageLandscape,
                                         [UIImage imageNamed:@"CellDividerLandscape.png"], OFGameFeedSettingCellDividerImageLandscape,
                                         nil];
    }
    else
    {
        self.customSettings = nil;
    }
    [self setupGameFeed];
}


- (void)didGetServerTime:(OFTimeStamp*)timeStamp
{
	NSLog(@"Time: %@", timeStamp.time);
	NSLog(@"Seconds From Epoch: %d", timeStamp.secondsSinceEpoch);
}

- (void)didFailGetServerTime
{
	NSLog(@"Failed getting server time");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (self.gameFeed) {
        BOOL goingToPortrait = UIInterfaceOrientationIsPortrait(interfaceOrientation);
        BOOL OpenFeintDashboardIsPortrait = UIInterfaceOrientationIsPortrait([OpenFeint getDashboardOrientation]);
        if (goingToPortrait != OpenFeintDashboardIsPortrait)
        {
            return NO;
        }
    }

	const unsigned int numOrientations = 4;
	UIInterfaceOrientation myOrientations[numOrientations] = { UIInterfaceOrientationPortrait, UIInterfaceOrientationPortraitUpsideDown, UIInterfaceOrientationLandscapeLeft, UIInterfaceOrientationLandscapeRight };
	return [OpenFeint shouldAutorotateToInterfaceOrientation:interfaceOrientation withSupportedOrientations:myOrientations andCount:numOrientations];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[OpenFeint setDashboardOrientation:toInterfaceOrientation];
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

@end


#ifdef __IPHONE_4_1
@implementation GameCenterCommonDelegate

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController 
{
    [viewController dismissModalViewControllerAnimated:YES];
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController 
{
    [viewController dismissModalViewControllerAnimated:YES];
}
@end

#endif
