//
//  ViewController.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-11-20.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
   
    
    var columnOneArray = ["All","C1-1","C1-2","C1-3","C1-4","C1-5"]
    var columnTwoArray = ["All","C2-1","C2-2"]
    
    lazy var menu : WjqDropMenu = {
        let menu =   WjqDropMenu(origin: CGPoint(x: 0, y:0), width: self.view.frame.size.width, height: 44, tableView_Y:97)
        menu.delegate = self
        menu.data_Source = self
        menu.caTextLayer_SeleColor = UIColor.orange
        menu.arrow_SelectColor = UIColor.orange
        menu.cell_textLable_Select_Color =  UIColor.orange
       return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        navigationItem.titleView = menu
        
        self.tableView.reloadData()
    
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController : Wjq_DropDownMenuDelegate, Wjq_DropDownMenuDataSource {
   
   
    func numberOfColumns(menu mneu: WjqDropMenu) -> NSInteger {
        return 2
    }
    func numberOfRows(column: NSInteger, menu: WjqDropMenu) -> Int {
        switch column {
        case 0:
            return columnOneArray.count
        case 1:
            return columnTwoArray.count
        default:
            return 0
        }
    }
    
    func titleForRows(indexPath: WjIndexPath, menu: WjqDropMenu) -> String {
        switch indexPath.column {
        case 0:
            return columnOneArray[indexPath.row]
        case 1:
            return columnTwoArray[indexPath.row]
            
        default:
            return ""
        }
    }
    func didSelectRow(indexPath: WjIndexPath, menu: WjqDropMenu) {
        self.tableView.isScrollEnabled = true
        var str = ""
        switch indexPath.column {
        case 0:
                str = columnOneArray[indexPath.row]
                print("indexPath.column = \(indexPath.column) ---> \(str)")
            break
        case 1:
            
               str = columnTwoArray[indexPath.row]
               print("indexPath.column = \(indexPath.column) ---> \(str)")
            break
        default:
            str = ""
        }
    }
    
    func didSelectDropMenu(menu: WjqDropMenu, show: Bool) {
//        if self.tableView.contentOffset.y > 97 || self.tableView.contentOffset.y < 97 {
//            self.tableView.contentOffset = CGPoint(x: 0, y: 97)
        self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 1), at: UITableViewScrollPosition.top, animated: true)

//        }
       
        self.tableView.isScrollEnabled = false

    }
    func didSelectBackGroundMaskView() {
        self.tableView.isScrollEnabled = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        
    }
}

extension ViewController  {
    
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
            
//         let menu =   WjqDropMenu(origin: CGPoint(x: 0, y:0), width: self.view.frame.size.width, height: 44)
            let origin_y = tableView.headerView(forSection: 1)?.superview?.frame.origin.y
            print("000000000000 ---  \(String(describing: origin_y))")
            return menu
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewCell
        cell.nameLabel.text = "白小嘿 - \(indexPath.row)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
   
    
    
    
}
