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

#import "SampleAchievementListController.h"

#import "OpenFeint/OFImageView.h"
#import "OpenFeint/UIView+OpenFeint.h"
#import "OpenFeint/OFDefaultTextField.h"

#import "OpenFeint/OpenFeint.h"
#import "OpenFeint/OFDependencies.h"

//You shouldn't have to include this, this is just used to switch off our text field box.  If the user declines OpenFeint, but the app still wants to update
//GameCenter, then we need to know if we can bootstrap and get the achievements from the server, or if we need to rely on the developer to give us the OF achievement ids.
#import "OpenFeint/OpenFeint+UserOptions.h"
#import "OpenFeint/OpenFeint+GameCenter.h"

@interface SampleAchievementListController (Private)
- (void)_reloadAllData;
@end

@implementation SampleAchievementListController

- (void)didSubmitDeferredAchievements
{
	NSLog(@"Successfully submitted defered achievements!"); 
}

- (void)didFailSubmittingDeferredAchievements
{
	NSLog(@"Failed submitting some or all defered achievements!"); 
}

- (void)didUpdateProgressionCompleteOFAchievement:(OFAchievement*)achievement
{
	NSLog(@"successfully submitted achievement");
	[self _reloadAllData];
}

- (void)didFailUpdateProgressionCompleteOFAchievement:(OFAchievement*)achievement
{
	NSLog(@"Failed to submit achievement");
}

- (void)didGetIcon:(UIImage*)image OFAchievement:(OFAchievement*)achievement
{
	imageRequest = nil;
	if(achievement == selectedAchievement)
	{
		iconView.image = image;
		[iconView setNeedsDisplay];
	}
}

- (void)didFailGetIconOFAchievement:(OFAchievement*)achievement
{
	imageRequest = nil;
	NSLog(@"Failed to get icon image");
}

- (void)_updateUIWithAchievement:(OFAchievement*)achievement animated:(BOOL)animated
{
	titleLabel.text = achievement.title;
	descriptionLabel.text = achievement.description;
	[isUnlocked setOn:achievement.isUnlocked animated:animated];
	
	if(imageRequest)
	{
		[imageRequest cancel];
	}
	iconView.image = nil;
	[iconView setNeedsDisplay];
	imageRequest = [achievement getIcon];
	
	if(!imageRequest)
	{
		OFLog(@"Did not get request handle for OFAchievement's getIcon");
	}
}

- (void)_reloadAllData
{
	[achievements removeAllObjects];
	
	[achievements addObjectsFromArray:[OFAchievement achievements]];

	[achievementPicker reloadAllComponents];
	if ([achievements count] > 0)
	{
		//On reload don't animate the switch.  If we do animated it, it could cause it not to turn over because we might just be switching to this controller right now.
		selectedAchievement = [[achievements objectAtIndex:0] retain];
		[self _updateUIWithAchievement:selectedAchievement animated:NO];
		[achievementPicker selectRow:0 inComponent:0 animated:YES];
	}
	
	for (OFAchievement* achievement in achievements)
	{
		OFAchievement* realAch = [OFAchievement achievement:achievement.resourceId];
		NSLog(@"Achievement: %@, %d, unlocked? %@", realAch.title, realAch.gamerscore, realAch.isUnlocked ? @"YES" : @"NO");
	}

}

- (void)awakeFromNib
{
	percentCompleteTextField.closeKeyboardOnReturn = YES;
	
	achievements = [[NSMutableArray arrayWithCapacity:25] retain];
	[OFAchievement setDelegate:self];
	
	percentCompleteTextField.closeKeyboardOnReturn = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	UIScrollView* scrollView = [self.view findFirstScrollView];
	scrollView.contentSize = [scrollView sizeThatFitsTight];

	[self _reloadAllData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	const unsigned int numOrientations = 4;
	UIInterfaceOrientation myOrientations[numOrientations] = { UIInterfaceOrientationPortrait, UIInterfaceOrientationLandscapeLeft, UIInterfaceOrientationLandscapeRight, UIInterfaceOrientationPortraitUpsideDown };
	return [OpenFeint shouldAutorotateToInterfaceOrientation:interfaceOrientation withSupportedOrientations:myOrientations andCount:numOrientations];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[OpenFeint setDashboardOrientation:self.interfaceOrientation];
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)dealloc
{
	OFSafeRelease(iconView);
	OFSafeRelease(achievementPicker);
	OFSafeRelease(achievements);
	OFSafeRelease(selectedAchievement);
	OFSafeRelease(titleLabel);
	OFSafeRelease(descriptionLabel);
	OFSafeRelease(isUnlocked);
	OFSafeRelease(contentView);
	OFSafeRelease(percentCompleteTextField);
	[OFAchievement setDelegate:nil];
	[super dealloc];
}

- (IBAction)updateSelected
{
	OFRequestHandle* handle = nil;
	
	if(percentCompleteTextField.text == nil || [percentCompleteTextField.text isEqualToString:@""])
	{
		[[[[UIAlertView alloc] initWithTitle:@"Invalid Percent" message:@"You must input a percent to update this achievement with." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
		return;
	}
	double percentComplete = [percentCompleteTextField.text doubleValue];

	if (selectedAchievement)
	{
		[OFAchievement setCustomUrlForSocialNotificaion:@"http://openfeint.com"];
		handle = [selectedAchievement updateProgressionComplete:percentComplete andShowNotification:showAchievementNotifications.on];
	}
	
	if(!handle)
	{
		OFLog(@"Did not get request handle for OFAchievement's updateProgressionComplete:andShowNotification:");
	}
}

- (IBAction)queueUpdate
{
	if(percentCompleteTextField.text == nil || [percentCompleteTextField.text isEqualToString:@""])
	{
		[[[[UIAlertView alloc] initWithTitle:@"Invalid Percent" message:@"You must input a percent to update this achievement with." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
		return;
	}
	double percentComplete = [percentCompleteTextField.text doubleValue];
	
	if (selectedAchievement)
	{
		[selectedAchievement deferUpdateProgressionComplete:percentComplete andShowNotification:showAchievementNotifications.on];
		[self _reloadAllData];
	}
}

- (IBAction)submitQueued
{
	OFRequestHandle* handle = [OFAchievement submitDeferredAchievements];
	
	if(!handle)
	{
		OFLog(@"Did not get request handle for OFAchievement's submitDeferredAchievements");
	}
}

- (IBAction)syncGameCenter
{
	[OFAchievement forceSyncGameCenterAchievements];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return achievements ? 1 : 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [achievements count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if ((NSInteger)[achievements count] <= row)
		return @"";
		
	OFAchievement* achievement = (OFAchievement*)[achievements objectAtIndex:row];
	return achievement.title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSInteger numAchievements = (NSInteger)[achievements count];
	OFSafeRelease(selectedAchievement);
	if (achievements && numAchievements > row && row >= 0)
	{
		selectedAchievement = [(OFAchievement*)[achievements objectAtIndex:row] retain];
		[self _updateUIWithAchievement:selectedAchievement animated:YES];
	}
}

@end
