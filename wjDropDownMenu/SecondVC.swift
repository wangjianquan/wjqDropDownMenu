//
//  SecondVC.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-11-20.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit

class SecondVC: UIViewController ,UITableViewDelegate, UITableViewDataSource{

   
    lazy var tableview : UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style:UITableViewStyle.plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.estimatedRowHeight = 0
        tableview.estimatedSectionFooterHeight = 0
        tableview.estimatedSectionHeaderHeight = 0
        return tableview
    }()
    var menu =  Wjq_DropDownMenu()
//    lazy var menu: Wjq_DropDownMenu = {
//        let menu =  Wjq_DropDownMenu(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: 44))
//        menu.delegate = self
//        return menu
//    }()
//
   
     fileprivate lazy var popAnimation : PopAnimation = PopAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      view.addSubview(tableview)
        
        // Do any additional setup after loading the view.
    }

   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return    44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0000001
        }
        return 44
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0.00000001
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            
           
            let menu =  Wjq_DropDownMenu(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: 44))
            menu.delegate = self
            self.menu = menu
            let origin_y = tableView.headerView(forSection: 1)?.superview?.frame.origin.y
            print("000000000000 ---  \(String(describing: origin_y))")
            return menu
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "白小嘿 - \(indexPath.row)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}



extension SecondVC : DropDownMenuDelegate {
    
    func btnClick(_ btn: UIButton) {
        
       self.tableview.scrollToRow(at: IndexPath.init(row: 0, section: 1), at: UITableViewScrollPosition.bottom, animated: true)
        let pop = UIStoryboard(name: "PopViewController", bundle: nil)
        guard let vc = pop.instantiateInitialViewController() else { return  }


        popAnimation.presentedFrame = CGRect(x:0 , y: 64 + self.menu.frame.size.height, width: self.view.frame.size.width, height: 230)
        popAnimation.presentedCallBack = {[weak self]
            (isPresent) -> () in
            self?.menu.btn.isSelected  = isPresent
        }
        vc.transitioningDelegate = popAnimation
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
        
    }
    
    
    
    
}




