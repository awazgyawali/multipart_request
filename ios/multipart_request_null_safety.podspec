#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint multipart_request_null_safety.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'multipart_request_null_safety'
  s.version          = '0.3.3'
  s.summary          = 'A flutter plugin to send a multipart request and get stream of progress, this is a null safety version of the original all credits go to the original author (awazgyawali)  aawaz.dev.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/elmanna/multipart_request_null_safety'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :git => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Alamofire', '4.9.1'
  s.platform = :ios, '11.0'


  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
