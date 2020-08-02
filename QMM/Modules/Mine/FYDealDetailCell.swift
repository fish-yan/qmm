//
//  FYDealDetailCell.swift
//  QMM
//
//  Created by Yan on 2019/9/2.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit

class FYDealDetailCell: UITableViewCell {
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var moneyLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    
    var model = FYDealModel() {
        didSet {
            titleLab.text = model.transtype
            moneyLab.text = model.amount2
            desLab.text = model.desc
            dateLab.text = model.date
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
