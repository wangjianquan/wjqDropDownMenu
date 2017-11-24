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
    
    var names : [String] {
        didSet{
            
            let btn_Width = self.frame.size.width / CGFloat((names.count))
            let btn_height = self.frame.size.height - 10
            let btn_Y = (self.frame.size.height - btn_height) / 2
            var btn_X : CGFloat = 0

           for i in 0..<names.count {
                let btn = UIButton(type: .custom)
                btn.setTitle(names[i], for: .normal)
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.titleLabel?.adjustsFontSizeToFitWidth = true
                btn.titleLabel?.textAlignment = NSTextAlignment.center
                
                btn_X = CGFloat(i) * btn_Width
            
                btn.frame = CGRect(x: btn_X , y: btn_Y, width: btn_Width, height: btn_height)
                btn.tag = 100 + i
                btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
                addSubview(btn)
            }
        }
    }
    
    
   override init(frame: CGRect) {
        self.names = [String]()
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    
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
