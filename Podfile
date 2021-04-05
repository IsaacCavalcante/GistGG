# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GistGG' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GistGG
  pod 'QRCodeReader.swift', '~> 10.1.0'
  pod 'Alamofire', '~> 5.2'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'SDWebImage', '~> 5.0'
  pod 'Firebase/Auth'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
