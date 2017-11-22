//
//  Wjq_DropDownMenu.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-11-20.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit

protocol DropDownMenuDelegate : NSObjectProtocol {
    func btnClick(_ btn: UIButton)
}

class Wjq_DropDownMenu: UIView {
    weak var delegate: DropDownMenuDelegate?
    
    lazy var btn : UIButton = {
        
        let btn = UIButton(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 88, height: self.frame.size.height))
        
        btn.setTitle("click", for: .normal)
        btn.backgroundColor = UIColor.red
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.yellow
        addSubview(btn)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnClick(_ sender: UIButton){
        
     
        
        if delegate != nil {
            delegate?.btnClick(sender)
        }
        
    }

}
