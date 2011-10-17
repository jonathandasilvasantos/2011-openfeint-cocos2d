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

#import "SampleScoresNearMeController.h"
#import "OpenFeint/UIView+OpenFeint.h"
#import "OpenFeint/OFLeaderboard.h"
#import "OpenFeint/OpenFeint.h"
#import "OpenFeint/OFDefaultTextField.h"
#import "OpenFeint/OFUser.h"
#import "OpenFeint/OFDependencies.h"

@implementation SampleScoresNearMe

@synthesize leaderboardPicker, amountBelowTextField, amountAboveTextField;

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.amountBelowTextField.manageScrollViewOnFocus = NO;
	self.amountBelowTextField.closeKeyboardOnReturn = YES;

	self.amountAboveTextField.manageScrollViewOnFocus = NO;
	self.amountAboveTextField.closeKeyboardOnReturn = YES;
}

- (void)closeKeyboard
{
	[self.amountBelowTextField resignFirstResponder];
	[self.amountAboveTextField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	UIScrollView* scrollView = [self.view findFirstScrollView];
	scrollView.contentSize = [scrollView sizeThatFitsTight];
	
	// Get ready to work with leaderboards.
	leaderboards = [[OFLeaderboard leaderboards] retain];
	[self.leaderboardPicker reloadAllComponents];
	[self pickerView:self.leaderboardPicker  didSelectRow:[self.leaderboardPicker selectedRowInComponent:0] inComponent:0];
}

- (void)viewDidAppear:(BOOL)animated
{
	[OFHighScore setDelegate:self];
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	// This class must relinquish it's role as leaderboard delegate.
	[OFHighScore setDelegate:nil];
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

- (IBAction)showScores
{
	uint aboveCount = 0;
	uint belowCount = 0;
	if(amountAboveTextField.text != nil && ![amountAboveTextField.text isEqualToString:@""])
	{
		aboveCount = [amountAboveTextField.text intValue];
	}
	
	if(amountBelowTextField.text != nil && ![amountBelowTextField.text isEqualToString:@""])
	{
		belowCount = [amountBelowTextField.text intValue];
	}
	
	OFRequestHandle* handle = [OFHighScore getHighScoresNearCurrentUserForLeaderboard:selectedLeaderboard andBetterCount:aboveCount	andWorseCount:belowCount];
	
	if(!handle)
	{
		[[[[UIAlertView alloc] initWithTitle:@"No OpenFeint" message:@"You have not approved OpenFeint, or OpenFeint is disabled.  Your request will not process." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
		OFLog(@"Did not get request handle for OFHighScores's getHighScoresNearCurrentUserForLeaderboard:andBetterCount:andWorseCount:");
	}
}

- (void)didGetHighScoresNearCurrentUser:(NSArray*)scores
{
	for(uint i = 0; i < scores.count; i++)
	{
		OFHighScore* score = (OFHighScore*)[scores objectAtIndex:i];
		NSLog(@"User:%@  Rank:%d  Score:%lld", score.user.name, score.rank, score.score);
	}
}

- (void)didFailGetHighScoresNearCurrentUser
{
	NSLog(@"Failed to get scores near the current user");
}

- (void)dealloc
{
	self.leaderboardPicker = nil;
	OFSafeRelease(leaderboards);
	[super dealloc];
}


//- (void)didGetHighScoresNearCurrentUser:(NSArray*)scores;

#pragma mark UIPickerViewDataSource / UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	if (leaderboards)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (leaderboards)
	{
		return [leaderboards count];
	}
	else
	{
		return 0;
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (leaderboards)
	{
		OFLeaderboard* curLeaderboard = (OFLeaderboard*)[leaderboards objectAtIndex:row];
		return curLeaderboard.name;
	}
	else
	{
		return @"";
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSInteger numLeaderboards = (NSInteger)[leaderboards count];
	if (leaderboards && numLeaderboards > row && row >= 0)
	{
		OFLeaderboard* leaderboard = (OFLeaderboard*)[leaderboards objectAtIndex:row];
		selectedLeaderboard = [leaderboard retain];
	}
	else
	{
		OFSafeRelease(selectedLeaderboard);
	}
	[self closeKeyboard];
}

@end
