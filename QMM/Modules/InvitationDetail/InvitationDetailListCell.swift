//
//  InvitationDetailListCell.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/13.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class InvitationDetailListCell: YSBaseTableViewCell {

    open var model: InvitationDetailModel? {
        didSet {
            self.titleLabel.text = model?.invitemobile
            self.infoLabel.text = model?.invitestatus2
            self.timeLabel.text = model?.inviteregdate2
        }
    }
    
    private var titleLabel: UILabel!
    private var timeLabel: UILabel!
    private var infoLabel: UILabel!
    
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
        showTopLine = true
        
    }
}

extension InvitationDetailListCell {
    func setupSubviews() {
        titleLabel = UILabel(text: nil,
                             textColor: UIColor(hexString: "#464646"),
                             font: UIFont.systemFont(ofSize: 15),
                             in: contentView,
                             tapAction: nil)
        timeLabel = UILabel(text: nil,
                            textColor: UIColor(hexString: "#A9A9A9"),
                            font: UIFont.systemFont(ofSize: 14),
                            in: contentView,
                            tapAction: nil)
        infoLabel = UILabel(text: nil,
                             textColor: UIColor(hexString: "#FE4545"),
                             font: UIFont.systemFont(ofSize: 18),
                             in: contentView,
                             tapAction: nil)
    }
    
    func setupSubviewsLayout() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(13)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
}
