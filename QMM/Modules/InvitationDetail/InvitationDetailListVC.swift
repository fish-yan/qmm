//
//  InvitationDetailListVC.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/13.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

enum DetailListType: Int {
    case ing = 0
    case success = 1
    case all = 9999
}

class InvitationDetailListVC: YSBaseViewController {

    open var type: DetailListType!
    
    private var tableView: UITableView!
    private var viewModel = InvitationDetailListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiazalition()
        setupSubviews()
        setupSubviewsLayout()
        bind()
        
        tableView.mj_header.beginRefreshing()
    }

    func initiazalition() {
        viewModel.type = self.type
    }
}

extension InvitationDetailListVC {
    func bind() {
        viewModel.fetchCmd.executionSignals.switchToLatest().subscribeNext { [unowned self] (x) in
            self.view.hiddenFailureView()
            
            if self.viewModel.dataArray.count == 0 {
                self.view.showFailureView(of: .empty, withClickAction: { [unowned self] in
                    self.requestData()
                })
            }
            else {
                self.tableView.reloadData()
            }
        }
        
        viewModel.fetchCmd.executing.skip(1).subscribeNext { [unowned self] (b) in
            if b?.boolValue == false {
                self.endRefresh()
            }
        }
        
        viewModel.fetchCmd.errors.subscribeNext { [unowned self]  (error) in
            YSProgressHUD.showTips(error?.localizedDescription)
            
            if self.viewModel.dataArray.count == 0 {
                self.view.showFailureView(of: .error, withClickAction: { [unowned self] in
                    self.requestData()
                })
            }
        }
        
    }
    
    func endRefresh() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
    @objc func requestData() {
        viewModel.fetchCmd.execute(nil)
    }
    
    @objc func requestMoreData() {
        viewModel.fetchCmd.execute(viewModel.flag)
    }
}


let kReuseID = "kReuseID"

extension InvitationDetailListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseID, for: indexPath) as! InvitationDetailListCell
        
        cell.model = viewModel.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}


extension InvitationDetailListVC {
    
    override func setupSubviews() {
        tableView = UITableView(of: .grouped,
                                in: view,
                                withDatasource: self,
                                delegate: self)
        tableView.separatorStyle = .none
        tableView.register(InvitationDetailListCell.self, forCellReuseIdentifier: kReuseID)
        tableView.mj_header = YSRefresher.header(withRefreshingTarget: self,
                                                 refreshingAction: #selector(requestData))
        tableView.mj_footer = YSRefresher.footer(withRefreshingTarget: self,
                                                 refreshingAction: #selector(requestMoreData))
    }
    
    override func setupSubviewsLayout() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
