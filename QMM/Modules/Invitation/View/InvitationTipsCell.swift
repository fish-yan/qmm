//
//  InvitationTipsCell.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/12.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class InvitationTipsCell: YSBaseTableViewCell {

    private var titleLabel: UILabel!
    
    private var title1Label: UILabel!
    private var title2Label: UILabel!
    private var title3Label: UILabel!
    
    private var info1Label: UILabel!
    private var info2Label: UILabel!
    private var info3Label: UILabel!
    
    var price: Int = 0 {
        didSet {
            let attrM1 = NSMutableAttributedString()
            attrM1.append(normalAttributedString(name: "每邀请1位好友成功注册认证，邀请人即可获得") ?? NSAttributedString())
            attrM1.append(heighlightAttributedString(name: "\(price)元现金奖励") ?? NSAttributedString())
            info1Label.attributedText = attrM1
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialization()
        setupSubviews()
        setupSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialization() {
        
    }
}


extension InvitationTipsCell {
    func setupSubviews() {
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.attributedText = titleAttribuedString(name: "  福利大放送  ")
        
        //
        title1Label = createTitleLabel(name: "福利一：")
        title2Label = createTitleLabel(name: "福利二：")
        title3Label = createTitleLabel(name: "通关秘籍：")
        
        info1Label = createInfoLabel();
        info2Label = createInfoLabel();
        info3Label = createInfoLabel();
        
        //
        let attrM1 = NSMutableAttributedString()
        attrM1.append(normalAttributedString(name: "每邀请1位好友成功注册认证，邀请人即可获得") ?? NSAttributedString())
        attrM1.append(heighlightAttributedString(name: "\(price)元现金奖励") ?? NSAttributedString())
        info1Label.attributedText = attrM1
        
        let attrM2 = NSMutableAttributedString()
        attrM2.append(normalAttributedString(name: "佣金奖励") ?? NSAttributedString())
        attrM2.append(heighlightAttributedString(name: "无上限") ?? NSAttributedString())
        attrM2.append(normalAttributedString(name: "，能者多劳哟。") ?? NSAttributedString())
        info2Label.attributedText = attrM2
        
        let attrM3 = NSMutableAttributedString()
        attrM3.append(normalAttributedString(name: "通过【邀请好友赚佣金】或【复制我的注册链接】给好友，好友通过您的分享链接进行注册并认证进入首页，即可获得邀请佣金。") ?? NSAttributedString())
        info3Label.attributedText = attrM3
    }
    
    
    
    
    func setupSubviewsLayout() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(27)
        }
        
        let padding = 15.0
        let margin = 15.0
        
        title1Label.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(67)
            make.left.equalToSuperview().offset(padding)
        }
        
        info1Label.snp.makeConstraints { (make) in
            make.left.equalTo(title1Label.snp.right).offset(2)
            make.top.equalTo(title1Label)
            make.right.equalToSuperview().offset(-padding)
        }
        
        
        //
        title2Label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(padding)
            make.top.equalTo(info1Label.snp.bottom).offset(margin)
        }
        
        info2Label.snp.makeConstraints { (make) in
            make.left.equalTo(title2Label.snp.right).offset(2)
            make.top.equalTo(title2Label)
            make.right.equalToSuperview().offset(-padding)
        }
        
        //
        title3Label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(padding)
            make.top.equalTo(info2Label.snp.bottom).offset(margin)
        }
        
        info3Label.snp.makeConstraints { (make) in
            make.left.equalTo(title3Label.snp.right).offset(2)
            make.top.equalTo(title3Label)
            make.right.equalToSuperview().offset(-padding)
        }
        
        title1Label.setContentCompressionResistancePriority(.required, for: .horizontal)
        title2Label.setContentCompressionResistancePriority(.required, for: .horizontal)
        title3Label.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
   
    
    func titleAttribuedString(name: String) -> NSAttributedString? {
        let attach = NSTextAttachment()
        
        attach.image = UIImage(named: "invation_line")
        attach.bounds = CGRect(x: 0, y: 5, width: 100, height: 1)
        let lineAttr = NSAttributedString(attachment: attach)
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FF5D9C")
        ]
        
        
        let attrM = NSMutableAttributedString(attributedString: lineAttr)
        attrM.append(NSAttributedString(string: name, attributes: attributes))
        attrM.append(lineAttr)
        
        return attrM.copy() as? NSAttributedString
    }
    
    func heighlightAttributedString(name: String) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FE4545")
        ]
        
        let attrM = NSMutableAttributedString(string: name, attributes: attributes)
        return attrM.copy() as? NSAttributedString
    }
    
    func normalAttributedString(name: String) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#878787")
        ]
        
        let attrM = NSMutableAttributedString(string: name, attributes: attributes)
        return attrM.copy() as? NSAttributedString
    }
    
    func createTitleLabel(name: String) -> UILabel {
        return UILabel(text: name,
                       textColor: UIColor(hexString: "#FF5D9C"),
                       font: UIFont.boldSystemFont(ofSize: 15),
                       in: contentView,
                       tapAction: nil)
    }
    
    
    func createInfoLabel() -> UILabel {
        let label =  UILabel(text: nil,
                             textColor: nil,
                             font: UIFont.systemFont(ofSize: 14),
                             in: contentView,
                             tapAction: nil)
        label?.numberOfLines = 0
        
        return label!
    }
}
