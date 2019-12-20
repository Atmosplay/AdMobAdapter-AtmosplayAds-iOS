//
//  BannerViewController.m
//  PlayableAdMobDemo
//
//  Created by 王泽永 on 2019/10/30.
//  Copyright © 2019 playable. All rights reserved.
//

#import "BannerViewController.h"
#import <GoogleMobileAds/GADBannerView.h>

@interface BannerViewController ()<GADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *loglabel;
@property(nonatomic, strong) GADBannerView *bannerView;

@end

@implementation BannerViewController

- (IBAction)requestBanner:(id)sender {
    if (!self.bannerView) {
        self.bannerView = [[GADBannerView alloc]
                           initWithAdSize:kGADAdSizeBanner];
        
        [self addBannerViewToView:self.bannerView];
        self.bannerView.adUnitID = @"ca-app-pub-9454875840803246/3492140761";
        self.bannerView.rootViewController = self;
        self.bannerView.delegate = self;
    }
    
    GADRequest *request = [GADRequest request];
    
    [self.bannerView loadRequest:request];
    self.loglabel.text = @"load banner...";
}

- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.bottomLayoutGuide
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0]
                                ]];
}

#pragma mark: GADBannerViewDelegate

/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    self.loglabel.text = @"adViewDidReceiveAd";
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    self.loglabel.text = [NSString stringWithFormat:@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]];
}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    self.loglabel.text = @"adViewWillPresentScreen";
}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    self.loglabel.text = @"adViewDidDismissScreen";
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    self.loglabel.text = @"adViewWillLeaveApplication";
}

@end
