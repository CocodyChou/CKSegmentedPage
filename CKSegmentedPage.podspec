#
# Be sure to run `pod lib lint CKSegmentedPage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CKSegmentedPage'
  s.version          = '0.9.6'
  s.summary          = '有点像网易新闻的分页视图'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
有点像网易新闻的分页视图，简单，易用，是我的目标。
                       DESC

  s.homepage         = 'https://github.com/CocodyChou/CKSegmentedPage.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cike' => '50937036@qq.com' }
  s.source           = { :git => 'https://github.com/CocodyChou/CKSegmentedPage.git', :tag => '0.9.6' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CKSegmentedPage/Classes/**/*'
  s.requires_arc = true
  
  # s.resource_bundles = {
  #   'CKSegmentedPage' => ['CKSegmentedPage/Assets/*.png']
  # }

  s.public_header_files = 'CKSegmentedPage/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry'
end
