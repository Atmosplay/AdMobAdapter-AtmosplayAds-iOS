Pod::Spec.new do |s|
  s.name = "GoogleMobileAdsMediationAtmosplayAds"
  s.version = "3.0.0"
  s.summary = "Atmosplay adapter used for mediation with the Google Mobile Ads SDK"
  s.license = "Custom"
  s.authors = {"atmosplay sdk team"=>"ad-client@atmosplay.cn"}
  s.homepage = "https://github.com/Atmosplay"
  s.description = "Atmosplay SDK provides a better ad format for monetizing."
  s.source = {:git => 'https://github.com/Atmosplay/AdMobAdapter-AtmosplayAds-iOS.git', :tag => s.version.to_s}
  s.source_files = 'PlayableAdMobDemo/Adapters/*.{h,m}'
  s.ios.deployment_target = '9.0'
  s.dependency 'AtmosplayAds', '~> 3.0.0'
  s.dependency 'Google-Mobile-Ads-SDK'
  s.static_framework = true
end
