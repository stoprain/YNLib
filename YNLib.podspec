Pod::Spec.new do |s|

  s.name         = "YNLib"
  s.version      = "0.0.1"
  s.summary      = "YNLib is a general project utitities."

  s.description  = <<-DESC
                   YNLib is a general project utitities.
                   * CoreDataManager
                   * AsyncOperation
                   * YNImage
                   * etc.
                   DESC

  s.homepage     = "https://github.com/stoprain/YNLib"
  s.screenshots  = ""

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.authors            = { "rain" => "rain@yunio.com" }
  s.social_media_url   = ""

  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/stoprain/YNLib.git", :tag => s.version }
  
  s.source_files  = ["Sources/*.swift", "Sources/YNLib.h"]
  s.public_header_files = ["Sources/YNLib.h"]
  
  s.requires_arc = true

end