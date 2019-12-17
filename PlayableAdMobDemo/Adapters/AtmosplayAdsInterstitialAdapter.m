//
//  AtmosplayAdsInterstitialAdapter.m
//  PlayableAdMobDemo
//
//  Created by lgd on 2018/4/19.
//  Copyright © 2018年 playable. All rights reserved.
//

#import "AtmosplayAdsInterstitialAdapter.h"
#import <AtmosplayAds/AtmosplayInterstitial.h>

@interface AtmosplayAdsInterstitialAdapter ()<AtmosplayInterstitialDelegate>
@property(nonatomic) AtmosplayInterstitial *interstitial;

@end

@implementation AtmosplayAdsInterstitialAdapter
@synthesize delegate;
- (void)requestInterstitialAdWithParameter:(NSString *GAD_NULLABLE_TYPE)serverParameter
                                     label:(NSString *GAD_NULLABLE_TYPE)serverLabel
                                   request:(GADCustomEventRequest *)request {
    NSDictionary *paramterDict = [self getCustomParametersFromServerParameter:serverParameter];
    NSCAssert(paramterDict, @"paramter is invalid，please check adapter config");
    NSString *AppID = paramterDict[@"AppID"];
    NSString *AdUnitID = paramterDict[@"AdUnitID"];
    
    self.interstitial = [[AtmosplayInterstitial alloc] initWithAppID:AppID
                                                            AdUnitID:AdUnitID];
    self.interstitial.delegate = self;
    self.interstitial.autoLoad = NO;
    [self.interstitial loadAd];
}

- (void)presentFromRootViewController:(UIViewController *)rootViewController {
    if (self.interstitial.isReady) {
        [self.interstitial showInterstitialWithViewController:rootViewController];
    } else {
        NSLog(@"Atmosplay interstitial not ready");
    }
}

#pragma mark: private
- (NSDictionary *)getCustomParametersFromServerParameter:(NSString *)jsonString {
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

#pragma mark - AtmosplayInterstitialDelegate
/// Tells the delegate that succeeded to load ad.
- (void)atmosplayInterstitialDidLoad:(AtmosplayInterstitial *)ads {
    [self.delegate customEventInterstitialDidReceiveAd:self];
    NSLog(@"Atmosplay=> customEventInterstitialDidReceiveAd");
}

/// Tells the delegate that failed to load ad.
- (void)atmosplayInterstitial:(AtmosplayInterstitial *)ads didFailToLoadWithError:(NSError *)error {
    [self.delegate customEventInterstitial:self didFailAd:error];
    NSLog(@"Atmosplay=> didFailToLoadWithError: %@", [error description]);
}

/// Tells the delegate that user starts playing the ad.
- (void)atmosplayInterstitialDidStartPlaying:(AtmosplayInterstitial *)ads {
    [self.delegate customEventInterstitialWillPresent:self];
    NSLog(@"Atmosplay=> customEventInterstitialWillPresent");
}

/// Tells the delegate that the ad is being fully played.
- (void)atmosplayInterstitialDidEndPlaying:(AtmosplayInterstitial *)ads {
    
}

/// Tells the delegate that the landing page did present on the screen.
- (void)atmosplayInterstitialDidPresentLandingPage:(AtmosplayInterstitial *)ads {
    
}

/// Tells the delegate that the ad did animate off the screen.
- (void)atmosplayInterstitialDidDismissScreen:(AtmosplayInterstitial *)ads {
    [self.delegate customEventInterstitialDidDismiss:self];
    NSLog(@"Atmosplay=> customEventInterstitialDidDismiss");
}

/// Tells the delegate that the ad is clicked
- (void)atmosplayInterstitialDidClick:(AtmosplayInterstitial *)ads {
    [self.delegate customEventInterstitialWasClicked:self];
    NSLog(@"Atmosplay=> customEventInterstitialWasClicked");
}

@end


