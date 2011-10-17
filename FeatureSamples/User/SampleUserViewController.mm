//
//  SampleUserViewController.m
//  OpenFeint
//
//  Created by Danilo Campos on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SampleUserViewController.h"

#import "OpenFeint/OpenFeint+Dashboard.h"
#import "OpenFeint/UIButton+OpenFeint.h"
#import "OpenFeint/OFCurrentUser.h"
#import "OpenFeint/OFDependencies.h"

@implementation SampleUserViewController

@synthesize selectedUser;
@synthesize	friends;
@synthesize friendsWithThisApp;
@synthesize selectedUserImage;
@synthesize friendButton;
@synthesize imButton;

enum Sections {
	kUserInfo = 0,
	kFriends,
	kFriendsWithThisApp,
	NUM_SECTIONS
};

enum UserInfoSection {
	kNameRow = 0,
	kLastGameIDRow,
	kLastGameNameRow,
	kGamerScoreRow,
	kFollowsLocalUserRow,
	kOnlineRow,
	kUserIDRow,
	NUM_USER_ROWS
};


#pragma mark -
#pragma mark Custom Methods

- (void)displayCurrentUserHeader
{
	UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 75)];
	header.font = [UIFont systemFontOfSize:12];
	
	header.numberOfLines = 0;
	
	NSString *currentUserStats = [NSString stringWithFormat:@" Has friends: %@ \n Unviewed challenges: %i \n Allows auto social notifications: %@ \n OpenFeintBadgeCount: %i",
								  [OFCurrentUser hasFriends] ? @"YES" : @"NO",
								  [OFCurrentUser unviewedChallengesCount],
								  [OFCurrentUser allowsAutoSocialNotifications] ? @"YES" : @"NO",
								  [OFCurrentUser OpenFeintBadgeCount]];
	
	header.text = currentUserStats;
	
	self.tableView.tableHeaderView = header;
}

- (void)updateFriendButton
{
	NSString *labelText;
	
	if ([selectedUser followedByLocalUser])
	{
		labelText = @"De-Friend";
	}
	
	else {
		
		labelText = @"Add Friend";
	}
	
	[friendButton setTitle:labelText forState:UIControlStateNormal];
}

- (void)userToggledFriend:(UIButton *)sender
{
	if ([selectedUser followedByLocalUser])
	{
		[OFCurrentUser unfriend:selectedUser];
	}
	else 
	{
		[OFCurrentUser sendFriendRequest:selectedUser];
	}
}

- (void)sendImToUser:(UIButton*)sender
{
	[OpenFeint launchDashboardWithIMToUser:selectedUser initialText:@"Just saying Hi!"];
}

- (void)displayOtherUserHeader
{
	UIView* header = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 88.f + 30.f)] autorelease];
	
	self.friendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	friendButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	friendButton.frame = CGRectMake(10, 10, self.view.frame.size.width - 20, 44);	
	[friendButton addTarget:self action:@selector(userToggledFriend:) forControlEvents:UIControlEventTouchUpInside];

	[self updateFriendButton];

	self.imButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[imButton setTitleForAllStates:@"Send IM"];
	imButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	imButton.frame = CGRectMake(10, 64, self.view.frame.size.width - 20, 44);	
	[imButton addTarget:self action:@selector(sendImToUser:) forControlEvents:UIControlEventTouchUpInside];
	
	[header addSubview:friendButton];
	[header addSubview:imButton];
	
	self.tableView.tableHeaderView = header;
}


#pragma mark -
#pragma mark OFUser Delegate Methods

- (void)didGetUser:(OFUser*)user
{
	self.selectedUser = user;
	
	if (friendButton)
	{
		[self updateFriendButton];
	}
}

- (void)didFailGetUser
{
	OFLog(@"Getting user failed");
}

- (void)didGetFriends:(NSArray*)follows OFUser:(OFUser*)user
{
	self.friends = follows;
	
	for (OFUser *user in friends)
	{
		OFLog(@"User name: %@",user.name);
	}
	
	[self.tableView reloadData];
}

- (void)didFailGetFriendsOFUser:(OFUser*)user
{
	OFLog(@"Getting friends failed");
}

- (void)didGetFriendsWithThisApplication:(NSArray*)follows OFUser:(OFUser*)user
{
	self.friendsWithThisApp = follows;
	
	[self.tableView reloadData];
}

- (void)didFailGetFriendsWithThisApplicationOFUser:(OFUser*)user
{
	OFLog(@"Getting friends with this app failed");
}

