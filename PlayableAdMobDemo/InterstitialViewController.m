//
//  InterstitialViewController.m
//  PlayableAdMobDemo
//
//  Created by lgd on 2018/4/19.
//  Copyright © 2018年 playable. All rights reserved.
//

#import "InterstitialViewController.h"
@import GoogleMobileAds;

@interface InterstitialViewController () <GADInterstitialDelegate>
@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@property (nonatomic) GADInterstitial *interstitial;

@end

@implementation InterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-9454875840803246/3300569078"];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    _logLabel.text = @"";
    [self sendToLog:@"loadRequest"];
    return interstitial;
}

- (IBAction)loadAd:(id)sender {
    if (self.interstitial) {
        return;
    }
    _interstitial = [self createAndLoadInterstitial];
}

- (IBAction)presentAd:(id)sender {
    if ([_interstitial isReady]){
        [_interstitial presentFromRootViewController:self];
    }else{
        NSLog(@"Atmosplay=> AdMob interstitial not ready.");
        [self sendToLog:@"AdMob interstitial not ready."];
    }
}

- (void)sendToLog:(NSString *)msg {
    _logLabel.text =  [_logLabel.text stringByAppendingFormat:@"%@\n", msg];
    NSLog(@"---> %@", msg);
}

#pragma mark Ad Request Lifecycle Notifications

/// Called when an interstitial ad request succeeded. Show it at the next transition point in your
/// application such as when transitioning between view controllers.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    [self sendToLog:@"interstitialDidReceiveAd"];
}

/// Called when an interstitial ad request completed without an interstitial to
/// show. This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    [self sendToLog:[@"didFailToReceiveAdWithError" stringByAppendingString:error.description]];
}

#pragma mark Display-Time Lifecycle Notifications

/// Called just before presenting an interstitial. After this method finishes the interstitial will
/// animate onto the screen. Use this opportunity to stop animations and save the state of your
/// application in case the user leaves while the interstitial is on screen (e.g. to visit the App
/// Store from a link on the interstitial).
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    [self sendToLog:@"interstitialWillPresentScreen"];
}

/// Called when |ad| fails to present.
- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    [self sendToLog:@"interstitialDidFailToPresentScreen"];
}

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    [self sendToLog:@"interstitialWillDismissScreen"];
}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    self.interstitial = nil;
    self.interstitial = [self createAndLoadInterstitial];
    [self sendToLog:@"interstitialDidDismissScreen"];
}

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store). The normal
/// UIApplicationDelegate methods, like applicationDidEnterBackground:, will be called immediately
/// before this.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    [self sendToLog:@"interstitialWillLeaveApplication"];
}



@end
