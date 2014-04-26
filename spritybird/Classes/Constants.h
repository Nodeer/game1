//
//  Constants.h

#import "AppDelegate.h"
#import "Macros.h"


// Physic collision bitmasks

static const uint32_t backBitMask     =  0x1 << 0;
static const uint32_t birdBitMask     =  0x1 << 1;
static const uint32_t floorBitMask    =  0x1 << 2;
static const uint32_t blockBitMask    =  0x1 << 3;

#define ISIPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// You should set this ad unit ID from your account before compiling.
#define kSampleAdUnitID (ISIPAD ? @"a1532e39ae0765a" : @"a1532aa79a7b7fd")


// Sound
#define SOUND_JUMP @"Froggy-Jump"
#define SOUND_HIT  @"Foggy-Drop"
#define APP_FONT @"04b_19"
#define SHOW_QUESTION_FIST_TIME @"SHOW_QUESTION_FIST_TIME"

#define ApplicationDelegate ((ATAppDelegate *)[UIApplication sharedApplication].delegate)


// Score
#define REVISE_START 10
#define REVISE_STEP 1


// Trong Vu support iphone compatible for now
//#define MAIN_STORYBOARD (ISIPAD ? @"Main-iPad" : @"Main")
#define MAIN_STORYBOARD (ISIPAD ? @"Main" : @"Main")

// Score
#define OBSTACLE_LOTUS 0
#define OBSTACLE_WOOD 1

