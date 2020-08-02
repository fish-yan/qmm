//
//  CompleteInfoVC.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/16.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class CompleteInfoVC: YSBaseViewController {

    private let bgImageV = UIImageView(image: UIImage(named: "login_bg"))
    
    private var viewModel: CompleteInfoVM!
    private var tableView: UITableView!
    private var pickerView: YSPickerView?
    private var imgPicker: ImagePickerHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
        setupSubviews()
        setupSubviewsLayout()
        bind()
    }
    

}

extension CompleteInfoVC {
    
    private func bind() {
        self.viewModel.savaInfoCmd.executing.skip(1).subscribeNext { (b) in
            if b?.boolValue == true {
                YSProgressHUD.showIndeterminate()
            }
        }
        
        self.viewModel.savaInfoCmd.executionSignals.switchToLatest().subscribeNext { [unowned self] (x) in
            QMMUserContext.share()?.fetchLatestUserinfo(successHandle: { (m) in
                YSProgressHUD.hiddenHUD()
                self.go2NextStep()
            }, failureHandle: { (error) in
                YSProgressHUD.hiddenHUD()
                self.go2NextStep()
            })
            
        }
        
        self.viewModel.savaInfoCmd.errors.subscribeNext { (error) in
            YSProgressHUD.showTips(error?.localizedDescription)
        }
        
    }

    private func go2NextStep() {
        let model = QMMUserContext.share()?.userModel
        /*
         UserInfoTypeRegister = 1,           // 用户新注册
         UserInfoTypeNoAvatar,               // 需要上传头像
         UserInfoTypeComplete,               // 信息完整
         UserInfoTypeZhiMaCertifiedNo,       // 没有芝麻认证
         UserInfoTypeZhiMaCertifiedHadPay,   // 有芝麻认证, 并支付成功
         UserInfoTypeZhiMaCertifiedNoPay,    // 有芝麻认证, 但没有支付
         */
        
        switch model?.iscomplete {
        case .noCertifiedHadPay?:
            QMMUIAssistant.shareInstance().setTabBarVCAsRootVCCommand.execute(nil)
        default:
            let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "FYLoginVIPViewController")
            navigationController?.pushViewController(vc, animated: true)
            break
        }
        
    }
    
    private func uploadAvatars(avatar: UIImage?) {
        guard let avatar = avatar else {
            return
        }
        
        YSProgressHUD.showIndeterminate()
        
        QMMImageUploadHelper.shareInstance().uploadImages([avatar],
                                                                withSuccessBlock: { [unowned self] (x) in
                                                                    YSProgressHUD.hiddenHUD()
                                                                    let imgUrls = x?.data as? Array<String>
                                                                    self.viewModel.avatar = imgUrls?.last
        }) { (error) in
            YSProgressHUD.showTips(error?.localizedDescription)
        }
    }
    
    private func saveAction() {
        self.closeKeyboard()
        
        if ( self.viewModel.avatar == nil) {
            YSProgressHUD.showTips("请上传头像")
            return;
        }
        
        guard self.viewModel.nickName != nil,
            self.viewModel.birthday != nil,
            self.viewModel.workareaCode != nil,
            self.viewModel.height != nil,
            self.viewModel.constellation != nil,
            self.viewModel.salary != nil
        else {
            YSProgressHUD.showTips("资料未填写完全")
            return
        }
        
        self.viewModel.savaInfoCmd.execute(nil)
    }
    
    private func closeKeyboard() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    private func showImagePickerView(avatarBtn: UIButton) {
        self.closeKeyboard()
        
        if imgPicker == nil {
            imgPicker = ImagePickerHelper.init()
            imgPicker?.uploadType = .avatar
        }
        
        imgPicker?.showImagePicker(inVC: self, selectedHandler: { [unowned self](imgs) in
            let avatar = imgs?.last
            avatarBtn.setImage(avatar, for: .normal)
            self.uploadAvatars(avatar: avatar)
        })
    }
}


private struct ReuseID {
    static let avatar = "avatar"
    static let info = "info"
}


