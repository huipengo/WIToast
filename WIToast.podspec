#
# Be sure to run `pod lib lint WIToast.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WIToast'
  s.version          = '0.0.1'
  s.summary          = 'A developer Tool of WIToast.'
  s.description      = <<-DESC
WIToast is a developer Tool, Improve development efficiency.
                       DESC

  s.homepage         = 'https://github.com/huipengo/WIToast'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huipengo' => 'penghui_only@163.com' }
  s.source           = { :git => 'https://github.com/huipengo/WIToast.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'WIToast/Classes/*.{h,m}'
  s.resources    = 'WIToast/Assets/*.{bundle}'
end
