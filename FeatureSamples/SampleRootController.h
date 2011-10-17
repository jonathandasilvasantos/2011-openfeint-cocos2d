#import "OpenFeint/OFTimeStamp.h"
#import "OpenFeint/OFGameFeedSettings.h"

#ifdef __IPHONE_4_1
#import "GameKit/GKLeaderboardViewController.h"
#import "GameKit/GKAchievementViewController.h"

@class GameCenterCommonDelegate;
#endif

@interface SampleRootController : UIViewController<OFTimeStampDelegate>
{
#ifdef __IPHONE_4_1
	GameCenterCommonDelegate* gameCenterCommonDelegate;
#endif
	float mFillY;
    UIScrollView* mScrollView;
    UILabel* mBadgeCountLabel;
}
@property(nonatomic, readonly) UIScrollView* scrollView;
@property(nonatomic) BOOL isGameFeedViewReady;
- (IBAction) onExploreLeaderboards;
- (IBAction) onExploreAchivements;
- (IBAction) onExploreSocialNetworkPosts;
- (IBAction) onExploreCloudStorage;
- (IBAction) onExploreInvites;
- (IBAction) onExploreAnnouncements;
- (IBAction) onExploreUser;
- (IBAction) onExploreFeaturedGames;
- (IBAction) onExploreGameCenterLeaderboard;
- (IBAction) onExploreGameCenterAchievements;
- (IBAction) onLaunchDashboard;
- (IBAction) onExploreChallenges;
- (IBAction) onExploreLaunchDashboardPages;
- (IBAction) onWebUI;
- (IBAction) onPrintTimestamp;
- (IBAction) onExploreScoresNearMe;
- (IBAction) onSwitchGameFeed;
- (IBAction) onRefreshGameFeed;
- (IBAction) onSwitchGameFeedCustomization;

- (void)setupGameFeed;
@end


#ifdef __IPHONE_4_1
@interface GameCenterCommonDelegate : NSObject<GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate>
@end
#endif
