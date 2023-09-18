#---------------------*definition*------------------------
def rx_swift
  pod 'RxSwift'
end

def rx_cocoa
  pod 'RxCocoa'
end

def test_pods
  pod 'RxTest'
  pod 'RxBlocking'
end
#---------------------*MondayJobs*------------------------

target 'MondayJobs' do
        use_frameworks!

  # Pods from definition
  rx_cocoa
  rx_swift

  # Pods
  pod 'RxDataSources'
  pod 'KeychainAccess'
  pod 'PureLayout'
  pod 'NVActivityIndicatorView', '~> 4.4.0'
  pod 'Kingfisher'
  pod 'paper-onboarding'
  pod 'SkeletonView'
  pod 'lottie-ios'
  pod 'GoogleSignIn', '~> 5.0'
  pod 'Firebase/Analytics'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  pod 'CocoaLumberjack/Swift'
  pod 'CHIPageControl/Aleppo'
  pod 'RxGesture'
  pod 'TwilioVideo'
  pod 'Material'
  pod 'MaterialComponents', '~> 91.0.0'
  pod 'SwiftSVG'
  pod 'SwiftSignalRClient'
  pod 'CircleProgressView'

 

end
#---------------------*Domain*------------------------

target 'Domain' do
        use_frameworks!

  # Pods 
  rx_swift
  pod 'SwiftyJSON'
  pod 'ReachabilitySwift'

  #-------*Tests*----------
  target 'DomainTests' do
    inherit! :search_paths
    test_pods
  end

end
#---------------------*NetworkPlatform*------------------------

target 'NetworkPlatform' do
	use_frameworks!

  # Pods 
  rx_swift
  pod 'SwiftyJSON'
  pod 'Alamofire', '~> 4.7.3'
  pod 'Resolver'
  pod 'KeychainAccess'

  #-------*Tests*----------
  target 'NetworkPlatformTests' do
    inherit! :search_paths
    test_pods
  end
end 



