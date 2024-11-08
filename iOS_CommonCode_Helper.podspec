
Pod::Spec.new do |spec|

spec.name              = "iOS_CommonCode_Helper"
spec.version           = "1.0.39"
spec.summary           = "CommonCode Code iOS"
spec.description       = <<-DESC
Common Code for Vasundhara iOS App Developing.
DESC
spec.homepage          = "https://github.com/sagarpatel1137/iOS_CommonCode_Helper.git"
spec.license           = { :type => "MIT", :file => "LICENSE" }
spec.author            = { "Gautam iOS" => "" }

spec.platform          = :ios, "13.0"
spec.ios.deployment_target = '13.0'
spec.swift_version     = "5.0"

spec.readme            = 'README.md'

spec.source            = { :git => "https://github.com/sagarpatel1137/iOS_CommonCode_Helper.git", :tag => "#{spec.version}" }
spec.source_files      = "iOS_CommonCode/**/*.swift"
spec.resources = [
    "iOS_CommonCode/**/*.xib",
    "iOS_CommonCode/Resources/Json/*.json",
    "iOS_CommonCode/Resources/Font/*.ttf",
    "iOS_CommonCode/Resources/Localise/*.strings",
    "iOS_CommonCode/Resources/Assets/**/*.{svg,png,jpg,jpeg,gif,pdf}"
]
spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}

spec.static_framework  = true
spec.frameworks        = 'UIKit', 'Foundation', 'SystemConfiguration', 'StoreKit'

spec.dependency 'RevenueCat'
spec.dependency 'Alamofire'
spec.dependency 'AppsFlyerFramework'
spec.dependency 'PurchaseConnector'
spec.dependency 'AppMetricaAnalytics'
spec.dependency 'FBSDKCoreKit'
spec.dependency 'FBSDKLoginKit'
spec.dependency 'FBSDKShareKit'
spec.dependency 'TikTokBusinessSDK'
spec.dependency 'OneSignal'

spec.dependency 'Firebase/Auth'
spec.dependency 'Firebase/Analytics'
spec.dependency 'Firebase/Performance'
spec.dependency 'Firebase/Crashlytics'
spec.dependency 'FirebaseMessaging'
spec.dependency 'Google-Mobile-Ads-SDK'

spec.dependency 'UIView-Shimmer'
spec.dependency 'MarqueeLabel'
spec.dependency 'MBProgressHUD'
spec.dependency 'lottie-ios'
spec.dependency 'SwiftConfettiView'
spec.dependency 'SVGKit'

end
