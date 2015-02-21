#
# Be sure to run `pod lib lint CedarMap.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CedarMaps"
  s.version          = "0.1.1"
  s.summary          = "Cedar Studio iOS SDK"
  s.description      = "Cedar Studio should write something to introduce their Pod."
  s.homepage         = "http://cedar.ir"
  s.license          = 'MIT'
  s.author           = { "Emad A." => "emad310@gmail.com" }
  s.source           = { :git => "http://gitlab.cedar.ir/cedar.studios/cedarmaps-sdk-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'CedarMap' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Mapbox-iOS-SDK', '~> 1.5.0'
end
