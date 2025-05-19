Pod::Spec.new do |s|
  s.name             = 'ZMarkupParser'
  s.version          = '2.0.4'
  s.summary          = 'A pure-Swift library to convert HTML strings into NSAttributedString with customized styles and tags.'
  s.description      = <<-DESC
ZMarkupParser is a pure-Swift library that helps you convert HTML strings into NSAttributedString with customized styles and tags. It supports builder patterns, custom tag styles, class/id mapping, and async rendering for large HTML content.
  DESC
  s.homepage         = 'https://github.com/BudhirajaRajesh/ZMarkupParser'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rajesh Budhiraja' => 'rajesh.budhiraja@zomato.com' }
  s.source           = { :git => 'https://github.com/BudhirajaRajesh/ZMarkupParser.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/**/*.swift'
  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '5.0'
  }
end 
