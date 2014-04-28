//
//  ViewController.m
//  spritybird
//
//  Created by Alexis Creuzot on 09/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "ViewController.h"
#import "Scene.h"
#import "Score.h"
#import "GADBannerView.h"
#import "GADRequest.h"

@interface ViewController () <GADBannerViewDelegate>
@property (weak,nonatomic) IBOutlet SKView * gameView;
@property (weak,nonatomic) IBOutlet UIView * getReadyView;

@property (weak,nonatomic) IBOutlet UIView * gameOverView;
@property (weak,nonatomic) IBOutlet UIImageView * medalImageView;
@property (weak,nonatomic) IBOutlet UILabel * currentScore;
@property (weak,nonatomic) IBOutlet UILabel * bestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviseLabel;

@property(nonatomic, strong) GADBannerView *adBanner;

- (GADRequest *)request;

@end

@implementation ViewController
{
    Scene * scene;
    UIView * flash;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
	// Configure the view.
    self.gameView.showsFPS = YES;
    self.gameView.showsNodeCount = YES;
    
    // Score Revise
    [Score registerReviseScore:1];
    
    // Config View
//    self.reviseLabel.numberOfLines = 0;
//    self.reviseLabel.text = F(@"Revise the Flappy Bird at score: %li",(long)[Score reviseScore]);
//    self.reviseLabel.font = [UIFont fontWithName:APP_FONT size:21.0f];
//    self.reviseLabel.shadowOffset = CGSizeMake(1.0, 1.0);
//    self.reviseLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    
    self.reviseLabel.text = @"";
    
    self.currentScore.font = [UIFont fontWithName:APP_FONT size:17.0f];
    self.currentScore.shadowOffset = CGSizeMake(1.0, 1.0);
    self.currentScore.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    
    
    self.bestScoreLabel.font = [UIFont fontWithName:APP_FONT size:17.0f];
    self.bestScoreLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    self.bestScoreLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    
    
    // Create and configure the scene.
    scene = [Scene sceneWithSize:self.gameView.bounds.size];
    scene.obstacleType = self.obstacleType;
    [scene startGame];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = self;
    
    // Present the scene
    self.gameOverView.alpha = 0;
    self.gameOverView.transform = CGAffineTransformMakeScale(.9, .9);
    [self.gameView presentScene:scene];
    
    
    // Ads
    
    // Initialize the banner at the bottom of the screen.
    CGPoint origin = CGPointMake(0.0,0);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    if (ISIPAD) {
        self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:origin];
    } else {
        self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    }
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
    self.adBanner.adUnitID = kSampleAdUnitID;
    self.adBanner.delegate = self;
    self.adBanner.rootViewController = self;
    [self.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[self request]];
    
    // Score Revise
    [Score registerReviseScore:1];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Bouncing scene delegate

- (void)eventStart
{
    [UIView animateWithDuration:.2 animations:^{
        self.gameOverView.alpha = 0;
        self.gameOverView.transform = CGAffineTransformMakeScale(.8, .8);
        flash.alpha = 0;
        self.getReadyView.alpha = 1;
        
    } completion:^(BOOL finished) {
        [flash removeFromSuperview];
        
    }];
}

- (void)eventPlay
{
    [UIView animateWithDuration:.5 animations:^{
        self.getReadyView.alpha = 0;
        self.adBanner.alpha = 0;
    }];
}

- (void)eventWasted
{
    
    [self.adBanner loadRequest:[self request]];
    [UIView animateWithDuration:.5 animations:^{
        self.adBanner.alpha = 1;
    }];
    
    flash = [[UIView alloc] initWithFrame:self.view.frame];
    flash.backgroundColor = [UIColor whiteColor];
    flash.alpha = .9;
    [self.gameView insertSubview:flash belowSubview:self.getReadyView];
    
    [self shakeFrame];
    
    [UIView animateWithDuration:.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        // Display game over
        flash.alpha = .4;
        self.gameOverView.alpha = 1;
        self.gameOverView.transform = CGAffineTransformMakeScale(1, 1);
        
        // Set medal
        if(scene.score >= 40){
            self.medalImageView.image = [UIImage imageNamed:@"medal_platinum"];
        }else if (scene.score >= 30){
            self.medalImageView.image = [UIImage imageNamed:@"medal_gold"];
        }else if (scene.score >= 20){
            self.medalImageView.image = [UIImage imageNamed:@"medal_silver"];
        }else if (scene.score >= 10){
            self.medalImageView.image = [UIImage imageNamed:@"medal_bronze"];
        }else{
            self.medalImageView.image = nil;
        }
        
        // Set scores
//        self.currentScore.text = F(@"%li/%li",(long)scene.score,(long)[Score reviseScore]);
        self.currentScore.text = F(@"%li",(long)scene.score);
        self.bestScoreLabel.text = F(@"%li",(long)[Score bestScore]);
        self.reviseLabel.text = @"";
//        self.reviseLabel.text = F(@"Revise the ghost flappy bird at score: %li",(long)[Score reviseScore]);    
        
    } completion:^(BOOL finished) {
        flash.userInteractionEnabled = NO;
    }];
    
}

- (void) shakeFrame
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.view  center].x - 4.0f, [self.view  center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.view  center].x + 4.0f, [self.view  center].y)]];
    [[self.view layer] addAnimation:animation forKey:@"position"];
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark GADRequest generation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            @"42eb1872cb404da31902e40447c01984",
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            GAD_SIMULATOR_ID
                            ];
    return request;
}

#pragma mark GADBannerViewDelegate implementation

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

@end
