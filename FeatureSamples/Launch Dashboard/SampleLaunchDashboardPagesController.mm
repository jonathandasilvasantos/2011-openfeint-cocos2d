#import "SampleLaunchDashboardPagesController.h"

#import "OpenFeint/OFControllerLoaderObjC.h"
#import "OpenFeint/UIView+OpenFeint.h"
#import "OpenFeint/OpenFeint.h"
#import "OpenFeint/OpenFeint+Dashboard.h"
#import "OpenFeint/OpenFeint+UserOptions.h"

@implementation SampleLaunchDashboardPagesController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[OFUser setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated 
{
	[OFUser setDelegate:nil];
	
	[super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	xTextField.closeKeyboardOnReturn = YES;
	yTextField.closeKeyboardOnReturn = YES;
	
	UIScrollView* scroll = [self.view findFirstScrollView];
	scroll.contentSize = [self.view sizeThatFitsTight];
}

- (void)dealloc
{
	[super dealloc];
}

- (IBAction) onLaunchLeaderboardPage
{
	[OpenFeint launchDashboardWithListLeaderboardsPage];
}

- (IBAction) onLaunchHighScorePage
{
	if(!xTextField.text || [xTextField.text isEqualToString:@""])
	{
		[[[[UIAlertView alloc]
		   initWithTitle:@"Invalid Params"
		   message:@"Required Params:\nX - Leaderboard Id"
		   delegate:nil
		   cancelButtonTitle:@"OK"
		   otherButtonTitles:nil] autorelease] show];
		return;
	}
	[OpenFeint launchDashboardWithHighscorePage:xTextField.text];
}

- (IBAction) onLaunchAchievementPage
{
	[OpenFeint launchDashboardWithAchievementsPage];
}

- (IBAction) onLaunchChallengePage
{
	[OpenFeint launchDashboardWithChallengesPage];
}

- (IBAction) onLaunchFindFriendsPage
{
	[OpenFeint launchDashboardWithFindFriendsPage];
}

- (IBAction) onLaunchWhosPlayingPage
{
	[OpenFeint launchDashboardWithWhosPlayingPage];
}

- (IBAction) onLaunchListGlobalChatRoomsPage
{
	[OpenFeint launchDashboardWithListGlobalChatRoomsPage];
}

- (IBAction) onLaunchiPurchasePage
{
	[OpenFeint launchDashboardWithiPurchasePage:[OpenFeint clientApplicationId]];
}

- (IBAction) onLaunchSwitchUserPage
{
	[OpenFeint launchDashboardWithSwitchUserPage];
}

- (IBAction) onLaunchForumsPage
{
	[OpenFeint launchDashboardWithForumsPage];
}

- (IBAction) onLaunchInvitePage
{
	[OpenFeint launchDashboardWithInvitePage];
}

- (IBAction) onLaunchSpecificInvitePage
{
	if(!xTextField.text || [xTextField.text isEqualToString:@""])
	{
		[[[[UIAlertView alloc]
		   initWithTitle:@"Invalid Params"
		   message:@"Required Params:\nX - Invite Def Id"
		   delegate:nil
		   cancelButtonTitle:@"OK"
		   otherButtonTitles:nil] autorelease] show];
		return;
	}
	[OpenFeint launchDashboardWithSpecificInvite:xTextField.text];
}

- (IBAction) onLaunchIMToUserPage
{
	if(!xTextField.text || [xTextField.text isEqualToString:@""] || !yTextField.text || [yTextField.text isEqualToString:@""])
	{
		[[[[UIAlertView alloc]
		   initWithTitle:@"Invalid Params"
		   message:@"Required Params:\nX - user id\nY - Initial IM"
		   delegate:nil
		   cancelButtonTitle:@"OK"
		   otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	[OFUser getUser:xTextField.text];
}

- (IBAction) onLaunchMoreGamesPage
{
	[OpenFeint launchDashboardWithMoreGamesPage];
}

- (void)didGetUser:(OFUser*)user
{
	if(user)
	{
		[OpenFeint launchDashboardWithIMToUser:user initialText:yTextField.text];
	}
}

- (void)didFailGetUser
{
	[[[[UIAlertView alloc]
	   initWithTitle:@"Invalid User"
	   message:@"The User could not be found, or the server was unreachable."
	   delegate:nil
	   cancelButtonTitle:@"OK"
	   otherButtonTitles:nil] autorelease] show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
