source 'https://github.com/CocoaPods/Specs.git'

target 'YNLib' do
	platform :ios, '8.0'
	use_frameworks!
end

target 'YNLibOSX' do
	platform :osx, '10.11'
	use_frameworks!
end

pod 'CocoaLumberjack/Swift'
pod 'Objective-LevelDB'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
