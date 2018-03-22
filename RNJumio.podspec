require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name           = 'RNJumio'
  s.version        = package['version']
  s.summary        = 'React Native Jumio SDK wrapper'
  s.license        = package['license']
  s.author         = 'Wave Accounting Inc.'
  s.homepage       = 'https://github.com/waveaccounting/jumio-mobile-react'
  s.source         = { git: 'https://github.com/waveaccounting/jumio-mobile-react' }

  s.requires_arc   = true
  s.platform       = :ios, '8.0'
  s.static_framework = true

  s.source_files   = 'ios/*.{h,m}'

  s.dependency 'React'
  s.dependency 'JumioMobileSDK'
end
