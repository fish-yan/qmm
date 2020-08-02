//
//  FYGrandientView.swift
//  QMM
//
//  Created by Yan on 2019/9/1.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit


@IBDesignable
class FYGrandientView: UIView {
    
    @IBInspectable var startColor: UIColor = .clear {
        didSet {
            configLayer()
        }
    }
    
    @IBInspectable var endColor: UIColor = .clear {
        didSet {
            configLayer()
        }
    }
    
    @IBInspectable var startPoint: CGPoint = .zero {
        didSet {
            configLayer()
        }
    }
    
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1, y: 1)  {
        didSet {
            configLayer()
        }
    }
    
    private var grandientLayer: CAGradientLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadLayer()
    }
    
    private func loadLayer() {
        grandientLayer = CAGradientLayer()
        grandientLayer.frame = bounds
        layer.insertSublayer(grandientLayer, at: 0)
    }
    
    private func configLayer() {
        grandientLayer.colors = [startColor.cgColor, endColor.cgColor]
        grandientLayer.startPoint = startPoint
        grandientLayer.endPoint = endPoint
        grandientLayer.cornerRadius = layer.cornerRadius
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        grandientLayer.frame = bounds
    }

}
