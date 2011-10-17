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

#import "PostToSocialNetworkSampleController.h"

#import "OpenFeint/UIView+OpenFeint.h"
#import "OpenFeint/OFDefaultTextField.h"

#import "OpenFeint/OpenFeint.h"
#import "OpenFeint/OFDependencies.h"

static BOOL overrideAllAchievementBrag = NO;
static BOOL overrideOneAchievementBrag = NO;
static BOOL overrideOneScoreBrag = NO;

@implementation PostToSocialNetworkSampleController

+ (BOOL)shouldOverrideAllAchievementBrag
{
	return overrideAllAchievementBrag;
}

+ (BOOL)shouldOverrideOneAchievementBrag
{
	return overrideOneAchievementBrag;
}

+ (BOOL)shouldOverrideOneScoreBrag
{
	return overrideOneScoreBrag;
}

- (void)didSendSocialNotification
{
	NSLog(@"Successfully requested Server to Post Social notification!");
}

- (void)didFailSendSocialNotification
{
	NSLog(@"Failed requesting Server to Post Social notification, or server failed to process information to post social notification!");
}

- (void)didCheckConnectedToSocialNetwork:(BOOL)connected
{
	NSString* buttonTitle = @"";

	buttonTitle = @"Post to Social Network(s)";
	postButton.enabled = YES;
	
	[postButton setTitle:buttonTitle forState:UIControlStateNormal];
	[postButton setTitle:buttonTitle forState:UIControlStateHighlighted];
	[postButton setTitle:buttonTitle forState:UIControlStateDisabled];
	[postButton setTitle:buttonTitle forState:UIControlStateSelected];
	
	[loadingView removeFromSuperview];
	OFSafeRelease(loadingView);
}

- (void)didFailCheckConnectedToSocialNetwork
{
	[[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed determine which social networks you are linked with. Disabling social network posting." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
	postButton.enabled = NO;

	[loadingView removeFromSuperview];
	OFSafeRelease(loadingView);
}

- (void)awakeFromNib
{
	messageField.closeKeyboardOnReturn = YES;
	originalMessageField.closeKeyboardOnReturn = YES;
	imageNameField.closeKeyboardOnReturn = YES;
	customUrlField.closeKeyboardOnReturn = YES;
	
	//imageNameField.manageScrollViewOnFocus = YES;
	customUrlField.manageScrollViewOnFocus = YES;
	[OFSocialNotificationApi setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[OFCurrentUser setDelegate:self];
	
	UIScrollView* scrollView = [self.view findFirstScrollView];
	scrollView.contentSize = [scrollView sizeThatFitsTight];

	postButton.enabled = NO;

	CGRect frame = CGRectZero;
	frame.size = self.view.bounds.size;
	loadingView = [[UIView alloc] initWithFrame:frame];
	[loadingView setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.75f]];
	UIActivityIndicatorView* spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	[spinner setCenter:CGPointMake(frame.size.width * 0.5f, frame.size.height * 0.5f)];
	[spinner startAnimating];	
	[loadingView addSubview:spinner];
	[self.view addSubview:loadingView];

	[OFCurrentUser checkConnectedToSocialNetwork];
	
	overrideBragEachAchievementSwitch.on = overrideOneAchievementBrag;
	overrideBragAllAchievementSwitch.on = overrideAllAchievementBrag;
	overrideBragHighScoreSwitch.on = overrideOneScoreBrag;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[OFCurrentUser setDelegate:nil];
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

- (IBAction)post
{
	if ([messageField.text length] == 0)
		return;
	
	NSString* originalMessage = nil;
	if(originalMessageField.text != @"")
	{
		originalMessage = originalMessageField.text;
	}
	
	[OFSocialNotificationApi setCustomUrl:customUrlField.text];
	[OFSocialNotificationApi sendWithPrepopulatedText:messageField.text originalMessage:originalMessage imageNamed:imageNameField.text];
}

-(IBAction)bragAllAchievementValueChanged
{
	overrideAllAchievementBrag = overrideBragAllAchievementSwitch.on;
}

-(IBAction)bragEachAchievementValueChanged
{
	overrideOneAchievementBrag = overrideBragEachAchievementSwitch.on;
}

-(IBAction)bragHighScoreValueChanged
{
	overrideOneScoreBrag = overrideBragHighScoreSwitch.on;
}

- (void)dealloc
{
	OFSafeRelease(messageField);
	OFSafeRelease(originalMessageField);
	OFSafeRelease(imageNameField);
	OFSafeRelease(customUrlField);
	OFSafeRelease(postButton);
	OFSafeRelease(loadingView);
	[OFSocialNotificationApi setDelegate:nil];
	[super dealloc];
}

@end
