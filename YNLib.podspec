#
# Be sure to run `pod lib lint YNLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YNLib'
  s.version          = '5.0.0'
  s.summary          = 'YNLib is a general project utitities.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                   YNLib is a general project utitities.
                   * CoreDataManager
                   * AsyncOperation
                   * etc.
                   DESC

  s.homepage         = 'https://github.com/stoprain/YNLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'stoprain' => 'mystoprain@gmail.com' }
  s.source           = { :git => 'git@github.com:stoprain/YNLib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.module_name  = 'YNLib'
  s.source_files = "YNLib/Classes/*.{swift,h,m,mm,cc,hpp}", 'Sources/**/*.{h,m,swift}'
  s.dependency 'Objective-LevelDB', '2.1.5'
  s.dependency 'ReactiveCocoa', '12.0.0'
  s.resources = 'YNLib/Assets/unicode_to_hanyu_pinyin.txt'
  s.vendored_frameworks = 'YNLib/Frameworks/mars.framework'
  s.libraries = 'c++', 'z'
  s.frameworks = 'CoreTelephony', 'SystemConfiguration'
  s.public_header_files = 'YNLib/Classes/*.h'
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  s.osx.exclude_files = ["YNLib/Classes/ColorUtils.swift", "YNLib/Classes/CTLabel.swift", "YNLib/Classes/GRToast.swift", "YNLib/Classes/ImageCompressor.swift", "YNLib/Classes/ImageUtils.swift", "YNLib/Classes/ScrollHandle.swift", "YNLib/Classes/UIView+Frame.swift", "YNLib/Classes/ApplicationUtils.swift", "YNLib/Classes/StringUtils.swift", "YNLib/Classes/WebViewController.swift"]

end
