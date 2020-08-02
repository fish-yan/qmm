//
//  InvitationDetailVC.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/13.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class InvitationDetailVC: YSBaseViewController {

    private var items = ["全部", "成功", "进行中"]
    private lazy var allVC: InvitationDetailListVC = {
        let vc = InvitationDetailListVC()
        vc.type = .all
        return vc
    }()
    
    private lazy var successVC: InvitationDetailListVC = {
        let vc = InvitationDetailListVC()
        vc.type = .success
        return vc
    }()
    
    private lazy var ingVC: InvitationDetailListVC = {
        let vc = InvitationDetailListVC()
        vc.type = .ing
        return vc
    }()
    
    private lazy var maginViewController: VTMagicController = {
        let magicController = VTMagicController()
        
        magicController.view.translatesAutoresizingMaskIntoConstraints = false
        magicController.magicView.switchStyle = .default
        magicController.magicView.sliderStyle = .default
        magicController.magicView.navigationColor = UIColor.white
        magicController.magicView.isSliderHidden = false
        magicController.magicView.sliderColor = UIColor(patternImage: (UIImage(named: "tab_bg"))!)
        magicController.magicView.layoutStyle = .center
        magicController.magicView.needPreloading = false
        
        magicController.magicView.dataSource = self
        magicController.magicView.delegate = self
        self.addChild(magicController)
        
        return magicController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
        setupSubviews()
        
        extendedLayoutIncludesOpaqueBars = false;
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
        navigationItem.title = "邀请详情"
    }
    
    override func setupSubviews() {
        view.addSubview(self.maginViewController.view)
        
        maginViewController.view.snp.makeConstraints { (make) in
            let topMargin = IS_FULL_SCREEN_IPHONE ? 88 : 64;
            make.top.equalToSuperview().offset(topMargin)
            make.left.bottom.right.equalToSuperview();
        }
        
        view.setNeedsUpdateConstraints()
        maginViewController.magicView.reloadData()
    }

}

extension InvitationDetailVC: VTMagicViewDelegate, VTMagicViewDataSource {
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        switch pageIndex {
        case 0:
            return self.allVC
        case 1:
            return self.successVC
        case 2:
            return self.ingVC
        default:
            return UIViewController()
        }
    }
    
    
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return items
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        var btn = magicView.dequeueReusableItem(withIdentifier: "reuseID")
        if btn == nil {
            btn = UIButton(type: .custom)
            btn?.setTitleColor(UIColor(hexString: "#464646"), for: .normal)
        }
        
        btn!.setTitle(self.items[Int(itemIndex)], for: .normal)
        return btn!
    }
}
