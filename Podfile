platform :ios, '10.0'

inhibit_all_warnings!
use_frameworks!

project 'SmartReceipts.xcodeproj'

def pods
    #AWS
    pod 'AWSCognito'
    pod 'AWSS3'
    
    # File storage
    pod 'FMDB'
    pod 'Zip'
    
    # UI
    pod 'MRProgress'
    pod 'Eureka'
    pod 'XLPagerTabStrip'
    pod 'Floaty'
    pod 'Toaster'
    pod 'MKDropdownMenu'
    
    # Rx
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    pod 'RxAlamofire'
    
    # Utilites
    pod 'CocoaLumberjack/Swift'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    
    # Firebase
    pod 'Firebase/Analytics'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    pod 'Firebase/AdMob'
    
    # Google
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'GTMAppAuth'
    pod 'GoogleAPIClientForREST/Drive'
    pod 'GoogleSignIn'
    
    # Purchases
    pod 'SwiftyStoreKit'
    
    # Architecture
    pod 'Viperit'
    
end

target 'SmartReceipts' do
    pods
end

target 'SmartReceiptsTests' do
    pods
    pod 'RxBlocking'
    pod 'RxTest'
    pod 'Cuckoo', :git => 'https://github.com/kaosdg/Cuckoo.git', :branch => 'swift-4.0'

end

# Disable bitcode for targets:

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if (target.name == 'Zip') || (target.name == 'Eureka') || (target.name == 'Viperit')
        config.build_settings['SWIFT_VERSION'] = '4.1'
      end
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
