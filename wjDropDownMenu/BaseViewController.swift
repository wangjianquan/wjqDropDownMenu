//
//  BaseViewController.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-11-23.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit




class BaseViewController: UIViewController {
    
    lazy var titles = ["开心","时尚达人","个性搭配","wuli嘎嘎","阿凡达的发生的","发斯蒂芬"]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       let lableView =  LabelListView(frame: CGRect(x: 0, y: 300, width: screen_width, height: 30))
        lableView.names = titles
        lableView.btnActionBlock = {[weak self] (btn, isSelected) -> () in
            
         
//            print("\(String(describing: btn.currentTitle))  \(btn.isSelected)")
            
        }
        
        
        // 获取文件路径
        let filePath = Bundle.main.path(forResource: "usedCar.json", ofType: nil)
        let jsonData = NSData(contentsOfFile: filePath!)
        
        do {
        
            let json = try JSONSerialization.jsonObject(with: jsonData! as Data, options:[]) as! [String:AnyObject]
            
            print("\(json)")
            
        }catch{
              print("error")
        }
        
        view.addSubview(lableView)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
