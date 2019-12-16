//
//  AtmosplayAdsBannerAdapter.m
//  PlayableAdMobDemo
//
//  Created by 王泽永 on 2019/10/30.
//  Copyright © 2019 playable. All rights reserved.
//

#import "AtmosplayAdsBannerAdapter.h"
#import <AtmosplayAds/AtmosplayBanner.h>

@interface AtmosplayAdsBannerAdapter () <AtmosplayBannerDelegate>
@property (nonatomic) AtmosplayBanner *bannerView;

@end

@implementation AtmosplayAdsBannerAdapter
@synthesize delegate;
- (void)requestBannerAd:(GADAdSize)adSize parameter:(nullable NSString *)serverParameter label:(nullable NSString *)serverLabel request:(nonnull GADCustomEventRequest *)request {
    
    NSDictionary *paramterDict = [self dictionaryWithJsonString:serverParameter];
    NSCAssert(paramterDict, @"paramter is invalid，please check adapter config");
    NSString *AppID = paramterDict[@"AppID"];
    NSString *AdUnitID = paramterDict[@"AdUnitID"];

    self.bannerView = [[AtmosplayBanner alloc] initWithAppID:AppID adUnitID:AdUnitID rootViewController:[self.delegate viewControllerForPresentingModalView]];
    self.bannerView.delegate = self;
    
    self.bannerView.bannerSize = kAtmosplayBanner320x50;
    if (GADAdSizeEqualToSize(adSize, kGADAdSizeLeaderboard)) {
        self.bannerView.bannerSize = kAtmosplayBanner728x90;
    } else if (GADAdSizeEqualToSize(adSize, kGADAdSizeSmartBannerPortrait)) {
        self.bannerView.bannerSize = kAtmosplaySmartBannerPortrait;
    } else if (GADAdSizeEqualToSize(adSize, kGADAdSizeSmartBannerLandscape)) {
        self.bannerView.bannerSize = kAtmosplaySmartBannerLandscape;
    }
    
    [self.bannerView loadAd];
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

#pragma mark - AtmosplayAdsBannerDelegate
/// Tells the delegate that an ad has been successfully loaded.
- (void)AtmosplayBannerViewDidLoad:(AtmosplayBanner *)bannerView {
    [self.delegate customEventBanner:self didReceiveAd:bannerView];
}

/// Tells the delegate that a request failed.
- (void)AtmosplayBannerView:(AtmosplayBanner *)bannerView didFailWithError:(NSError *)error {
    self.bannerView.delegate = nil;
    self.bannerView = nil;
    [self.delegate customEventBanner:self didFailAd:error];
}

/// Tells the delegate that the banner view has been clicked.
- (void)AtmosplayBannerViewDidClick:(AtmosplayBanner *)bannerView {
    [self.delegate customEventBannerWasClicked:self];
    [self.delegate customEventBannerWillLeaveApplication:self];
}

- (void)dealloc {
    self.bannerView.delegate = nil;
    self.bannerView = nil;
}

@end
