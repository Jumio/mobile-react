require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = package["name"]
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-jumio-mobilesdk
                   DESC
  s.homepage     = "https://github.com/Jumio/mobile-react"
  s.license      = package["license"]
  s.authors      = { "Jumio Corporation" => "support@jumio.com" }
  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/Jumio/mobile-react.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,m,swift}"
  s.requires_arc = true

  s.pod_target_xcconfig = {
      'OTHER_SWIFT_FLAGS' => '-no-verify-emitted-module-interface',
  }

  s.dependency "React-Core"
  s.dependency "Jumio", "4.5.0"
end
