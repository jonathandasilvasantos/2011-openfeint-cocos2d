
#import <UIKit/UIKit.h>

#import "OpenFeint/OFScoreEnumerator.h"
#import "OpenFeint/OFDistributedScoreEnumerator.h"
#import "OpenFeint/OFRequestHandle.h"
#import "OpenFeint/OFLeaderboard.h"


enum LbdViewType {
	LbdViewType_Global = 0,
	LbdViewType_Friends,
	LbdViewType_Offline,
	LbdViewType_Mine,
	LbdViewType_Spaced,
	//
	//LbdViewType_Count,
	LbdViewType_None = -1
};

enum LbdPageCmd {
	LbdPageCmd_Summary = 0,
	LbdPageCmd_First,
	LbdPageCmd_WithMe,
	LbdPageCmd_Next,
	LbdPageCmd_Previous,
	//
	//LbdPageCmd_Count,
	LbdPageCmd_None = -1
};


@interface SampleLeaderboardViewController : UIViewController<OFLeaderboardDelegate, OFScoreEnumeratorDelegate, OFDistributedScoreEnumeratorDelegate>
{
	UITextView* scoresView;
	UIActivityIndicatorView* activityView;
	OFLeaderboard* leaderboard;
	LbdViewType currentLbdViewType;
	LbdPageCmd	currentLbdPageCmd;
	BOOL		currentLbdIsEnumerated;
	
	UILabel* enumerationLabel;
	UISwitch* enumerationSwitch;
    UIButton* nextButton;
    UIButton* prevButton;
    UIButton* meButton;
	UIButton* getPageButton;
	UITextField* pageTextField;
    
    OFScoreEnumerator* regularScoreEnumerator;
	OFDistributedScoreEnumerator* distributedScoreEnumerator;
	OFRequestHandle* activeRequest;
}

@property (nonatomic, retain) IBOutlet UITextView* scoresView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* activityView;
@property (nonatomic, retain) IBOutlet UILabel* enumerationLabel;
@property (nonatomic, retain) IBOutlet UISwitch* enumerationSwitch;
@property (nonatomic, retain) IBOutlet UIButton* nextButton;
@property (nonatomic, retain) IBOutlet UIButton* prevButton;
@property (nonatomic, retain) IBOutlet UIButton* meButton;
@property (nonatomic, retain) IBOutlet UIButton* getPageButton;
@property (nonatomic, retain) IBOutlet UITextField* pageTextField;
@property (nonatomic, retain) OFLeaderboard* leaderboard;
@property (nonatomic, retain) OFRequestHandle* activeRequest;

- (IBAction)openLeaderboard;
- (IBAction)changeViewType:(id)sender;
- (IBAction)prev;
- (IBAction)next;
- (IBAction)me;
- (IBAction)getPage;
- (IBAction)switchToggled:(id)sender;

@end
