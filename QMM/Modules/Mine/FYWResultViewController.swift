
//
//  FYWResultViewController.swift
//  QMM
//
//  Created by Yan on 2019/9/2.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit

class FYWResultViewController: UIViewController {

    @IBOutlet weak var residueLab: UILabel!
    @IBOutlet weak var moneyLab: UILabel!
    @IBOutlet weak var alpayLab: UILabel!
    
    var money = ""
    var tel = ""
    var residue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moneyLab.text = "￥\(money)"
        alpayLab.text = tel.secret(begin: 3, countDown: 4)
        residueLab.text = "￥\(residue)"
    }
    
    @IBAction func commitAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
