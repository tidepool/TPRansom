Pod::Spec.new do |s|
  s.name             = "TPRansom"
  s.version          = "0.1.6"
  s.summary          = "TPRansom provides the classes that make the TidePool game, Ransom."
  s.homepage         = "http://tidepool.co"
  s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "e7mac" => "mayank.ot@gmail.com" }
  s.source           = { :git => "https://github.com/tidepool/TPRansom.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/tidepool'

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/ios/*'
  s.resources = 'Assets/*'

  s.dependency 'TPGameAbstract', '~> 0.1.0'
  s.dependency 'MSKit', '~> 0.1.0'

end
