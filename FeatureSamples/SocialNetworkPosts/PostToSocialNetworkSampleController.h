//  Copyright 2009-2010 Aurora Feint, Inc.
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  	http://www.apache.org/licenses/LICENSE-2.0
//  	
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <UIKit/UIKit.h>
#import "OpenFeint/OFCurrentUser.h"
#import "OpenFeint/OFSocialNotificationApi.h"

@class OFDefaultTextField;

@interface PostToSocialNetworkSampleController : UIViewController<OFCurrentUserDelegate, OFSocialNotificationApiDelegate>
{
	IBOutlet OFDefaultTextField* messageField;
	IBOutlet OFDefaultTextField* imageNameField;
	IBOutlet OFDefaultTextField* customUrlField;
	IBOutlet OFDefaultTextField* originalMessageField;
	IBOutlet UISwitch* overrideBragAllAchievementSwitch;
	IBOutlet UISwitch* overrideBragEachAchievementSwitch;
	IBOutlet UISwitch* overrideBragHighScoreSwitch;

	IBOutlet UIButton* postButton;
	
	UIView* loadingView;
}

+ (BOOL)shouldOverrideAllAchievementBrag;
+ (BOOL)shouldOverrideOneAchievementBrag;
+ (BOOL)shouldOverrideOneScoreBrag;

- (IBAction)post;

-(IBAction)bragAllAchievementValueChanged;
-(IBAction)bragEachAchievementValueChanged;
-(IBAction)bragHighScoreValueChanged;

@end
