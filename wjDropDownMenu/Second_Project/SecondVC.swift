//
//  SecondVC.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-11-20.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit

class SecondVC: UIViewController ,UITableViewDelegate, UITableViewDataSource, ConditionCollectionDelegate{

   
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
    
    lazy var collection: ChoiceInfoCollectionVC = {
        let collection = ChoiceInfoCollectionVC(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: choiceInfo_Item_height ), collectionViewLayout: UICollectionViewFlowLayout())
        
        return collection
    }()
    var names = ["地区","价格","户型","更多"]
    var model: ChoiceModel?

  
    
    lazy var conditionVC: ConditionVC = {
        let vc = ConditionVC()
        vc.view.frame = CGRect(x: 0, y:  UIDevice.current.isX() == true ? 88 : 64 + self.collection.frame.size.height, width: self.view.frame.size.width, height: screen_height)
        vc.delegate = self
        
        vc.view.alpha = 0
        view.addSubview(vc.view)
        return vc
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
          conditionVC.view.removeFromSuperview()
    }
    
    
    var dataSource = [Filter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        guard let url = URL(string:"http://192.168.199.200/index.php?m=version3&a=list_maxina_home&cat_id=4") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            do {
                let menuModel = try JSONDecoder().decode(DropMenuModel.self, from: data!)
                self.collection.data_Source = menuModel.filter!
                DispatchQueue.main.async {
                     self.collection.reloadData()
                }
                print("+++++++++ \(self.collection.data_Source)")
            }catch{
                print("error-----: \(error)")
            }
            
            
        }.resume()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableview)
        
        
        collection.btnClickBlack = {[weak self] (cell, filter, isCurrent, currtnBtn) in
            print("title \(String(describing: cell.btn.currentTitle))   type --> \(String(describing: filter.filter_type)) ")
            let Y = UIDevice.current.isX() == true ? 88 : 64
            self?.tableview.contentOffset = CGPoint(x: 0, y: Y)
            self?.conditionVC.dataSource = filter.list!
            self?.conditionVC.type = filter.filter_type!
            self?.conditionVC.multipleSelected = false
            DispatchQueue.main.async {
//                if filter.filter_type == "more"{
//                    
//                }
                self?.conditionVC.tableview.reloadData()
                self?.conditionVC.collectionView.reloadData()
            }
            if isCurrent == true {
                self?.conditionVC.view.alpha = 0
            }else {
                 self?.conditionVC.view.alpha = 1.0
            }
            
            
            self?.conditionVC.tapMaskView = {[weak self] in
                self?.conditionVC.view.alpha = 0
                currtnBtn.isSelected = false
                self?.collection.currentBtn = nil
            }
            
        }
        
        
        
        
        
    }

    
    func selectedArrays(_ selectedItems: NSMutableDictionary) {
        print(" nima \(selectedItems)")
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
            return self.collection
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







