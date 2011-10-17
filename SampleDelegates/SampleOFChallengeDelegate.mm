#import "SampleOFChallengeDelegate.h"
#import "PlayAChallengeController.h"
#import "AppDelegate.h"

#import "OpenFeint/OFChallengeToUser.h"
#import "OpenFeint/OFChallenge.h"
#import "OpenFeint/OFChallengeDefinition.h"
#import "OpenFeint/OFControllerLoaderObjC.h"
#import "OpenFeint/OFDependencies.h"

@implementation SampleOFChallengeDelegate

- (void)userLaunchedChallenge:(OFChallengeToUser*)challengeToLaunch withChallengeData:(NSData*)challengeData
{
	OFLog(@"Launched Challenge: %@", challengeToLaunch.challenge.challengeDefinition.title);
	PlayAChallengeController* controller = (PlayAChallengeController*)[[OFControllerLoaderObjC loader] load:@"PlayAChallenge"];
	[controller setChallenge:challengeToLaunch];
	[controller setData:challengeData];
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];	
//	[appDelegate.rootController pushViewController:controller animated:YES];
}

- (void)userRestartedChallenge
{
	OFLog(@"Ignoring challenge restart.");
}

@end
