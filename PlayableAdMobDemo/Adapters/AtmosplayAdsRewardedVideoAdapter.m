//
//  AtmosplayAdsRewardedVideoAdapter.m
//  GoogleMobileAdsMediationAtmosplayAds
//
//  Created by 王泽永 on 2019/12/17.
//

#import "AtmosplayAdsRewardedVideoAdapter.h"
#import <AtmosplayAds/AtmosplayRewardedVideo.h>

@interface AtmosplayAdsRewardedVideoAdapter () <GADMediationRewardedAd,AtmosplayRewardedVideoDelegate>
@property (nonatomic) AtmosplayRewardedVideo *rewardedVideo;
@property(nonatomic, weak, nullable) id<GADMediationRewardedAdEventDelegate> delegate;
@property (nonatomic,copy) GADMediationRewardedLoadCompletionHandler adLoadCompletionHandler;

@end

@implementation AtmosplayAdsRewardedVideoAdapter
+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
  return Nil;
}

+ (GADVersionNumber)adSDKVersion {
  NSString *versionString = @"3.0.0";
  NSArray *versionComponents = [versionString componentsSeparatedByString:@"."];
  GADVersionNumber version = {0};
  if (versionComponents.count == 3) {
    version.majorVersion = [versionComponents[0] integerValue];
    version.minorVersion = [versionComponents[1] integerValue];
    version.patchVersion = [versionComponents[2] integerValue];
  }
  return version;
}

+ (GADVersionNumber)version {
  NSString *versionString = @"3.0.0.0";
  NSArray *versionComponents = [versionString componentsSeparatedByString:@"."];
  GADVersionNumber version = {0};
  if (versionComponents.count == 4) {
    version.majorVersion = [versionComponents[0] integerValue];
    version.minorVersion = [versionComponents[1] integerValue];

    // Adapter versions have 2 patch versions. Multiply the first patch by 100.
    version.patchVersion = [versionComponents[2] integerValue] * 100
      + [versionComponents[3] integerValue];
  }
  return version;
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    // Look for the "parameter" key to fetch the parameter you defined in the AdMob UI.
    NSString *adUnitParameters = adConfiguration.credentials.settings[@"parameter"];
    NSDictionary *paramterDict = [self getCustomParametersFromServerParameter:adUnitParameters];
    
    NSCAssert(paramterDict, @"paramter is invalid，please check adapter config");
    NSString *AppID = paramterDict[@"AppID"];
    NSString *AdUnitID = paramterDict[@"AdUnitID"];
  
    self.adLoadCompletionHandler = completionHandler;
  
    self.rewardedVideo = [[AtmosplayRewardedVideo alloc] initWithAppID:AppID AdUnitID:AdUnitID];
    self.rewardedVideo.autoLoad = NO;
    self.rewardedVideo.delegate = self;
    [self.rewardedVideo loadAd];
}

- (void)presentFromViewController:(nonnull UIViewController *)viewController {
  if ([self.rewardedVideo isReady]) {
    // The reward based video ad is available, present the ad.
    [self.rewardedVideo showRewardedVideoWithViewController:viewController];
  } else {
    NSError *error =
      [NSError errorWithDomain:@"AtmosplayAdsRewardedVideoAdapter"
                          code:0
                      userInfo:@{NSLocalizedDescriptionKey : @"Unable to display ad."}];
    [self.delegate didFailToPresentWithError:error];
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

#pragma mark - AtmosplayRewardedVideoDelegate
/// Tells the delegate that the user should be rewarded.
- (void)atmosplayRewardedVideoDidReceiveReward:(AtmosplayRewardedVideo *)ads {
    GADAdReward *aReward =
        [[GADAdReward alloc] initWithRewardType:@""
                                   rewardAmount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d",1]]];
    [self.delegate didRewardUserWithReward:aReward];
}

/// Tells the delegate that succeeded to load ad.
- (void)atmosplayRewardedVideoDidLoad:(AtmosplayRewardedVideo *)ads {
    self.delegate = self.adLoadCompletionHandler(self,nil);
}

/// Tells the delegate that failed to load ad.
- (void)atmosplayRewardedVideo:(AtmosplayRewardedVideo *)ads didFailToLoadWithError:(NSError *)error {
    self.adLoadCompletionHandler(nil,error);
}

/// Tells the delegate that user starts playing the ad.
- (void)atmosplayRewardedVideoDidStartPlaying:(AtmosplayRewardedVideo *)ads {
    [self.delegate willPresentFullScreenView];
    [self.delegate reportImpression];
    [self.delegate didStartVideo];
}

/// Tells the delegate that the ad is being fully played.
- (void)atmosplayRewardedVideoDidEndPlaying:(AtmosplayRewardedVideo *)ads {
    [self.delegate didEndVideo];
}

/// Tells the delegate that the landing page did present on the screen.
- (void)atmosplayRewardedVideoDidPresentLandingPage:(AtmosplayRewardedVideo *)ads {
    
}

/// Tells the delegate that the ad did animate off the screen.
- (void)atmosplayRewardedVideoDidDismissScreen:(AtmosplayRewardedVideo *)ads {
    [self.delegate willDismissFullScreenView];
}

/// Tells the delegate that the ad is clicked
- (void)atmosplayRewardedVideoDidClick:(AtmosplayRewardedVideo *)ads {
    [self.delegate reportClick];
}

@end
