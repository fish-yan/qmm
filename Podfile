source 'https://github.com/cocoaPods/Specs.git'
source 'https://gitee.com/peanutgao/YSPrivateSpecs.git'

platform :ios, '8.0'

inhibit_all_warnings!
#use_modular_headers!
#use_frameworks!


#pre_install do |installer|
#    # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
#    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
#end
#
#post_install do |installer|
#    installer.pods_project.targets.each do |target|
#        target.build_configurations.each do |config|
#            target.build_settings(config.name)['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
#        end
#    end
#end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            end
        end
    end
end


abstract_target 'BASE_POD' do
    # Swift
    pod 'SnapKit'
    
    # OC
	pod 'MBProgressHUD'
	pod 'AFNetworking'
    pod 'ReactiveCocoa'#, :modular_headers => true
#    
#    pod 'ReactiveObjC', :modular_headers => true
#    pod 'ReactiveObjCBridge'

	pod 'Masonry'
	pod 'SDWebImage'
	pod 'FLAnimatedImage'
	pod 'FMDB'
	pod 'LKDBHelper'
	pod 'MJExtension'
	pod 'Base64'
	pod 'MJRefresh'
	pod 'MTDates'
	pod 'UITableView+FDTemplateLayoutCell'
	#pod 'OpenUDID', '>= 1.0.0'
	pod 'VTMagic', :git => 'https://github.com/tianzhuo112/VTMagic.git'
	pod 'libqrencode'
	pod 'WebViewJavascriptBridge'

	pod 'IDMPhotoBrowser'
	pod 'TZImagePickerController'
	#pod 'XLPhotoBrowser+CoderXL'
	pod 'GrowingIO'
	#pod 'YSNurse', :git => 'https://github.com/peanutgao/YSNurse.git'
	pod 'YSMediator', :git => 'https://github.com/peanutgao/YSMediator.git'
	#pod 'YYText', '>= 1.0.7'
	pod 'YYCache'
	pod 'JPush'
	pod 'IQKeyboardManager'
	pod 'SDCycleScrollView'
  pod 'SwiftyJSON'
  pod 'HandyJSON'
    #pod 'TTTAttributedLabel'
	#内存泄露
	#pod 'MLeaksFinder', '>= 0.2.1'
    pod 'FBRetainCycleDetector'

    
    pod 'YSProjectBaseModule'#, :path => '../../PrivateRepos/YSProjectBaseModule'
    pod 'YSToolsKit'#, :path => '../../PrivateRepos/YSToolsKit'
    pod 'YSProjectRequest'#, :path => '../../PrivateRepos/YSProjectRequest'

	#第三方服务平台

	#七牛
	pod 'Qiniu', :git => 'https://github.com/qiniu/objc-sdk.git', :branch => 'AFNetworking-3.x'

    # U-Share SDK UI模块（分享面板，建议添加）
    pod 'UMCShare/UI'
    pod 'UMCShare/Social/ReducedWeChat'
    
    # pod 'WechatOpenSDK'

#    #ShareSDK
#    # 主模块(必须)
#    pod 'mob_sharesdk'
#
#    # UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
#    pod 'mob_sharesdk/ShareSDKUI'
#
#    # 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
#    pod 'mob_sharesdk/ShareSDKPlatforms/QQ'
#    pod 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
##    pod 'mob_sharesdk/ShareSDKPlatforms/WeChat'
#    pod 'mob_sharesdk/ShareSDKPlatforms/WeChatFull'

	#地图S
	#pod 'BaiduMapKit', '~> 3.3.0'
	#pod 'BaiduMapKit', '>= 3.3.0'
    
	pod 'AMapLocation'
	pod 'AMap2DMap'
	pod 'AMapSearch'

	#个推
	#pod 'GTSDK', '>= 1.6.3.0-noidfa'
	#pod 'GTExtensionSDK', '>= 1.2.0'

	#崩溃记录
	pod 'Bugly'

	target 'QMM' do
        
	end
end

