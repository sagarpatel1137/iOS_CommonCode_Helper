
Pod::Spec.new do |spec|

  spec.name              = "iOS_CommonCode_Helper"
  spec.version           = "0.0.1"
  spec.summary           = "CommonCode Code iOS"
  spec.description       = <<-DESC
                             Common Code for Vasundhara iOS App Developing.
                           DESC
  spec.homepage          = "https://github.com/sagarpatel1137/iOS_CommonCode_Helper.git"
  spec.license           = { :type => "MIT", :file => "LICENSE" }
  spec.author            = { "Gautam iOS" => "" }
 
  spec.platform          = :ios
  spec.platform          = :ios, "13.0"
  spec.ios.deployment_target = "13.0"
  spec.swift_version     = "5.5"

  spec.source            = { :git => "https://github.com/sagarpatel1137/iOS_CommonCode_Helper.git", :tag => "#{spec.version}" }
  spec.source_files      = "*"

end
