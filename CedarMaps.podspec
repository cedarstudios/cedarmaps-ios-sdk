#
# Be sure to run `pod lib lint CedarMaps.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CedarMaps'
  s.version          = '3.0.1'
  s.summary          = 'CedarMaps iOS SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        The CedarMaps iOS SDK library is used to integrate CedarMaps tiles and using geocoding APIs in your iOS application.
                        For using this library, you need valid credentials. Please visit http://cedarmaps.com for more information.
                       DESC

  s.homepage         = 'https://www.cedarmaps.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors           = { 'CedarMaps' => 'info@cedarmaps.com', 'Saeed Taheri' => 'saeed.taheri@gmail.com' }
  s.source           = { :git => 'http://gitlab.cedar.ir/cedar.studios/cedarmaps-sdk-ios-public.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cedarmaps'

  s.platform = :ios, '9.0'
  s.requires_arc = true

  s.static_framework = true
  s.cocoapods_version = '>= 1.4.0'

  s.source_files = 'CedarMaps/Classes/**/*'
  s.public_header_files = 'CedarMaps/Headers/Public/*.h'
  
  s.resource_bundles = {
    'CedarMaps' => ['CedarMaps/Assets/Media.xcassets']
  }

  s.public_header_files = 'CedarMaps/Classes/**/*.h'
  s.dependency 'Mapbox-iOS-SDK', '~> 4.0'
  s.dependency 'Mantle', '~> 2.1'
end
