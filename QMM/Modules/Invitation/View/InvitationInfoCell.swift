//
//  InvitationInfoCell.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/12.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class InvitationInfoCell: YSBaseTableViewCell {

    open var successValue: Int {
        didSet {
            self.successValueLabel.text = String(successValue)
        }
    }
    open var ingValue: Int {
        didSet {
            self.ingValueLabel.text = String(ingValue)
        }
    }
    
    open var successClickHandler: (() -> ())?
    open var ingClickHandler: (() -> ())?
    
    private var container: UIView!
    
    private var leftContainer: UIView!
    private var successValueLabel: UILabel!
    private var successTitleLabel: UILabel!
    
    private var rightContainer: UIView!
    private var ingValueLabel: UILabel!
    private var ingTitleLabel: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        successValue = 0
        ingValue = 0
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        initialization()
        setupSubviews()
        setupSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialization() {
        backgroundColor = UIColor(hexString: "#F5F5F5")
    }
}

extension InvitationInfoCell {
    func setupSubviews()  {
        container = UIView(backgroundColor: UIColor.white, in: contentView)
        
        leftContainer = UIView(backgroundColor: nil, in: container, tapAction: { [unowned self]  (view, gesture) in
            if let hander = self.successClickHandler {
                hander()
            }
        })
        successTitleLabel = titleLabel(name: "成功邀请", inView: leftContainer)
        successValueLabel = valueLabel(name: "0", inView: leftContainer)
        
        rightContainer = UIView(backgroundColor: nil, in: container, tapAction: { [unowned self]  (view, gesture) in
            if let hander = self.ingClickHandler {
                hander()
            }
        })
        ingTitleLabel = titleLabel(name: "努力开发中", inView: rightContainer)
        ingValueLabel = valueLabel(name: "0", inView: rightContainer)
    }
    
    
    func setupSubviewsLayout() {
        container.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 15, left: 0, bottom: 10, right: 0))
        }
        
        let line = UIView(backgroundColor: UIColor(hexString: "#CECECE"), in: container)
        line!.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(13)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-13)
            make.width.equalTo(1)
        })
        
        leftContainer.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        successValueLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        
        successTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(successValueLabel.snp.bottom)
        }
        
        
        rightContainer.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        ingValueLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        
        ingTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(ingValueLabel.snp.bottom)
        }
    }
    
    
    func titleLabel(name: String?, inView: UIView) -> UILabel {
        return UILabel(text: name ?? "",
                       textColor: UIColor(hexString: "#878787"),
                       textAlignment: .center,
                       font: UIFont.systemFont(ofSize: 14),
                       backgroundColor: nil,
                       in: inView,
                       tapAction: nil)
    }
    
    func valueLabel(name: String?, inView: UIView) -> UILabel {
        return UILabel(text: name ?? "",
                       textColor: UIColor(hexString: "#313131"),
                       textAlignment: .center,
                       font: UIFont.systemFont(ofSize: 18),
                       backgroundColor: nil,
                       in: inView,
                       tapAction: nil)
    }
}
