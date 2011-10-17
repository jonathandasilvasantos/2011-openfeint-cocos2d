#import <UIKit/UIKit.h>
#import "OpenFeint/OFDefaultTextField.h"
#import "OpenFeint/OFUser.h"


@interface SampleLaunchDashboardPagesController : UIViewController<OFUserDelegate>
{
	IBOutlet OFDefaultTextField* xTextField;
	IBOutlet OFDefaultTextField* yTextField;
}

- (IBAction) onLaunchLeaderboardPage;
- (IBAction) onLaunchHighScorePage;
- (IBAction) onLaunchAchievementPage;
- (IBAction) onLaunchChallengePage;
- (IBAction) onLaunchFindFriendsPage;
- (IBAction) onLaunchWhosPlayingPage;
- (IBAction) onLaunchListGlobalChatRoomsPage;
- (IBAction) onLaunchiPurchasePage;
- (IBAction) onLaunchSwitchUserPage;
- (IBAction) onLaunchForumsPage;
- (IBAction) onLaunchInvitePage;
- (IBAction) onLaunchSpecificInvitePage;
- (IBAction) onLaunchIMToUserPage;
- (IBAction) onLaunchMoreGamesPage;

@end

