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
#import "OpenFeint/OFAchievement.h"

@class OFDefaultTextField;
@class OFImageView;

@interface SampleAchievementListController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, OFAchievementDelegate>
{
	IBOutlet UIPickerView* achievementPicker;
	
	IBOutlet UIView* contentView;
	
	IBOutlet UIImageView* iconView;
	IBOutlet UILabel* titleLabel;
	IBOutlet UILabel* descriptionLabel;
	IBOutlet UISwitch* showAchievementNotifications;
	IBOutlet UISwitch* isUnlocked;
	IBOutlet OFDefaultTextField* percentCompleteTextField;
	IBOutlet UILabel* isUnlockedLabel;
	IBOutlet UILabel* notificationsLabel;
	
	NSMutableArray* achievements;
	OFAchievement* selectedAchievement;
	OFRequestHandle* imageRequest;
}

- (IBAction)updateSelected;
- (IBAction)queueUpdate;
- (IBAction)submitQueued;
- (IBAction)syncGameCenter;

@end
