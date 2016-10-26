#
# Be sure to run `pod lib lint CedarMaps.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CedarMaps'
  s.version          = '1.0.1'
  s.cocoapods_version = '>= 0.36'
  s.license          = 'MIT'
  s.homepage         = 'https://www.kikojas.com/about-cedarmaps'
  s.authors           = { 'Emad A.' => 'emad310@gmail.com', 'Saeed T' => 'saeed.taheri@gmail.com' }
  s.summary          = 'CedarMaps iOS SDK'
  s.source           = { :git => 'http://gitlab.cedar.ir/cedar.studios/cedarmaps-sdk-ios-public.git', :tag => s.version.to_s }
  s.source_files = 'Pod/Classes'
  s.framework = 'UIKit'
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'Mapbox-iOS-SDK', '~> 3.3.4'
end