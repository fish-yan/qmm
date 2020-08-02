//
//  InvitationVC.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/10.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class InvitationVC: YSBaseViewController {

    private var viewModel = InvitationVM()
    private var invitationShareVM = InvitationShareVM()
    
    private var tableView: UITableView!
    
    private var footerContainer: UIView!
    private var invatationBtn: UIButton!
    private var linkBtn: UIButton!
    
    private var isCopyAction = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
        setupSubviews()
        setupSubviewsLayout()
        bind()
        
        extendedLayoutIncludesOpaqueBars = true;
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false;
        };
        
        tableView.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let nav = navigationController as? YSNavigationController {
            nav.setNavigationBarDefaultAppearance()
        }
    }
    
    
    func initialization() {
        navigationItem.title = "邀请有奖"
    }

}


extension InvitationVC {
    func requestShareInfo() {
        self.invitationShareVM.fetchCmd.execute(nil)
    }
    
    @objc func requestData() {
        viewModel.fetchCmd.execute(nil)
    }
    
    func go2CommissionView() {
        let vc = CommissionListVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func go2InvitationDetailView(idx: Int) {
        let vc = InvitationDetailVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tryGo2InvitationShareView() {
        if self.invitationShareVM.qrImgURL == nil {
            requestShareInfo()
        }
        else {
            go2InvitationShareView()
        }
    }
    
    func go2InvitationShareView() {
        let vc = InvitationShareVC()
        
        vc.qrImgURL = invitationShareVM.qrImgURL
        vc.invitatURL = invitationShareVM.invitatURL
        vc.referurl = invitationShareVM.shareModel?.referurl
        vc.sharetitle = invitationShareVM.shareModel?.sharetitle
        vc.sharedesc = invitationShareVM.shareModel?.sharedesc
        vc.sharepic = invitationShareVM.shareModel?.sharepic
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func try2CopyLink() {
        if self.invitationShareVM.invitatURL == nil {
            isCopyAction = true
            requestShareInfo()
        }
        else {
            copyLink()
        }
    }
    
    func copyLink() {
        UIPasteboard.general.string = invitationShareVM.invitatURL
        YSProgressHUD.showTips("拷贝成功")
    }
    
    func bind() {
        viewModel.fetchCmd.executionSignals.switchToLatest().subscribeNext {[unowned self] (x) in
            self.tableView.reloadData()
        }
        
        viewModel.fetchCmd.errors
            .merge(invitationShareVM.fetchCmd.errors as! RACSignal<AnyObject>)
            .subscribeNext { (error) in
            YSProgressHUD.showTips(error?.localizedDescription)
        }
        
        viewModel.fetchCmd.executing.skip(1).subscribeNext {[unowned self] (b) in
            if b?.boolValue == false {
                self.tableView.mj_header.endRefreshing()
            }
        }
        
        invitationShareVM.fetchCmd.executionSignals.switchToLatest().subscribeNext {[unowned self] (x) in
            if self.isCopyAction {
                let after = DispatchTime.now() + 0.25
                DispatchQueue.main.asyncAfter(deadline: after, execute: {
                    self.copyLink()
                    self.isCopyAction = false
                })
            } else {
                self.go2InvitationShareView()
            }
        }
        
        invitationShareVM.fetchCmd.executing.skip(1).subscribeNext { [unowned self] (b) in
            if b?.boolValue == true {
                YSProgressHUD.show(in: self.view)
            }
            else {
                YSProgressHUD.hiddenHUD()
            }
        }
    }
}


private struct ReuseID {
    static let income = "income"
    static let info = "info"
    static let tips = "tips"
}

extension InvitationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel.dataArray[indexPath.row] as InvitationCellModel
        switch cellModel.type {
        case .income:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.income, for: indexPath) as! InvitationIncomeCell
            
            let value = cellModel.value as? NSNumber
            cell.income = Double(truncating: value ?? 0.0)
            cell.commissionBtnHandler = { [unowned self] in
                self.go2CommissionView()
            }
            
            return cell
            
        case .invitationInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.info, for: indexPath) as! InvitationInfoCell
            
            let arr = cellModel.value as? Array<NSNumber>
            if let arr = arr {
                cell.successValue = Int(truncating: arr[0])
                cell.ingValue = Int(truncating: arr[1])
            }
            
            cell.successClickHandler = {[unowned self] in
                self.go2InvitationDetailView(idx: 1)
            }
            cell.ingClickHandler = { [unowned self] in
                self.go2InvitationDetailView(idx: 2)
            }
            return cell
            
        case .tips:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.tips, for: indexPath) as! InvitationTipsCell
            cell.price = Int(truncating: cellModel.value as? NSNumber ?? 0.0)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = viewModel.dataArray[indexPath.row]
        
        switch cellModel.type {
        case .income:
            return 300.0 + (IS_FULL_SCREEN_IPHONE ? 25 : 0)
        case .invitationInfo:
            return 90.0
        case .tips:
            return 350.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension InvitationVC {
    
    override func setupSubviews() {
        footerContainer = UIView(backgroundColor: UIColor.white, in: view)
        invatationBtn = actionBtn(title: "邀请好友赚佣金", bgImg: "invatation_btn_bg", clickAction: {
            self.tryGo2InvitationShareView()
            
        })
        linkBtn = actionBtn(title: "复制我的注册链接", bgImg: "link_btn_bg", clickAction: {
            self.try2CopyLink()
        })
        
        tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.mj_header = YSRefresher.header(withRefreshingTarget: self, refreshingAction: #selector(requestData))
        view.addSubview(tableView)
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(InvitationIncomeCell.self, forCellReuseIdentifier: ReuseID.income)
        tableView.register(InvitationInfoCell.self, forCellReuseIdentifier: ReuseID.info)
        tableView.register(InvitationTipsCell.self, forCellReuseIdentifier: ReuseID.tips)
    }
    
    override func setupSubviewsLayout() {
        footerContainer.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        let padding = 10.0
        let w = (Double(SCREEN_WIDTH) - padding * 2 - 15.0) * 0.5
        invatationBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30)
            make.left.equalToSuperview().offset(padding)
            make.size.equalTo(CGSize(width: w, height: 50.0))
        }
        
        linkBtn.snp.makeConstraints { (make) in
            make.bottom.width.height.equalTo(invatationBtn)
            make.right.equalToSuperview().offset(-padding)
        }
        
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(footerContainer.snp.top)
        }
    }
    
    func actionBtn(title name: String, bgImg: String, clickAction action: (()->())?) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(name, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setBackgroundImage(UIImage(named: bgImg), for: .normal)
        
        footerContainer.addSubview(btn)
        
        btn.rac_signal(for: .touchUpInside).subscribeNext { (btn) in
            if let action = action {
                action()
            }
        }
        
        return btn
    }
}
