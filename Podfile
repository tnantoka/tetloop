platform :ios, '7.1'

pod 'FXForms', '~> 1.1'
pod 'VTAcknowledgementsViewController', '~> 0.11'
pod 'Colours', '~> 5.5'
#pod 'PhysicsDebugger', git: 'https://github.com/ymc-thzi/PhysicsDebugger.git'
pod 'CJPAdController', '~> 1.6'
pod 'iOSDetector', '~> 0.1'
pod 'RMStore', '~> 0.5'
pod 'SVProgressHUD', '~> 1.0'

cocoapods_license = File.read('cocoapods_license.txt')
other_licenses = File.read('other_licenses.txt')

post_install do |installer|
  require 'fileutils'

  # License
  licenses = File.read('Pods/Pods-acknowledgements.plist')
	licenses.gsub!(cocoapods_license,  "#{other_licenses}#{cocoapods_license}")
  File.write('Tetloop/Assets/Pods-acknowledgements.plist', licenses)
end
