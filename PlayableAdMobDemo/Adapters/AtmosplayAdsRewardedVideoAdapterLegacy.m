//
//  AtmosplayAdsRewardedVideoAdapterLegacy.m
//  PlayableAdMobDemo
//
//  Created by lgd on 2017/12/7.
//  Copyright © 2017年 playable. All rights reserved.
//

#import "AtmosplayAdsRewardedVideoAdapterLegacy.h"

@implementation AtmosplayAdsRewardedVideoAdapterLegacy

- (instancetype)initWithRewardBasedVideoAdNetworkConnector: (id<GADMRewardBasedVideoAdNetworkConnector>)connector {
    if (!connector) {
        return nil;
    }
    self = [super init];
    if (self) {
        _rewardedConnector = connector;
    }
    return self;
}

+ (NSString *)adapterVersion {
    return @"2.6.0";
}


- (void)presentRewardBasedVideoAdWithRootViewController:(UIViewController *)viewController {
    if (_pAd.isReady) {
        [_pAd showRewardedVideoWithViewController:viewController];
    } else {
        NSLog(@"No ads to show.");
    }
}

- (void)setUp {
    NSDictionary *paramterDict = [self dictionaryWithJsonString:[_rewardedConnector credentials][@"parameter"]];
    NSCAssert(paramterDict, @"Yumi paramter is invalid，please check yumi adapter config");
    NSString *AppID = paramterDict[@"AppID"];
    NSString *AdUnitID = paramterDict[@"AdUnitID"];
    
    _pAd = [[AtmosplayRewardedVideo alloc] initWithAppID:AppID AdUnitID:AdUnitID];
    _pAd.autoLoad = NO;
    _pAd.delegate = self;
    [_rewardedConnector adapterDidSetUpRewardBasedVideoAd:self];
    NSLog(@"zp=> setUp");
}

#pragma mark: private
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)stopBeingDelegate {
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    return nil;
}

- (void)requestRewardBasedVideoAd {
    [_pAd loadAd];
    NSLog(@"zp=> requestRewardBasedVideoAd");
}

#pragma mark - AtmosplayRewardedVideoDelegate
/// Tells the delegate that the user should be rewarded.
- (void)atmosplayRewardedVideoDidReceiveReward:(AtmosplayRewardedVideo *)ads {
    GADAdReward *reward = [[GADAdReward alloc] initWithRewardType:@"AtmosplayAds" rewardAmount:[NSDecimalNumber  decimalNumberWithString:@"1"]];
    [_rewardedConnector adapter: self didRewardUserWithReward:reward];
    NSLog(@"Atmosplay=> didRewardUserWithReward");
}

/// Tells the delegate that succeeded to load ad.
- (void)atmosplayRewardedVideoDidLoad:(AtmosplayRewardedVideo *)ads {
    [_rewardedConnector adapterDidReceiveRewardBasedVideoAd:self];
    NSLog(@"Atmosplay=> adapterDidReceiveRewardBasedVideoAd");
}

/// Tells the delegate that failed to load ad.
- (void)atmosplayRewardedVideo:(AtmosplayRewardedVideo *)ads didFailToLoadWithError:(NSError *)error {
    [_rewardedConnector adapter:self didFailToLoadRewardBasedVideoAdwithError:error];
    NSLog(@"Atmosplay=> didFailToLoadRewardBasedVideoAdwithError");
}

/// Tells the delegate that user starts playing the ad.
- (void)atmosplayRewardedVideoDidStartPlaying:(AtmosplayRewardedVideo *)ads {
    [_rewardedConnector adapterDidOpenRewardBasedVideoAd:self];
    [_rewardedConnector adapterDidStartPlayingRewardBasedVideoAd:self];
    NSLog(@"Atmosplay=> adapterDidStartPlayingRewardBasedVideoAd");
}

/// Tells the delegate that the ad is being fully played.
- (void)atmosplayRewardedVideoDidEndPlaying:(AtmosplayRewardedVideo *)ads {
    NSLog(@"Atmosplay=> atmosplayRewardedVideoDidEndPlaying");
}

/// Tells the delegate that the landing page did present on the screen.
- (void)atmosplayRewardedVideoDidPresentLandingPage:(AtmosplayRewardedVideo *)ads {
    NSLog(@"Atmosplay=> atmosplayRewardedVideoDidPresentLandingPage");
}

/// Tells the delegate that the ad did animate off the screen.
- (void)atmosplayRewardedVideoDidDismissScreen:(AtmosplayRewardedVideo *)ads {
    [_rewardedConnector adapterDidCloseRewardBasedVideoAd:self];
    NSLog(@"Atmosplay=> adapterDidCloseRewardBasedVideoAd");
}

/// Tells the delegate that the ad is clicked
- (void)atmosplayRewardedVideoDidClick:(AtmosplayRewardedVideo *)ads {
    [_rewardedConnector adapterDidGetAdClick:self];
    NSLog(@"Atmosplay=> adapterDidGetAdClick");
}
@end
