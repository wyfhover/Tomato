Pod::Spec.new do |s|
  s.name             = 'Tomato'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Tomato.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wyfhover/Tomato'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wyfhover@163.com' => 'yf_wen@edifier.com' }
  s.source           = { :git => 'https://github.com/wyfhover/Tomato.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }

  s.source_files = 'Tomato/Classes/**/*'
end
