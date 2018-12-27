platform :ios, '10.0'

inhibit_all_warnings!
use_frameworks!

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0.1'
        end
    end
end

target 'GoodManager' do

    # Basics
    #pod 'RealmSwift'
    pod 'SDWebImage/GIF'
    pod 'ReachabilitySwift'
    pod 'Moya'
end

