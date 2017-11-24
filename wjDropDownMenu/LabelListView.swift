//
//  LabelListView.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-11-24.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit
import SnapKit

let kScale_Width = UIScreen.main.bounds.size.width / 375
let kScale_Height = UIScreen.main.bounds.size.width / 667

class LabelListView: UIView {
    
    lazy var scrollview : UIScrollView = {
        let scroll = UIScrollView()
        scroll.bounces = true
        scroll.isScrollEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        self.addSubview(scroll)
        scroll.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        return scroll
    }()
    
    /*
      **按钮参数
     */
    let itemSpace : CGFloat = 10 * kScale_Width //间隔
    var widthArray = [CGFloat]()
   
   
    //闭包
    var btnActionBlock : ((_ btn: UIButton, _ isSelected: Bool)->())?
    
    
    var lastBtn : UIButton? = nil
    
    var names : [String]{
        didSet{
            var label_Width : CGFloat = 0
            var contentSizeWidth : CGFloat = 0
            for i in 0..<names.count {
                let string = names[i]
                label_Width = string.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height:CGFloat(MAXFLOAT)), options: .usesFontLeading, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13)], context: nil).size.width + 20
                self.widthArray.append(label_Width)
                
                print("widtharray: --- \(self.widthArray)")
                contentSizeWidth += label_Width
            }
            scrollview.contentSize = CGSize(width: label_Width + itemSpace * CGFloat(names.count) + 30 , height: 0)
          
            
            for i in 0..<widthArray.count {
                
                let itemWidth = widthArray[i]
                // 添加item
                let btn = UIButton(type: .custom)

                btn.setTitle(names[i], for: .normal)
                btn.setTitleColor(UIColor.black , for: .normal)
                btn.setTitleColor(UIColor.white, for: .selected)
                btn.backgroundColor = UIColor.groupTableViewBackground
                btn.layer.cornerRadius = 2;
                btn.layer.masksToBounds = true
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                btn.tag = 100 + i
                btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
                scrollview.addSubview(btn)
                
                btn.snp.makeConstraints({ (make) in
                    make.centerY.equalTo(scrollview)
                    make.size.equalTo(CGSize(width: itemWidth, height: scrollview.frame.size.height))
                    if (lastBtn != nil){
                        make.left.equalTo((lastBtn?.snp.right)!).offset(itemSpace)
                    }else{
                        make.left.equalTo(scrollview.snp.left).offset(itemSpace)
                    }
                })
                lastBtn = btn
            }
            lastBtn?.snp.makeConstraints({ (make) in
                make.right.equalTo(scrollview.snp.right).inset(itemSpace)
            })
        }
    }
   
    override init(frame: CGRect) {
        self.names = [String]()
//        self.isUser_Btn = false
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        
    }
    

}


extension LabelListView {
    
    @objc fileprivate func btnClick(_ sender : UIButton){
   
        if lastBtn == nil {
            sender.isSelected = true
            sender.backgroundColor = UIColor.red
            lastBtn = sender
        } else if lastBtn == sender{
            self.lastBtn = sender
            sender.isSelected = true
            
        } else if self.lastBtn != sender {
            self.lastBtn?.isSelected = false
            self.lastBtn?.backgroundColor = UIColor.groupTableViewBackground
            sender.isSelected = true
            
            self.lastBtn = sender
            self.lastBtn?.backgroundColor = UIColor.black
        }
        
        if let callBack = btnActionBlock {
            callBack(sender, sender.isSelected)
            return
        }
    }
    
}


extension UIColor {
        //返回随机颜色
        class var randomColor: UIColor {
            get {
                let red = CGFloat(arc4random()%256)/255.0
                let green = CGFloat(arc4random()%256)/255.0
                let blue = CGFloat(arc4random()%256)/255.0
                return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            }
         }
    
}



