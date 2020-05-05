//
//  MenuView.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-05-05.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit

class MenuView: UIView {

    func applyShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.7
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyShadow()
    }
    
    override func draw(_ rect: CGRect) {
        applyShadow()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
