//
//  FYWalletViewController.swift
//  QMM
//
//  Created by Yan on 2019/9/2.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit

class FYWalletViewController: UIViewController {
    
    @IBOutlet weak var balabceLab: UILabel!
    @IBOutlet weak var lucreLab: UILabel!
    
    private var viewModel = FYWalletVM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav(isColor: false)
        request()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func request() {
        viewModel.requestWallet { [weak self] (success) in
            self?.configView()
        }
    }
    
    private func configView() {
        balabceLab.text = viewModel.model.balance + "元"
        lucreLab.text = viewModel.model.profit + "元"
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FYWithdraw" {
            let vc = segue.destination as! FYWithdrawViewController
            vc.type = viewModel.model.type
        }
    }

    @IBAction func chargeAction(_ sender: Any) {
        // ios 没有充值
    }
    
    @IBAction func changeToWalletAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: "确认转到余额吗？", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "确认", style: .default) { (action) in
            self.viewModel.requestChange { [weak self] (success) in
                self?.request()
            }
        }
        let action2 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
        
        
    }
    @IBAction func proAction(_ sender: Any) {
        YSMediator.openURL("https://www.huayuanvip.com/help/applycash.html")
    }
}
