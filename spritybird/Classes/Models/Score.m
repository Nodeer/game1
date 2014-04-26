//
//  Score.m
//  spritybird
//
//  Created by Alexis Creuzot on 16/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "Score.h"

@implementation Score

+ (void)registerScore:(NSInteger)score
{
    if(score > [Score bestScore]){
        [Score setBestScore:score];
    }
}

+ (void) setBestScore:(NSInteger) bestScore
{
    [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:kBestScoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger) bestScore
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kBestScoreKey];
}

+ (NSInteger) reviseScore {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kReviseScoreKey];
}

+ (void) registerReviseScore:(NSInteger) score
{
    NSInteger reviseScore = [[NSUserDefaults standardUserDefaults] integerForKey:kReviseScoreKey];
    if (reviseScore == 0) {
        // Init Score
        reviseScore = REVISE_START;
        [[NSUserDefaults standardUserDefaults] setInteger:reviseScore forKey:kReviseScoreKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (score >= reviseScore) {
        // Inscrease Score
        reviseScore += REVISE_STEP;
        [[NSUserDefaults standardUserDefaults] setInteger:reviseScore forKey:kReviseScoreKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL) isGainReviseScore:(NSInteger) score
{
    NSInteger reviseScore = [[NSUserDefaults standardUserDefaults] integerForKey:kReviseScoreKey];
    
    if (score >= reviseScore) {
        return YES;
    }
    return NO;
}

@end
