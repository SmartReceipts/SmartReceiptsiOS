platform :ios, '12.0'

inhibit_all_warnings!
use_frameworks!

source 'https://cdn.cocoapods.org/'

project 'SmartReceipts.xcodeproj'

def pods
    #AWS
    pod 'AWSCognito'
    pod 'AWSS3'
    
    # File storage
    pod 'FMDB'
    pod 'Zip'
    
    # UI
    pod 'lottie-ios'
    pod 'Eureka', '5.3.4'
    pod 'Toaster', :git => 'https://github.com/devxoul/Toaster.git', :branch => 'master'
    pod 'Charts'
    pod 'SnapKit'
    
    # Rx
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    pod 'RxOptional'
    pod 'RxGesture'
    pod 'Moya/RxSwift'
    
    # Utilites
    pod 'CocoaLumberjack/Swift'
    pod 'Alamofire'
    pod 'Moya'
    
    # Firebase
    pod 'Firebase/Core', '7.2-M1'
    pod 'Firebase/Analytics'
    pod 'Firebase/Messaging'
    pod 'Firebase/AdMob'
    pod 'Firebase/Crashlytics'
    
    # Google
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
    pod 'Cuckoo'

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
#      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
end
