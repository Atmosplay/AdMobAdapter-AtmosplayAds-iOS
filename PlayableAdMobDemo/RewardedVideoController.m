//
//  RewardedVideoController.m
//  PlayableAdMobDemo
//
//  Created by 王泽永 on 2019/12/17.
//  Copyright © 2019 playable. All rights reserved.
//

#import "RewardedVideoController.h"
@import GoogleMobileAds;

@interface RewardedVideoController () <GADRewardedAdDelegate>
@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@property(nonatomic, strong) GADRewardedAd *rewardedAd;

@end

@implementation RewardedVideoController
- (GADRewardedAd *)createAndLoadRewardedAd {
  GADRewardedAd *rewardedAd = [[GADRewardedAd alloc]
      initWithAdUnitID:@"ca-app-pub-9454875840803246/5588639307"];
  GADRequest *request = [GADRequest request];
  [rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
    if (error) {
      // Handle ad failed to load case.
        [self sendToLog:@"fail to load"];
    } else {
      // Ad successfully loaded.
        [self sendToLog:@"successfull loaded"];
    }
  }];
  return rewardedAd;
}

- (IBAction)loadAd:(id)sender {
    if (self.rewardedAd) {
        return;
    }
    [self createAndLoadRewardedAd];
    [self sendToLog:@"start loading ad"];
}

- (IBAction)presentAd:(id)sender {
    if (self.rewardedAd.isReady) {
      [self.rewardedAd presentFromRootViewController:self delegate:self];
    } else {
        [self sendToLog:@"ad not ready"];
    }
}

#pragma mark - Private Method
- (void)sendToLog:(NSString *)msg {
   _logLabel.text =  [_logLabel.text stringByAppendingFormat:@"%@\n", msg];
    NSLog(@"%@", msg);
}

#pragma mark - GADRewardedAdDelegate
/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward {
  // TODO: Reward the user.
    [self sendToLog:@"rewardedAd:userDidEarnReward:"];
}

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
    [self sendToLog:@"rewardedAdDidPresent:"];
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
    [self sendToLog:@"rewardedAd:didFailToPresentWithError"];
}

/// Tells the delegate that the rewarded ad was dismissed.
- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
    self.rewardedAd = nil;
    self.rewardedAd = [self createAndLoadRewardedAd];
    [self sendToLog:@"rewardedAdDidDismiss:"];
}

@end
