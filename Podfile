# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'EveryoneSpeaks' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SnapKit'
  pod 'KakaJSON', '~> 1.1.2'
  pod 'RxKakaJSON', :git => 'git@github.com:SCFighting/RxKakaJSON.git'
  pod 'CocoaLumberjack/Swift'
  pod 'Moya/RxSwift', '~> 15.0'
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'DynamicColor', '~> 5.0.0'
  pod 'CodeTextField', '~> 0.4.0'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'ActiveLabel'
  pod 'RAMAnimatedTabBarController'
  pod 'RTRootNavigationController'
  pod 'JXPagingView/Paging'
  pod 'WechatOpenSDK'
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end

end
