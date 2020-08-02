//
//  CompleteInfoCell.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/16.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class CompleteInfoCell: YSBaseTableViewCell {
    
    private var bgImgV: UIImageView!
    private var container: UIView!
    
    
    public var genderSwitchHandler: ((_ isMale: Bool) -> ())?
    public var inputHandler: ((_ input: String) -> ())?
    
    public var titleLabel: UILabel!
    
    public var inputField: UITextField!
    
    public var maleBtn: UIButton!
    public var femaleBtn: UIButton!
    
    public var infoLabel: UILabel!
    public var arrowImgV: UIImageView!
    
    
    var rectType = CellRectType.middle {
        didSet {
            switch rectType {
            case .top:
                self.bgImgV.image = UIImage(named: "cell_bg_top")
                
                container.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(30)
                    make.right.equalToSuperview().offset(-30)
                    make.bottom.equalToSuperview().offset(0)
                    make.height.equalTo(55)
                }
            case .middle:
                self.bgImgV.image = UIImage(named: "cell_bg_middle")
                container.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(30)
                    make.right.equalToSuperview().offset(-30)
                    make.top.equalToSuperview().offset(0)
                    make.height.equalTo(55)
                }
            case .bottom:
                self.bgImgV.image = UIImage(named: "cell_bg_bottom")
                container.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(30)
                    make.right.equalToSuperview().offset(-30)
                    make.top.equalToSuperview().offset(0)
                    make.height.equalTo(55)
                }
            }
        }
    }
    
    public var cellModel: CompleteInfoCellModel? {
        didSet {
            guard let model = cellModel else {
                return
            }
            switch model.cellType {
            case .avatar:
                break
            case .input:
                self.inputField.isHidden = false
                self.maleBtn.isHidden = true
                self.femaleBtn.isHidden = true
                self.arrowImgV.isHidden = true
                self.infoLabel.isHidden = true
                
                self.inputField.placeholder = model.placeHolder
                self.inputField.text = cellModel?.value as? String
                
            case .gender:
                self.maleBtn.isHidden = false
                self.femaleBtn.isHidden = false
                self.inputField.isHidden = true
                self.arrowImgV.isHidden = true
                self.infoLabel.isHidden = true
                
                if let b = model.value as? Bool {
                    self.maleBtn.isSelected = b
                    self.femaleBtn.isSelected = !b
                }
                
            case .selector:
                self.arrowImgV.isHidden = false
                self.infoLabel.isHidden = false
                self.maleBtn.isHidden = true
                self.femaleBtn.isHidden = true
                self.inputField.isHidden = true
                
                self.infoLabel.text = cellModel?.value as? String ?? "请选择"
            }
            
            self.titleLabel.isHidden = false
            self.titleLabel.text = model.title
        }
    }
    
    
    private func drawTopShadowPath() -> CGPath {
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: self.frame.maxY))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.maxX, y: 0))
        path.addLine(to: CGPoint(x: self.frame.maxX, y: self.frame.maxY))
        path.close()
        
        return path.cgPath
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        setupSubviews()
        setupSubviewsLayout()
        bind()
        
        maleBtn.isSelected = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CompleteInfoCell {
    private func bind() {
        inputField.rac_textSignal().subscribeNext {[unowned self] (str) in
            if let str = str, let handler = self.inputHandler {
                handler(str as String)
            }
        }
    }
    
    @objc private func switchGender(btn: UIButton) {
        UIApplication.shared.keyWindow?.endEditing(true)
        
        let isMale = (btn.tag == 101)
        
        maleBtn.isSelected = isMale
        femaleBtn.isSelected = !isMale
        
        if let hander = genderSwitchHandler {
            hander(isMale)
        }
    }
}


extension CompleteInfoCell: UITextFieldDelegate {
    func setupSubviews() {
        bgImgV = UIImageView()
        contentView.addSubview(bgImgV)
        
        container = UIView(backgroundColor: nil, in: contentView)
        
        titleLabel = UILabel(text: "",
                             textColor: UIColor(hexString: "#393939"),
                             font: UIFont.systemFont(ofSize: 15),
                             in: container,
                             tapAction: nil)
        
        inputField = UITextField(text: nil,
                                textColor: UIColor(hexString: "#A5A5A5"),
                                font: UIFont.systemFont(ofSize: 14),
                                placeHolder: "请填写您的昵称",
                                placeHolderColor: UIColor(hexString: "#A5A5A5"),
                                andDelegate: self,
                                in: container)
        inputField.textAlignment = .right
        
        
        maleBtn = createGenderBtn(isMale: true)
        femaleBtn = createGenderBtn(isMale: false)
        
        arrowImgV = UIImageView(imageName: "ic_arrow_right", in: container)
        infoLabel = UILabel(text: "请选择",
                            textColor: UIColor(hexString: "#A5A5A5"),
                            font: UIFont.systemFont(ofSize: 14),
                            in: container,
                            tapAction: nil)
    }
    
    func createGenderBtn(isMale: Bool) -> UIButton {
        let btn = UIButton(type: .custom)
        
        var imgN = UIImage(named: "ic_login_female_n")
        var imgS = UIImage(named: "ic_login_female_s")
        if isMale == true {
            imgN = UIImage(named: "ic_login_male_n")
            imgS = UIImage(named: "ic_login_male_s")
        }
        
        btn.setImage(imgN, for: .normal)
        btn.setImage(imgS, for: .selected)
        btn.tag = 100 + (isMale ? 1 : 0)
        
        btn.addTarget(self, action: #selector(switchGender(btn:)), for: .touchUpInside)
        container.addSubview(btn)
        
        return btn
    }
    
    func setupSubviewsLayout() {
        bgImgV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(55)
        }
        
        
        let padding = 15.0
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(padding)
            make.centerY.equalToSuperview()
        }
        
        inputField.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-padding)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(250)
        }
        
        
        femaleBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.right.equalToSuperview().offset(-padding)
            make.centerY.equalToSuperview()
        }
        
        maleBtn.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(femaleBtn)
            make.right.equalTo(femaleBtn.snp.left).offset(-10)
        }
        
        arrowImgV.snp.makeConstraints { (make) in
            make.size.equalTo(arrowImgV.image?.size ?? CGSize(width: 7, height: 13))
            make.right.equalToSuperview().offset(-padding)
            make.centerY.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImgV.snp.left).offset(-5)
            make.centerY.equalTo(arrowImgV)
        }
        
    }
}
