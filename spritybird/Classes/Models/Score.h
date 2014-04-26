//
//  Score.h
//  spritybird
//
//  Created by Alexis Creuzot on 16/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#define kBestScoreKey @"BestScore"
#define kReviseScoreKey @"ReviseScore"

@interface Score : NSObject

+ (void) registerScore:(NSInteger) score;
+ (void) setBestScore:(NSInteger) bestScore;
+ (NSInteger) bestScore;
+ (void) registerReviseScore:(NSInteger) score;
+ (BOOL) isGainReviseScore:(NSInteger) score;
+ (NSInteger) reviseScore;

@end
