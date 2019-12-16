//
//  AtmosplayAdsRewardedVideoAdapter.h
//  PlayableAdMobDemo
//
//  Created by lgd on 2017/12/7.
//  Copyright © 2017年 playable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/Mediation/GADMRewardBasedVideoAdNetworkConnectorProtocol.h>
#import <GoogleMobileAds/Mediation/GADMRewardBasedVideoAdNetworkAdapterProtocol.h>
#import <AtmosplayAds/AtmosplayRewardedVideo.h>

@import GoogleMobileAds;
@interface AtmosplayAdsRewardedVideoAdapter : NSObject<GADMRewardBasedVideoAdNetworkAdapter, AtmosplayRewardedVideoDelegate> {
}
@property(nonatomic, strong) AtmosplayRewardedVideo *pAd;
@property(nonatomic, strong) id<GADMRewardBasedVideoAdNetworkConnector> rewardedConnector;

@end
