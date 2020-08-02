//
//  InvitationShareVC.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/13.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class InvitationShareVC: YSBaseViewController {

    public var qrImgURL: URL?
    public var invitatURL: String?
    
    public var sharepic: String?
    public var sharetitle: String?
    public var sharedesc: String?
    public var referurl: String?
    
    private var container: UIView!
    private var tipsLable: UILabel!
    private var qrImgV = UIImageView()
    
    private var shareTips: UILabel!
    private var shareItems = [UIImageView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
        setupSubviews()
        setupSubviewsLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.setBackgroundImage(navBgImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func navBgImage() -> UIImage? {
        let gradient = CAGradientLayer()
        let h = IS_FULL_SCREEN_IPHONE ? (44.0 + 44.0) : (20.0 + 44.0)
        gradient.frame = CGRect(x: 0, y: 0, width: Double(SCREEN_WIDTH), height: Double(h))
        gradient.colors = [UIColor(hexString: "#FF599E").cgColor,
                           UIColor(hexString: "#FFAB68").cgColor];
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        UIGraphicsBeginImageContext(gradient.frame.size)
        
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    
    func initialization() {
        navigationItem.title = "马上邀请"
    }

    
    @objc func shareClick(gesturer: UITapGestureRecognizer) {
        let v = gesturer.view
        if let v = v {
            let type = (v.tag - 300)
            shareAction(type: type)
        }
    }
}

enum ShareType: Int {
    case wx = 0
    case moment
}

extension InvitationShareVC {
    
    func shareAction(type: ShareType.RawValue) {
        
        var shareType = UMSocialPlatformType.wechatSession
        
        switch type {
        case ShareType.wx.rawValue:
            break
        case ShareType.moment.rawValue:
            shareType = UMSocialPlatformType.wechatTimeLine
        default:
            return
        }
        
        let shareObject = UMShareWebpageObject.shareObject(withTitle: sharetitle,
                                                           descr: sharedesc,
                                                           thumImage: sharepic)
        shareObject?.webpageUrl = referurl
        
        let messageObject = UMSocialMessageObject()
        messageObject.shareObject = shareObject
        
        UMSocialManager.default()?.share(to: shareType,
                                         messageObject: messageObject,
                                         currentViewController: self,
                                         completion: { (data, error) in
                                            if error != nil {
                                                YSProgressHUD.showTips(error?.localizedDescription)
                                                return
                                            }
                                            
                                            if data is UMSocialResponse {
                                                let resp = data as! UMSocialShareResponse
                                                YSProgressHUD.showTips(resp.message)
                                            } else {
                                                print("分享结果数据: \(String(describing: data))")
                                            }
        })
        
        
        
        
        
//        let params = NSMutableDictionary()
//        params.ssdkSetupLineParams(byText: sharedesc, image: sharepic, type: .auto)
//
//        var share = SSDKPlatformType.subTypeWechatSession
//        switch type {
//        case ShareType.wx.rawValue:
//            break
//        case ShareType.moment.rawValue:
//            share = SSDKPlatformType.subTypeWechatTimeline
//        default:
//            return
//        }
//
//        ShareSDK.share(share, parameters: params) { (state, userdata, contentEntity, error) in
//
//            switch state {
//            case .success:
//                YSProgressHUD.showTips("分享成功")
//            case .fail:
//                print("Fail:%@",error ?? "");
//                YSProgressHUD.showTips("分享失败")
//            case .cancel:
//                YSProgressHUD.showTips("取消分享")
//            default : break
//            }
//        }
    }
}

extension InvitationShareVC {
    override func setupSubviews() {
        container = UIView(backgroundColor: UIColor.white, in: view)
        container.layer.shadowOffset = CGSize.zero
        container.layer.shadowColor = UIColor(white: 0, alpha: 0.14).cgColor
        container.layer.shadowOpacity = 1.0
        container.layer.shadowRadius = 15.0
        container.layer.cornerRadius = 5.0
        
        
        tipsLable = UILabel(text: "朋友面对面扫码下载",
                            textColor: UIColor(hexString: "#AAAAAA"),
                            font: UIFont.systemFont(ofSize: 16),
                            in: container,
                            tapAction: nil)
        
//        let baidu = "www.baidu.com"
//        let qrImg = generateQRCode(from: baidu)
        container.addSubview(self.qrImgV)
    qrImgV.sd_setImage(with: self.qrImgURL, completed: nil)
        
        //
        shareTips = UILabel(text: "更多分享方式",
                            textColor: UIColor(hexString: "#AAAAAA"),
                            font: UIFont.systemFont(ofSize: 14),
                            in: container,
                            tapAction: nil)
        
        //
        let shareArray = ["ic_invation_share_wx",
                          "ic_invation_share_moment",
//                          "ic_invation_share_qq",
//                          "ic_invation_share_wb"
        ]
        for i in 0..<shareArray.count {
            let view = createShareItem(name: shareArray[i])
            view.tag = i + 300
            self.shareItems.append(view)
        }
    }
    
    func createShareItem(name: String) -> UIImageView {
        let imgV = UIImageView(image: UIImage(named: name))
        imgV.isUserInteractionEnabled = true
        view.addSubview(imgV)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(shareClick(gesturer:)))
        imgV.addGestureRecognizer(gesture)
        
        return imgV
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    override func setupSubviewsLayout() {
        let scale = Double(SCREEN_WIDTH/375.0)
        container.snp.makeConstraints { (make) in
            let top = 40.0 + (IS_FULL_SCREEN_IPHONE ? 88.0 : 64.0)
            
            make.top.equalToSuperview().offset(top)
            make.left.equalToSuperview().offset(38)
            make.right.equalToSuperview().offset(-38)
            make.height.equalTo(scale * 350.0)
        }
        
        tipsLable.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(47)
            make.centerX.equalToSuperview()
        }
        
        qrImgV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(qrImgV.snp.width)
        }
        
        
        shareTips.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(container.snp.bottom).offset(70.0)
        }
        
        let wh = 33.0
        let size = CGSize(width: wh, height: wh)
        let margin = 20.0
        let totalItemW = wh * Double(shareItems.count)
        let totalMargin = margin * Double(shareItems.count - 1)
        let padding = (Double(SCREEN_WIDTH) - totalItemW - totalMargin) * 0.5
        for i in 0..<shareItems.count {
            let imgV = shareItems[i]
        
            let left = padding + (wh + margin) * Double(i)
            imgV.snp.makeConstraints { (make) in
                make.size.equalTo(size)
                make.left.equalToSuperview().offset(left)
                make.top.equalTo(shareTips.snp.bottom).offset(20)
            }
        }
    }
}
