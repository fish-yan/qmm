//
//  QMMPrivacyDeclare.swift
//  QMM
//
//  Created by Joseph Koh on 2018/12/24.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class QMMPrivacyDeclare: NSObject {
    
    private var container: UIView?
    private var maskView: UIView?
    private var webView: WKWebView?
    private var submitBtn: UIButton?
    
    @objc public class func isFirstInstall() -> Bool {
        let dict = UserDefaults.standard.object(forKey: "kFirstInstallKey")
        return (dict == nil)
    }

    @objc public func showPrivacyDeclare() {
        if container != nil {
            return
        }
        
        showSubview()
    }
 
    private func saveInfo() {
        UserDefaults.standard.setValue("1", forKey: "kFirstInstallKey")
        
    }
    private func hiddenAllSubviews() {
        container?.removeFromSuperview()
    }
    
    private func showSubview() {
        let window = UIApplication.shared.keyWindow
        
        container = UIView(backgroundColor: UIColor(white: 1, alpha: 0.5), in: window)
        container?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        maskView = UIView(backgroundColor: UIColor(white: 0, alpha: 0.5), in: container)
        maskView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        
        
        let config = WKWebViewConfiguration()
        
        webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView?.layer.cornerRadius = 10;
        webView?.clipsToBounds = true
        container!.addSubview(webView!)
        
        webView!.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets(top: 100, left: 25, bottom: 125, right: 25))
        })
        
//        let url = URL.init(string: "http://www.huayuanvip.com/protcol2.html")
//        let request = URLRequest.init(url: url!)
//        webView?.load(request)
        
        let path = Bundle.main.path(forResource: "PrivacyDeclare", ofType: "html")
        if let path = path {
            let url = URL.init(fileURLWithPath: path)
            let request = URLRequest.init(url: url)
            webView?.load(request)
        }
        
        submitBtn = UIButton(title: "确定",
                             titleColor: UIColor(hexString: "#464646"),
                             font: UIFont.systemFont(ofSize: 18),
                             normalImgName: nil,
                             highlightedImageName: nil,
                             bgColor: UIColor(hexString: "#BDFED7"),
                             normalBgImageName: "",
                             highlightedBgImageName: nil,
                             in: container,
                             action: { [unowned self] (btn) in
                                self.saveInfo()
                                self.hiddenAllSubviews()
        })
        submitBtn?.layer.cornerRadius = 35.0 * 0.5
        submitBtn?.clipsToBounds = true
        
        submitBtn?.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo((self.webView?.snp.bottom)!).offset(75)
            make.size.equalTo(CGSize(width: 100, height: 35))
        }
    }
}
