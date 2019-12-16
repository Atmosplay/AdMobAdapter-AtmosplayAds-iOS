//
//  AtmosplayAdsInterstitialAdapter.h
//  PlayableAdMobDemo
//
//  Created by lgd on 2018/4/19.
//  Copyright © 2018年 playable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AtmosplayAds/AtmosplayInterstitial.h>

@import GoogleMobileAds;

@interface AtmosplayAdsInterstitialAdapter : NSObject<GADCustomEventInterstitial, AtmosplayInterstitialDelegate>{
}

@property(nonatomic) AtmosplayInterstitial *pAd;

@end
