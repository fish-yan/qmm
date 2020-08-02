//
//  VertifyResultView.swift
//  QMM
//
//  Created by Joseph Koh on 2018/10/29.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

enum VertifyResultType {
    case Success
    case Failure
}

class VertifyResultView: UIView {
    /// 回调
    var actionHandler: ((_ type: VertifyResultType) -> ())?
    
    var type: VertifyResultType {
        didSet {
            var imgName = ""
            var title = ""
            var titleColor = ""
            var btnTitle = ""
            var info = ""
            switch self.type {
            case .Success: do {
                imgName = "ic_tel_yes"
                title = "认证成功"
                titleColor = "#41CC4B"
                info = "恭喜您，您的芝麻认证通过"
                btnTitle = "朕知道了"
                }
            case .Failure: do {
                imgName = "ic_tel_no"
                title = "认证失败"
                titleColor = "#FF8888"
                info = "对不起，您的芝麻认证不通过"
                btnTitle = "重新认证"
                }
            }
            
            self.icon.image = UIImage(named: imgName)
            self.titleLabel.text = title
            self.titleLabel.textColor = UIColor(hexString: titleColor)
            self.infoLabel.text = info
            self.actionBtn.setTitle(btnTitle, for: UIControl.State.normal)
    
            
            // 重新布局
            self.layoutIfNeeded()
        }
    }
    
    private var icon = UIImageView()
    private var titleLabel = UILabel()
    private var infoLabel = UILabel()
    private var actionBtn = UIButton()
    
    override init(frame: CGRect) {
        self.type = .Success
        
        super.init(frame: frame)
        
        setupSubviews()
        setupSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func clickAction() {
        if let handler = self.actionHandler  {
            handler(self.type)
        }
    }
    
}


extension VertifyResultView {
    func setupSubviews() {
        self.addSubview(icon)
        self.addSubview(titleLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        self.addSubview(titleLabel)
        
        infoLabel.textColor = UIColor(hexString: "#A5A5A5")
        infoLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.addSubview(infoLabel)
        
        actionBtn.layer.cornerRadius = 25.0
        actionBtn.clipsToBounds = true
        actionBtn.backgroundColor = UIColor(hexString: "#BDFED7")
        actionBtn.setTitleColor(UIColor(hexString: "#464646"), for: UIControl.State.normal)
        actionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        actionBtn.addTarget(self, action: #selector(clickAction), for: UIControl.Event.touchUpInside)
        self.addSubview(actionBtn)
    }
    
    func setupSubviewsLayout() {
        icon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40.0)
            make.size.equalTo(CGSize(width: 50.0, height: 59.0))
        }
        
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(15.0)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(24.0)
        }
        
        actionBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(60.0)
            make.height.equalTo(49.0)
            make.width.equalTo(200.0)
        }
    }
}