extension CompleteInfoVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = self.viewModel.dataArray[section]
        return arr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let m = viewModel.dataArray[indexPath.section][indexPath.row]

        switch m.cellType {
        case .avatar:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.avatar, for: indexPath) as! CompleteInfoAvatarCell
            cell.avatarClickHandler = { [unowned self] (btn) in
                self.showImagePickerView(avatarBtn: btn)
            }
            cell.avatarUrl = self.viewModel.avatar
            return cell
            
        case .input, .gender, .selector:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.info, for: indexPath) as! CompleteInfoCell
            cell.cellModel = m
            cell.rectType = m.rectType
            cell.inputHandler = {[unowned self] (str) in
                m.value = str
                self.viewModel.nickName = str
            }
            if m.title == "选择性别" {
                cell.genderSwitchHandler = {[unowned self] (isMale) in
                    self.viewModel.isMale = isMale
                    m.value = isMale
                }
            }
            return cell
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let m = self.viewModel.dataArray[indexPath.section][indexPath.row]
        
        if m.cellType == .avatar {
            return 150
        }
        else if m.rectType == .top || m.rectType == .bottom {
            return 85
        }
        
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.viewModel.dataArray[indexPath.section][indexPath.row]
        
        if model.cellType != .selector {
            return
        }
        
        closeKeyboard()
        
        if pickerView == nil {
            pickerView = YSPickerView(type: .single)
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! CompleteInfoCell
        
        if model.title == "出生日期" {
            pickerView?.type = .date
            pickerView?.show(withDataArray: nil, sureHandle: { [unowned self](arr) in
                let m = arr?.last
                self.viewModel.birthday = m?.name
                model.value = m?.name
                cell.infoLabel.text = m?.name
            })
        }
        else if model.title == "工作地点" {
            pickerView?.type = .triple
            pickerView?.show(withDataArray: YSPickerViewData.share()?.places, sureHandle: { [unowned self](arr) in
                
                guard let arr = arr else {
                    return
                }
                
                let m0 = arr[0]
                let m1 = arr[1]
                let m2 = arr[2]
                
                let str = m0.name + " " + m1.name + " " + m2.name
                model.value = str
                self.viewModel.workareaCode = m2.mid
                self.viewModel.workarea = str
                cell.infoLabel.text = str
            })
        }
        else if model.title == "身高" {
            pickerView?.type = .single
            pickerView?.show(withDataArray: YSPickerViewData.share()?.heightRange, sureHandle: { [unowned self](arr) in
                let m = arr?.last
                
                self.viewModel.height = m?.name
                model.value = m?.name
                cell.infoLabel.text = m?.name
            })
        }
        else if model.title == "星座" {
            pickerView?.type = .single
            pickerView?.show(withDataArray: YSPickerViewData.share()?.constellation, sureHandle: { [unowned self] (arr) in
                let m = arr?.last
                
                self.viewModel.constellation = m?.name
                self.viewModel.constellationCode = m?.mid
                model.value = m?.name
                cell.infoLabel.text = m?.name
            })
            
        }
        else if model.title == "月收入" {
            pickerView?.type = .single
            pickerView?.show(withDataArray: YSPickerViewData.share()?.salary, sureHandle: { [unowned self](arr) in
                let m = arr?.last
                
                self.viewModel.salary = m?.mid
                self.viewModel.salaryStr = m?.name
                model.value = m?.name
                cell.infoLabel.text = m?.name
            })
        }
        
    }
    
}

extension CompleteInfoVC {
    func initialization() {
        navigationItem.title = "完善资料（1/2）"
        viewModel = CompleteInfoVM.init()
    }
    
    override func setupSubviews() {
        view.addSubview(bgImageV)
        
        tableView = UITableView(of: .grouped,
                                in: view,
                                withDatasource: self,
                                delegate: self)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(CompleteInfoAvatarCell.self, forCellReuseIdentifier: ReuseID.avatar)
        tableView.register(CompleteInfoCell.self, forCellReuseIdentifier: ReuseID.info)
        
        tableView.tableFooterView = footerView()
    }
    
    override func setupSubviewsLayout() {
        bgImageV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func footerView() -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 100))
        
        let btn = UIButton(normalImgName: "ic_login_arrow",
                           bgColor: UIColor(hexString: "#BDFED7"),
                           in: container) {[unowned self] (btn) in
                            self.saveAction()
        }
        
        btn?.layer.cornerRadius = 25
        
        btn?.snp.makeConstraints({ (make) in
            make.top.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(130)
        })
        return container
    }
}
