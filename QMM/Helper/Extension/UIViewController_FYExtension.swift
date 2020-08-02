//
//  UIViewController_FYExtension.swift
//  joint-operation
//
//  Created by Yan on 2018/12/1.
//  Copyright © 2018 Yan. All rights reserved.
//
import UIKit

@objc public protocol BackItemProtocol {
    func navigationShouldPopOnBackButton() -> Bool
}

extension UIViewController: BackItemProtocol {
    public func navigationShouldPopOnBackButton() -> Bool {
        return true
    }
}

extension UINavigationController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if viewControllers.count < navigationBar.items?.count ?? 0 {
            return true
        }
        guard let vc = topViewController else { return true }
        if vc.navigationShouldPopOnBackButton() {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
            return true
        } else{
            for subview in navigationBar.subviews {
                if (0.0 < subview.alpha && subview.alpha < 1.0) {
                    UIView.animate(withDuration: 0.25, animations: {
                        subview.alpha = 1.0
                    })
                }
            }
            return false
        }
    }
}


extension UIApplication {
    open override var next: UIResponder? {
        UIApplication.once
        return super.next
    }
    private static let once:Void = {
        UIViewController.swizzled()
    }()
}
//MARK: 要求重写了viewWillAppear和viewWillDisappear方法的必须调用父类方法
extension UIViewController {
    
    static func swizzled() {
        let originSelArray = [#selector(viewDidLoad)]
        for selector in originSelArray {
            let swzzledSel = "fy_" + selector.description
            if let originMethod = class_getInstanceMethod(self, selector),
                let swzzledMethod = class_getInstanceMethod(self, Selector(swzzledSel)) {
                method_exchangeImplementations(originMethod, swzzledMethod)
            }
        }
    }
    
    @objc func fy_viewDidLoad() {
        if classForCoder.description().hasPrefix("QMM.") { // 排除系统的 VC
            configNav(image: UIImage(named: "ic_nav_back"))
        }
        fy_viewDidLoad()
    }
    
    private func configNav(image: UIImage?) {
        if ((navigationController?.viewControllers.count ?? 0) > 1) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(popVC))
        }
    }
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func setNav(isColor: Bool) {
        let color = isColor ? UIColor.white : UIColor.darkText
        let img = isColor ? navBgImage() : UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        navigationController?.navigationBar.tintColor = color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func navBgImage() -> UIImage? {
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
}
