platform :ios, '10.0'

inhibit_all_warnings!
use_frameworks!

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2.0'
        end
    end
end

target 'GoodManager' do

    # Basics
    pod 'RealmSwift'
    pod 'SDWebImage/GIF'
    pod 'ReachabilitySwift'
    pod 'Moya-ObjectMapper/RxSwift'
    #pod 'WoodPeckeriOS'
    pod 'SnapKit', '~> 4.0.0'
    #pod 'BMPlayer', '~> 1.0.0'
    pod 'TZImagePickerController'
    pod 'SwiftyJSON', '~> 4.0'
    #pod 'ObjectMapper', '~> 3.4'
    pod 'LLPhotoBrowser', '~> 1.1.0'
    pod 'iOSPhotoEditor'
    pod 'Kingfisher', '~> 4.10.0'
    pod 'Player', '~> 0.12.0'
end

