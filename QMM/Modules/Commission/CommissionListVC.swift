//
//  CommissionListVC.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/13.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit
//import Result
import ReactiveCocoa

class CommissionListVC: YSBaseViewController {

    private var viewModel = CommissionListVM()
    
    private var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalization()
        setupSubviews()
        setupSubviewsLayout()
        bind()
        
        tableView.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.setBackgroundImage(navBgImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func navBgImage() -> UIImage? {
        let gradient = CAGradientLayer()
        let h = IS_FULL_SCREEN_IPHONE ? (44.0 + 44.0) : (20.0 + 44.0)
        gradient.frame = CGRect(x: 0, y: 0, width: Double(SCREEN_WIDTH), height: Double(h))
        gradient.colors = [UIColor(hexString: "#FF599E").cgColor,
                           UIColor(hexString: "#FFAB68").cgColor];
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        UIGraphicsBeginImageContext(gradient.frame.size)
        
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    func initalization()  {
        navigationItem.title = "佣金明细"
    }
}

extension CommissionListVC {
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

private struct ReuseID {
    static let list = "list"
}

extension CommissionListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = viewModel.dataArray[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.list) as? CommissionListCell
       
        if cell == nil {
            cell = CommissionListCell(style: .default, reuseIdentifier: ReuseID.list)
        }
        
        cell!.bind(withViewModel: vm)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
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

extension CommissionListVC {
    override func setupSubviews() {
        tableView = UITableView(of: .grouped,
                                in: view,
                                withDatasource: self,
                                delegate: self)
        tableView.separatorStyle = .none
        tableView.mj_header = YSRefresher.header(withRefreshingTarget: self, refreshingAction: #selector(requestData))
        tableView.mj_footer = YSRefresher.footer(withRefreshingTarget: self, refreshingAction: #selector(requestMoreData))
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupSubviewsLayout() {
        
    }
}
