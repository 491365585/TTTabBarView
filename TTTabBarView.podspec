Pod::Spec.new do |spec|

  spec.name         = "TTTabBarView"
  spec.version      = "1.0.5"
  spec.summary      = "My TTTabBarView"
  spec.description  = <<-DESC
			My TTTabBarView Test!!!
                   DESC

  spec.homepage     = "https://github.com/491365585"


  spec.license      = "MIT"
 
  spec.author       = { "mac" => "491365585@qq.com" }
  

  spec.platform     = :ios, "8.0"





  spec.source = { :git => "https://github.com/491365585/TTTabBarView.git", :tag => spec.version.to_s }
 
  spec.source_files  = "TTTabBarView", "TTTabBarView/**/*.{h,m}"
  spec.exclude_files = "TTTabBarView/Exclude"

  spec.swift_version = "4.2" 
end
