//
//  QMMSettingVC.swift
//  QMM
//
//  Created by Joseph Koh on 2018/12/24.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class QMMSettingVC: YSBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension QMMSettingVC {
    override func initialize() {
        super.initialize()
        
        navigationItem.title = "隐私声明"
        style = .grouped
    }
    
    override func setupSubviews() {
        super.setupSubviews()
    }
    
    override func setupSubviewsLayout() {
        super.setupSubviewsLayout()
        
        tableView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension QMMSettingVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "kReuseID")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "kReuseID")
        }
        cell?.textLabel?.text = "隐私声明"
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = YSBaseWebViewController.init()
        vc.urlString = "http://www.huayuanvip.com/protcol2.html"
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
