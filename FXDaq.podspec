Pod::Spec.new do |s|
  s.name         = "FXDaq"
  s.version      = "1.0.1"
  s.summary      = "数据收集模块"

  s.homepage     = "https://github.com/zqw87699/FXDaq"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = {"zhangdazong" => "929013100@qq.com"}

  s.source       = { :git => "https://github.com/zqw87699/FXDaq.git", :tag => "#{s.version}"}

  s.platform     = :ios, "7.0"

  s.source_files  = "Classes/*.{h,m}"

  s.public_header_files = "Classes/*.h"

  s.frameworks = "Foundation", "UIKit"

  s.module_name = 'FXDaq' 

  s.requires_arc = true

  s.dependency "FXCommon"
  s.dependency "FXHttpEngine"
  s.dependency "FXAppContext"

end