- (void)didGetProfilePicture:(UIImage*)image OFUser:(OFUser*)user
{
	self.selectedUserImage = image;
	
	NSIndexPath	*updateIndexPath = [NSIndexPath indexPathForRow:kNameRow inSection:kUserInfo];
	
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:updateIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didFailGetProfilePictureOFUser:(OFUser*)user
{
	OFLog(@"Getting profile picture for user %@ failed",user);
}

#pragma mark -
#pragma mark OFCurrentUser Delegate Methods

- (void)didUnfriend
{
	OFLog(@"Unfriending worked!");
	
	OFRequestHandle* handle = [OFUser getUser:[selectedUser userId]];
	
	if(!handle)
	{
		OFLog(@"Did not get request handle from OFUser's getUser:");
	}

}

- (void)didFailUnfriend
{
	OFLog(@"Unfriending failed :(");
}

- (void)didSendFriendRequest
{
	
	OFLog(@"Friending worked!");
	
	OFRequestHandle* handle = [OFUser getUser:[selectedUser userId]];
	
	if(!handle)
	{
		OFLog(@"Did not get request handle from OFUser's getUser:");
	}
}

- (void)didFailSendFriendRequest
{
	OFLog(@"Friending failed :(");
}



#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if ((self = [super initWithStyle:style])) {
 }
 return self;
 }
 */


#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
    [super viewDidLoad];


	
}




- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
	
	[OFUser setDelegate:self];
	[OFCurrentUser setDelegate:self];
	
	NSString *currentUserId = [[OFCurrentUser currentUser] userId];
	NSString *selectedUserId = [selectedUser userId];
	
	if (!self.selectedUser || [currentUserId isEqualToString:selectedUserId])
	{
		self.selectedUser = [OFCurrentUser currentUser];
		[self displayCurrentUserHeader];
	}
	
	else
	{
		[self displayOtherUserHeader];
	}
	
	self.title = [selectedUser name];
	
	if (!self.friends)
	{
		OFRequestHandle* handle = [selectedUser getFriends];
		if(!handle)
		{
			OFLog(@"Did not get request handle from OFUser's getFriends");
		}
	}
	
	if (!self.friendsWithThisApp)
	{
		OFRequestHandle* handle = [selectedUser getFriendsWithThisApplication];
		if(!handle)
		{
			OFLog(@"Did not get request handle from OFUser's getFriendsWithThisApplication");
		}
	}
	
	if (!self.selectedUserImage)
	{
		OFRequestHandle* handle = [selectedUser getProfilePicture];
		if(!handle)
		{
			OFLog(@"Did not get request handle from OFUser's getProfilePicture");
		}
	}

}
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

- (void)viewWillDisappear:(BOOL)animated {
	
	[OFUser setDelegate:nil];
	[OFCurrentUser setDelegate:nil];
	
	[super viewWillDisappear:animated];
}
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return NUM_SECTIONS;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == kUserInfo)
	{
		return NUM_USER_ROWS;
	}
	
	else if (section == kFriends)
	{
		return [friends count];
	}
	
	else {
		return [friendsWithThisApp count];
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.detailTextLabel.text = nil;
	cell.imageView.image = nil;
	
	if (indexPath.section == kUserInfo)
	{
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		switch (indexPath.row) 
		{
			case kNameRow:
				cell.textLabel.text = @"Name";
				cell.detailTextLabel.text = selectedUser.name;
				cell.imageView.image = selectedUserImage;				
				break;
			case kLastGameIDRow:
				cell.textLabel.text = @"Last Game ID";
				cell.detailTextLabel.text = selectedUser.lastPlayedGameId;
				break;
			case kLastGameNameRow:
				cell.textLabel.text = @"Last Game";
				cell.detailTextLabel.text = selectedUser.lastPlayedGameName;
				break;
			case kGamerScoreRow:
				cell.textLabel.text = @"Gamer Score";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", selectedUser.gamerScore];
				break;
			case kFollowsLocalUserRow:
				cell.textLabel.text = @"Follows local user?";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", selectedUser.followsLocalUser ? @"YES" : @"NO"];
				break;
			case kOnlineRow:
				cell.textLabel.text = @"Online?";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", selectedUser.online ? @"YES" : @"NO"];
				break;
			case kUserIDRow:
				cell.textLabel.text = @"UserID";
				cell.detailTextLabel.text = selectedUser.userId;
				break;
			default:
				break;
		}
	}
	
	else if (indexPath.section == kFriends)
	{
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		cell.textLabel.text = [(OFUser *)[friends objectAtIndex:indexPath.row] name];
	}
	
	else 
	{
		
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		cell.textLabel.text = [(OFUser *)[friendsWithThisApp objectAtIndex:indexPath.row] name];
	}
	
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
		switch (section) {
			case kUserInfo:
				return @"About User";
				break;
			case kFriends:
				return @"Friends of this User";
				break;
			case kFriendsWithThisApp:
				return @"Friends With This Game";
				break;
			default:
				return nil;
				break;
		}
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section != kUserInfo)
	{
		
		SampleUserViewController *controller = [[SampleUserViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		if (indexPath.section == kFriends)
		{
			controller.selectedUser = [friends objectAtIndex:indexPath.row];
		}
		
		else 
		{
			controller.selectedUser = [friendsWithThisApp objectAtIndex:indexPath.row];
		}
		
		
		
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
		
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	
	
	
}


- (void)dealloc {
	
	self.selectedUser = nil;
	self.friends = nil;
	self.friendsWithThisApp = nil;
	self.friendButton = nil;
	self.imButton = nil;
	
    [super dealloc];
}


@end

