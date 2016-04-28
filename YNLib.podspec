Pod::Spec.new do |s|

  s.name         = "YNLib"
  s.version      = "0.0.4"
  s.summary      = "YNLib is a general project utitities."

  s.description  = <<-DESC
                   YNLib is a general project utitities.
                   * CoreDataManager
                   * AsyncOperation
                   * YNImage
                   * etc.
                   DESC

  s.homepage     = "https://github.com/stoprain/YNLib"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.authors            = { "rain" => "rain@yunio.com" }
  s.social_media_url   = ""

  s.ios.deployment_target = "8.0"

  s.module_name  = 'YNLib'
  s.source       = { :git => "https://github.com/stoprain/YNLib.git", :tag => s.version }
  s.source_files = "Sources/*.{swift,h,m}"
  s.dependency 'CocoaLumberjack/Swift'
  s.dependency 'Objective-LevelDB'
  s.public_header_files = 'Sources/*.h'

  s.preserve_paths = 'CocoaPods/**/*'
  s.pod_target_xcconfig = {
    'SWIFT_INCLUDE_PATHS[sdk=iphoneos*]'         => '$(SRCROOT)/YNLib/CocoaPods/iphoneos',
    'SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]'  => '$(SRCROOT)/YNLib/CocoaPods/iphonesimulator'
  }

end