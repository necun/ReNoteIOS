# Uncomment the next line to define a global platform for your project
platform :ios, '17.0'

target 'ReNoteAI' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'CLImageEditor/AllTools'
  pod 'SwiftyDropbox', '~> 5.1.0'
  #  pod 'box-ios-sdk'
  #  pod 'BoxSDK', '~> 4.0'
  
  pod 'SwiftyJSON', '~> 5.0'
  pod 'SDWebImage', '~>3.6'
  pod 'PDFGenerator'
  pod 'IQLabelView', '~> 0.2'
  pod 'ImageScrollView'
  pod 'CropPickerView','~> 0.1.3'
  #pod 'GoogleMobileVision/TextDetector' #unused
  pod "FlagPhoneNumber", '0.7.6'
  pod 'Zip', '~> 2.1' #earlier ~> 1.1
  pod 'QBImagePickerController', '~> 3.4'
  pod 'MSAL'
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
      end
    end
  end
end
