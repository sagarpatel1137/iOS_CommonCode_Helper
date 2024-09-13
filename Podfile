# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'iOS_CommonCode' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iOS_CommonCode
  
  # Purchase
  pod 'RevenueCat'
  
  # API
  pod 'Alamofire'
  
  # AppFlyer
  pod 'AppsFlyerFramework'
  pod 'PurchaseConnector'
  
  # AppMetrica
  pod 'AppMetricaAnalytics'
  
  # Facebook
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
  
  # Tiktok
  pod 'TikTokBusinessSDK'
  
  # OneSignal
  pod 'OneSignal'
  
  # Firebase
  pod 'Firebase/Auth'
  pod 'Firebase/Analytics'
  pod 'Firebase/Performance'
  pod 'Firebase/Crashlytics'
  pod 'FirebaseMessaging'
  
  # Ads
  pod 'Google-Mobile-Ads-SDK'
  
  # Other
  pod 'UIView-Shimmer'
  pod 'MBProgressHUD'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
      
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
