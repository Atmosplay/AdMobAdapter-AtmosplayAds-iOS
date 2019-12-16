//
//  AtmosplayAdsInterstitialAdapter.m
//  PlayableAdMobDemo
//
//  Created by lgd on 2018/4/19.
//  Copyright © 2018年 playable. All rights reserved.
//

#import "AtmosplayAdsInterstitialAdapter.h"

static NSString *const customEventErrorDomain = @"com.google.CustomEvent";
@implementation AtmosplayAdsInterstitialAdapter
@synthesize delegate;

- (void)requestInterstitialAdWithParameter:(NSString *GAD_NULLABLE_TYPE)serverParameter
                                     label:(NSString *GAD_NULLABLE_TYPE)serverLabel
                                   request:(GADCustomEventRequest *)request {
    NSDictionary *paramterDict = [self dictionaryWithJsonString:serverParameter];
    NSCAssert(paramterDict, @"Yumi paramter is invalid，please check yumi adapter config");
    NSString *AppID = paramterDict[@"AppID"];
    NSString *AdUnitID = paramterDict[@"AdUnitID"];
    
    self.pAd = [[AtmosplayInterstitial alloc] initWithAppID:AppID AdUnitID:AdUnitID];
    self.pAd.delegate = self;
    self.pAd.autoLoad = NO;
    [self.pAd loadAd];
}

- (void)presentFromRootViewController:(UIViewController *)rootViewController {
    if (self.pAd.ready) {
        [self.pAd showInterstitialWithViewController:rootViewController];
    } else {
        NSLog(@"Atmosplay interstitial not ready");
    }
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

#pragma mark - AtmosplayInterstitialDelegate
/// Tells the delegate that succeeded to load ad.
- (void)atmosplayInterstitialDidLoad:(AtmosplayInterstitial *)ads {
    [self.delegate customEventInterstitialDidReceiveAd:self];
    NSLog(@"Atmosplay=> customEventInterstitialDidReceiveAd");
}

/// Tells the delegate that failed to load ad.
- (void)atmosplayInterstitial:(AtmosplayInterstitial *)ads didFailToLoadWithError:(NSError *)error {
    NSError *e = [NSError errorWithDomain:customEventErrorDomain
                                         code:-1
                                     userInfo:nil];
    [self.delegate customEventInterstitial:self didFailAd:e];
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


