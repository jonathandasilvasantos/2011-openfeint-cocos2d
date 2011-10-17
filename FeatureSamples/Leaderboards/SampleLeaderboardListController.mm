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

#import "SampleLeaderboardListController.h"
#import "OpenFeint/OpenFeint.h"
#import "OpenFeint/OFHighScoreService.h"
#import "OpenFeint/OFLeaderboardService.h"
#import "OpenFeint/OFLeaderboard.h"
#import "OpenFeint/UIView+OpenFeint.h"
#import "OpenFeint/OpenFeint+Dashboard.h"
#import "OpenFeint/OFControllerLoaderObjC.h"
#import "SampleLeaderboardViewController.h"
#import "OpenFeint/OFLeaderboard.h"
#import "OpenFeint/OFDependencies.h"


@implementation SampleLeaderboardListController

@synthesize leaderboardPicker, highScoreTextField, displayTextTextField, customDataTextField, blobTextField, submitButton, batchButton, submitToAll;

- (void)didSubmit:(OFHighScore *)score
{
	OFLog(@"successfully submitted high score");
}

- (void)didFailSubmit:(OFHighScore *)score
{
	OFLog(@"failed submitting high score");
}

- (void)closeKeyboard
{
	[self.highScoreTextField resignFirstResponder];
	[self.displayTextTextField resignFirstResponder];
	[self.customDataTextField resignFirstResponder];
	[self.blobTextField resignFirstResponder];
}

- (void)disableCloseKbdButton
{
	[self.navigationItem.rightBarButtonItem setEnabled:NO];
}

- (void)enableCloseKbdButton
{
	[self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void)awakeFromNib
{
	self.highScoreTextField.manageScrollViewOnFocus = NO;
	self.highScoreTextField.closeKeyboardOnReturn = YES;
	
	self.displayTextTextField.manageScrollViewOnFocus = NO;
	self.displayTextTextField.closeKeyboardOnReturn = YES;

	self.customDataTextField.manageScrollViewOnFocus = NO;
	self.customDataTextField.closeKeyboardOnReturn = YES;
	
	self.blobTextField.manageScrollViewOnFocus = NO;
	self.blobTextField.closeKeyboardOnReturn = YES;
	
	self.leaderboardPicker.delegate = self;
	self.leaderboardPicker.dataSource = self;
	
	[self disableCloseKbdButton];
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"SampleLeaderboardListController viewWillAppear");
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
	NSLog(@"SampleLeaderboardListController viewDidAppear");
	[OFHighScore setDelegate:self];
	[OFLeaderboard setDelegate:self];
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	NSLog(@"SampleLeaderboardListController viewWillDisappear");
	[super viewWillDisappear:animated];

	// This class must relinquish it's role as leaderboard delegate.
	[OFLeaderboard setDelegate:nil];
	[OFHighScore setDelegate:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@"SampleLeaderboardListController viewDidDisappear");
	[super viewDidDisappear:animated];
}

- (IBAction)setHighScore:(id)button
{
	NSMutableArray* leaderboardsToSubmit = [NSMutableArray arrayWithCapacity:[leaderboards count]];
	if (button == self.submitButton && selectedLeaderboard)
	{
		[leaderboardsToSubmit addObject:selectedLeaderboard];
	}
	else if (button == self.submitToAll)
	{
		for (OFLeaderboard* l in leaderboards)
			[leaderboardsToSubmit addObject:l];
	}

	NSNumber* num = [NSNumber numberWithLongLong:[self.highScoreTextField.text longLongValue]];
	NSString* displayText = self.displayTextTextField.text;	
	NSString* customData = self.customDataTextField.text;
	NSString* blobText = self.blobTextField.text;

	OFHighScore* score = [[[OFHighScore alloc] initForSubmissionWithScore:[num longLongValue]] autorelease];
	score.displayText = displayText;
	score.customData = customData;
	score.blob = ([blobText length] > 0 ? [NSData dataWithBytes:[blobText UTF8String] length:[blobText length]] : nil);

	for (OFLeaderboard* l in leaderboardsToSubmit)
	{
		[score submitTo:l];
	}
	
	[self closeKeyboard];
}

- (IBAction)openLeaderboard
{
	if (selectedLeaderboard)
	{
		[self closeKeyboard];

		SampleLeaderboardViewController* next = (SampleLeaderboardViewController*)[[OFControllerLoaderObjC loader] load:@"SampleLeaderboardView"];// load(@"SampleLeaderboardView");
		next.leaderboard = selectedLeaderboard;
		[[self navigationController] pushViewController:next animated:YES];
	}
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
	self.leaderboardPicker = nil;
	self.highScoreTextField = nil;
	self.displayTextTextField = nil;
	self.customDataTextField = nil;
	self.blobTextField = nil;
	self.submitButton = nil;
	self.batchButton = nil;
	self.submitToAll = nil;
	OFSafeRelease(leaderboards);
	[super dealloc];
}

#pragma mark OFLeaderboardAPIDelegate



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
