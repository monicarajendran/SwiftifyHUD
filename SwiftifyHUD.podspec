#
# Be sure to run `pod lib lint SwiftifyHUD.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftifyHUD'
  s.version          = '1.0'
  s.summary          = 'A simple hud writtern in swift'
  s.description      = <<-DESC
'A simple hud writtern in swift.'
DESC

  s.homepage         = 'https://github.com/monicarajendran/SwiftifyHUD'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'monicarajendran' => 'monicarajendran96@gmail.com' }
  s.source           = { :git => 'https://github.com/monicarajendran/SwiftifyHUD.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SwiftifyHUD/Classes/*.swift'
end
