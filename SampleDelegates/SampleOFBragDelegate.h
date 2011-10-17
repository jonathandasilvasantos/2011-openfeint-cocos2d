#pragma once

#import "OpenFeint/OFBragDelegate.h"

@interface SampleOFBragDelegate : NSObject< OFBragDelegate >


- (void)bragAboutAchievement:(OFAchievement*)achievement overrideStrings:(OFBragDelegateStrings*) overrideStrings;
- (void)bragAboutAllAchievementsWithTotal:(int)total unlockedAmount:(int)unlockedAmount overrideStrings:(OFBragDelegateStrings*) overrideStrings;
- (void)bragAboutHighScore:(OFHighScore*)highScore onLeaderboard:(OFLeaderboard*)leaderboard overrideStrings:(OFBragDelegateStrings*) overrideStrings;
@end
