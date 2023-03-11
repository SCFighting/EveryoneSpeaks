# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'EveryoneSpeaks' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SnapKit'
  pod 'KakaJSON', '~> 1.1.2'
  pod 'RxKakaJSON', :git => 'git@github.com:SCFighting/RxKakaJSON.git'
  pod 'Moya/RxSwift', '~> 15.0'
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'RxDataSources', '~> 5.0'
  pod 'CocoaLumberjack/Swift'
  pod 'DynamicColor', '~> 5.0.0'
  pod 'CodeTextField', '~> 0.4.0'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'SDWebImage', '~> 5.0'
  pod 'TXLiteAVSDK_Professional', :podspec => 'https://liteav.sdk.qcloud.com/pod/liteavsdkspec/TXLiteAVSDK_Professional.podspec'
  pod 'SuperPlayer/Professional'
  pod 'ActiveLabel'
  pod 'RAMAnimatedTabBarController'
  pod 'RTRootNavigationController'
  pod 'JXPagingView/Paging'
  pod 'JXSegmentedView'
  pod 'WechatOpenSDK'
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end

end
