//
//  FYDealDetailViewController.swift
//  QMM
//
//  Created by Yan on 2019/9/2.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit

class FYDealDetailViewController: UIViewController {

    @IBOutlet weak var typeBgMargin: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var typeBtns: [UIButton]!
    @IBOutlet weak var topV: UIView!
    @IBOutlet weak var tabBgV: UIView!
    
    var type = "1"
    var page = 1
    var dataArray = [FYDealModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request()
        })
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.page += 1
            self.request()
        })
        self.tableView.mj_header.beginRefreshing()
    }
    
    @IBAction func typeBtnAction(_ sender: UIButton) {
        type = "\(sender.tag)"
        for btn in typeBtns {
            btn.isSelected = btn.tag == sender.tag 
        }
        typeBgMargin.constant = sender.tag == 1 ? -80 : 80
        UIView.animate(withDuration: 0.25) {
            self.topV.layoutIfNeeded()
        }
        self.tableView.mj_header.beginRefreshing()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - request
extension FYDealDetailViewController {
    func request() {
        let params = ["type":type, "page":"\(page)", "count":"20"]
        FYRequest.request("getusertransbytype", params: params, success: { (response: FYBaseModel<FYDealModel>) in
            if self.page == 1 {
                self.dataArray = [FYDealModel]()
            }
            self.dataArray += response.data
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            if self.dataArray.count == response.total {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer.endRefreshing()
            }
            if response.total == 0 {
                self.tabBgV.showFailureView(of: .empty, withClickAction: { [unowned self] in
                    self.request()
                })
            } else {
                self.tabBgV.hiddenFailureView()
            }
        }) { (error) in
            self.tabBgV.showFailureView(of: .error, withClickAction: { [unowned self] in
                self.request()
            })
        }
    }
}

extension FYDealDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FYDealDetailCell", for: indexPath) as! FYDealDetailCell
        cell.model = dataArray[indexPath.row]
        return cell
    }
}
