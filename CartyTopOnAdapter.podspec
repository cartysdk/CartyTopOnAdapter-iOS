Pod::Spec.new do |spec|
  spec.name         = "CartyTopOnAdapter"
  spec.version      = "0.0.1"
  spec.summary      = "CartyTopOnAdapter"
  spec.description  = <<-DESC
             CartyTopOnAdapter for iOS. 
                   DESC
  spec.homepage     = "https://github.com/cartysdk/CartyTopOnAdapter-iOS"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "carty" => "ssp_tech@carty.io" } 
  spec.source       = { :git => "https://github.com/cartysdk/CartyTopOnAdapter-iOS.git", :tag => spec.version }
  spec.platform     = :ios, '13.0'
  spec.ios.deployment_target = '13.0'
  spec.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '-ObjC'
  }
  spec.dependency 'CartySDK'
  spec.static_framework = true
  spec.default_subspecs = 'CartyTopOnAdapter'

  spec.subspec 'CartyTopOnAdapter' do |ss|
    ss.source_files = 'CartyTopOnAdapter/*.{h,m}'
    ss.dependency 'TPNiOS','> 6.4.93'
  end

  spec.subspec '6493' do |ss|
    ss.source_files = 'CartyTopOnAdapter6493/*.{h,m}'
    ss.dependency 'TPNiOS','<= 6.4.93'
  end
end