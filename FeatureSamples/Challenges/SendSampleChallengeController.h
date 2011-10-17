#pragma once

#import <UIKit/UIKit.h>
#import "OpenFeint/OFChallenge.h"
#import "OpenFeint/OFChallengeDefinition.h"

@class OFChallengeDefinition;
@class OFDefaultTextField;

@interface SendSampleChallengeController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, OFChallengeSendDelegate, OFChallengeDefinitionDelegate>
{
	IBOutlet UIPickerView* challengePicker;
	
	IBOutlet OFDefaultTextField* challengeText;

	IBOutlet OFDefaultTextField* challengeData;
	
	IBOutlet UILabel* newChallengesLabel;
	NSMutableArray* challengeDefs;
	OFChallengeDefinition* selectedChallenge;
}

- (IBAction)sendChallenge;

@end
