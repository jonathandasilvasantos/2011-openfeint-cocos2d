#import "SampleOFBragDelegate.h"
#import "PostToSocialNetworkSampleController.h"

@implementation SampleOFBragDelegate

- (void)bragAboutAchievement:(OFAchievement*)achievement overrideStrings:(OFBragDelegateStrings*) overrideStrings
{
	if([PostToSocialNetworkSampleController shouldOverrideOneAchievementBrag])
	{
		overrideStrings->prepopulatedText = @"I could write something flavorful and interesting here for bragging about a single achievement";
		overrideStrings->originalMessage = @"Suggested Text To Send";
	}
}

- (void)bragAboutAllAchievementsWithTotal:(int)total unlockedAmount:(int)unlockedAmount overrideStrings:(OFBragDelegateStrings*) overrideStrings
{
	if([PostToSocialNetworkSampleController shouldOverrideAllAchievementBrag])
	{
		overrideStrings->prepopulatedText = @"I could write something flavorful and interesting here for bragging about all achievements";
		overrideStrings->originalMessage = @"Suggested Text To Send";
	}
}

- (void)bragAboutHighScore:(OFHighScore*)highScore onLeaderboard:(OFLeaderboard*)leaderboard overrideStrings:(OFBragDelegateStrings*) overrideStrings
{
	if([PostToSocialNetworkSampleController shouldOverrideOneScoreBrag])
	{
		overrideStrings->prepopulatedText = @"I could write something flavorful and interesting here for bragging about a HighScore";
		overrideStrings->originalMessage = @"Suggested Text To Send";
	}
}

@end
