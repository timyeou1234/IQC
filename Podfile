# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'IQC' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for IQC
  pod 'SwiftyJSON', '3.0.0'
  pod 'CarbonKit'
  pod 'Alamofire'
  pod 'SDWebImage', '~>3.8'
  pod 'DropDown'
  pod 'TagListView', '~> 1.0'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
              config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
          end
      end
  end

  target 'IQCTests' do
    inherit! :search_paths
    # Pods for testing
      end

end
