//
//  RewardedVideoViewControllerLegacy.m
//  PlayableAdMobDemo
//
//  Created by lgd on 2017/12/7.
//  Copyright © 2017年 playable. All rights reserved.
//

#import "RewardedVideoViewControllerLegacy.h"
@import GoogleMobileAds;

@interface RewardedVideoViewControllerLegacy () <GADRewardBasedVideoAdDelegate>

@property (weak, nonatomic) IBOutlet UILabel *logLabel;

@end

@implementation RewardedVideoViewControllerLegacy

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadAd:(UIButton *)sender {
    _logLabel.text = @"";
    [self sendToLog:@"start loading ad"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request]
                                           withAdUnitID:@"ca-app-pub-5451364651863658/5455468949"];
}

- (IBAction)presentAd:(UIButton *)sender {
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    } else {
        [self sendToLog:@"rewarded ad not ready."];
    }
}

- (void)sendToLog:(NSString *)msg {
   _logLabel.text =  [_logLabel.text stringByAppendingFormat:@"%@\n", msg];
    NSLog(@"%@", msg);
}

# pragma mark - GADRewardBasedVideoAdDelegate
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    NSString *rewardMessage = [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
                               reward.type,
                               [reward.amount doubleValue]];
    [self sendToLog:rewardMessage];
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSString *log = @"Reward based video ad is received.";
    [self sendToLog: log];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [self sendToLog:@"rewardBasedVideoAdDidOpen"];
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [self sendToLog:@"rewardBasedVideoAdDidStartPlaying"];
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [self sendToLog:@"rewardBasedVideoAdDidClose"];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [self sendToLog:@"rewardBasedVideoAdWillLeaveApplication"];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    [self sendToLog:[@"didFailToLoadWithError: " stringByAppendingString: error.description]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
