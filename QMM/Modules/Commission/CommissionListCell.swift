//
//  CommissionListCell.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/13.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class CommissionListCell: YSBaseTableViewCell {

    private var viewModel: CommissionListVM! {
        didSet {
            self.titleLabel.text = viewModel.title ?? ""
            self.priceLabel.text = viewModel.price ?? ""
            self.timeLabel.text = viewModel.time ?? ""
        
        }
    }
    private var titleLabel: UILabel!
    private var timeLabel: UILabel!
    private var priceLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialization()
        setupSubviews()
        setupSubviewsLayout()
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func initialization() {
        showTopLine = true
        
    }
}

extension CommissionListCell {
    override func bind(withViewModel vm: Any!) {
        if let vm = vm as? CommissionListVM {
            viewModel = vm
        }
        else {
            
        }
    }
    
    func bind() {
        
    }
}

extension CommissionListCell {
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
        priceLabel = UILabel(text: nil,
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
        
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
}
