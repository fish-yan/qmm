//
//  CompleteInfoAvatarCell.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/16.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class CompleteInfoAvatarCell: YSBaseTableViewCell {
    var avatarUrl: String? {
        didSet {
            let url = URL.init(string: avatarUrl ?? "")
            self.avatarBtn.sd_setImage(with: url, for: .normal, placeholderImage: nil)
            
        }
    }
    public var avatarClickHandler: ((_ avatar: UIButton) -> ())?
    
    private var container: UIView!
    private var avatarBtn: UIButton!
    private var titleLabel: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        setupSubviews()
        setupSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CompleteInfoAvatarCell {
    @objc func chooseAvatar() {
        if let handler = avatarClickHandler {
            handler(self.avatarBtn)
        }
    }
}

extension CompleteInfoAvatarCell {
    func setupSubviews() {
        container = UIView(backgroundColor: UIColor.white, in: contentView)
        container.layer.shadowOffset = CGSize.zero
        container.layer.shadowColor = UIColor(hexString: "#540A73", alpha: 0.28)?.cgColor
        container.layer.shadowOpacity = 1
        container.layer.shadowRadius = 15
        container.layer.cornerRadius = 10
        
        
        
        avatarBtn = UIButton(type: .custom)
        avatarBtn.layer.cornerRadius = 73 * 0.5
        avatarBtn.clipsToBounds = true
        avatarBtn.setBackgroundImage(UIImage(named: "ic_login_camera"), for: .normal)
        avatarBtn.addTarget(self, action: #selector(chooseAvatar), for: .touchUpInside)

        container.addSubview(avatarBtn)
        
        
        titleLabel = UILabel(text: "点击上传头像",
                             textColor: UIColor(hexString: "#A5A5A5"),
                             font: UIFont.systemFont(ofSize: 14),
                             in: container,
                             tapAction: nil)
        
    }
    
    func setupSubviewsLayout() {
        container.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 15, left: 30, bottom: 5, right: 30))
        }
        
        avatarBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(73)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarBtn.snp.bottom).offset(10)
        }
    }
}
