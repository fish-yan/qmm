//
//  InvitationIncomeCell.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/12.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class InvitationIncomeCell: YSBaseTableViewCell {

    open var income: Double {
        didSet {
            self.valueLabel.text = "\(income)"
        }
    }
    open var commissionBtnHandler: (() -> ())?
    
    private var bgLayer: CAGradientLayer!
    private var container: UIView!
    private var infoLabel: UILabel!
    private var valueLabel: UILabel!
    private var actionBtn: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        income = 0.00
        
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


extension InvitationIncomeCell {
    
    func setupSubviews() -> Void {
        bgLayer = CAGradientLayer()
        
        let height = CGFloat(176.0 + (IS_FULL_SCREEN_IPHONE ? 25.0 : 0))
        bgLayer.frame = CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: height)
        bgLayer.colors = [UIColor(hexString: "#FF599E")!.cgColor, UIColor(hexString: "#FFAB68")!.cgColor]
        bgLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        bgLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        contentView.layer.addSublayer(bgLayer)
        
        // ---
        container = UIView(backgroundColor: UIColor.white, in: contentView)
        container.layer.cornerRadius = 5
        container.layer.shadowColor = UIColor.init(white: 0, alpha: 0.14).cgColor
        container.layer.shadowOffset = CGSize.zero
        container.layer.shadowRadius = 15.0
        container.layer.shadowOpacity = 1.0
        
        //
        infoLabel = UILabel(text: "已赚取收益",
                            textColor: UIColor(hexString: "#A5A5A5"),
                            font: UIFont.systemFont(ofSize: 14),
                            backgroundColor: nil,
                            in: container,
                            tapAction: nil)
        
        //
        valueLabel = UILabel(text: "¥0.00",
                             textColor: UIColor(hexString: "#313131"),
                             font: UIFont.systemFont(ofSize: 36),
                             backgroundColor: nil,
                             in: container,
                             tapAction: nil)
        
        //
        actionBtn = UIButton(title: "佣金明细",
                             titleColor: UIColor.white,
                             font: UIFont.systemFont(ofSize: 18),
                             normalImgName: nil,
                             highlightedImageName: nil,
                             bgColor: nil,
                             normalBgImageName: "invatation_btn_bg",
                             highlightedBgImageName: nil,
                             in: container,
                             action: { [unowned self] (btn) in
                                if let hander = self.commissionBtnHandler {
                                    hander()
                                }
        })
    }
    
    func setupSubviewsLayout() -> Void {
        
        container.snp.makeConstraints { (make) in
            let margin = CGFloat(70.0 + (IS_FULL_SCREEN_IPHONE ? 25.0 : 0))
            make.edges.equalTo(UIEdgeInsets(top: margin, left: 12.0, bottom: 0, right: 12.0))
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
        }
        
        actionBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(valueLabel.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 150, height: 50))
        }
    }
}
