//
//  ConditionVC.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-12-29.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit

protocol ConditionCollectionDelegate : NSObjectProtocol{
    func selectedArrays(_ selectedItems: NSMutableDictionary)
}

enum Filter_type_Enum: String {
    case city
    case marka
    case price
    case more
}

//区头高度
fileprivate let headerHeight: CGFloat = 35
class ConditionVC: UIViewController {

    
    
    lazy var tableview : UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/2))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 0
        tableview.estimatedSectionFooterHeight = 0
        tableview.estimatedSectionHeaderHeight = 0
        return tableview
    }()
    
    lazy var collectionView: UICollectionView = {
       
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/2), collectionViewLayout:UICollectionViewFlowLayout())
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.allowsMultipleSelection = false
        return collection
    }()
    
    lazy var maskView: UIView = {
        let mask = UIView(frame: self.view.bounds)
        mask.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(maskViewClick))
        mask.addGestureRecognizer(tapGes)
        return mask
    }()
    
    var dataSource = [FilterInfo]()
    
    var type: String? {
        didSet{
            if self.type == "more" {
                self.tableview.frame.size.height = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.collectionView.frame.size.height = CGFloat(self.dataSource.count * 100)
                })
                
            } else {
                self.collectionView.frame.size.height = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.tableview.frame.size.height = CGFloat(self.dataSource.count * 44) > self.view.frame.size.height ?  self.view.frame.size.height/2 : CGFloat(self.dataSource.count * 44)
                })
                
            }
        }
    }
    
    //是否支持多选
    var multipleSelected: Bool? = false {
        didSet{
            //是否允许多选
            self.collectionView.allowsMultipleSelection = multipleSelected!
            print("\(String(describing: multipleSelected))")
        }
    }
    // 区别 取消选中和选中调用的方法
    fileprivate  var deselect: Bool = false
    
    //选中的 item
    fileprivate lazy var selected_Objc: NSMutableDictionary = NSMutableDictionary()
     weak var delegate: ConditionCollectionDelegate?
    
    var tapMaskView:(()->())?
    var selectedCallBack: ((_ filer_Info: FilterInfo) -> ())? //tableView
    var choiceSelectedArrayBlock: (() -> (NSMutableDictionary))? //collection
    @objc fileprivate func maskViewClick() {
        dismiss(animated: true, completion: nil)
        if tapMaskView != nil {
            tapMaskView!()
        }
    }
   
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(maskView)
       self.type = String()
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       
        self.collectionView.register(MoreMenuCollecCell.self, forCellWithReuseIdentifier: "moreMenuCell")
        self.collectionView.register(CollectionReusableViewHeader.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)

       
        
       self.view.addSubview(tableview)
       self.view.addSubview(collectionView)
        
        

    }
  

}

extension ConditionVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.type != "more" {
            return dataSource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return    44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let info = dataSource[indexPath.row]
        
        if selectedCallBack != nil {
            selectedCallBack!(info)
        }
        
    }
}


extension ConditionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.type == "more" {
            return dataSource.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.type == "more" {
             return (dataSource[section].list?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width, height: headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreMenuCell", for: indexPath) as? MoreMenuCollecCell
        let moreaArr = dataSource[indexPath.section].list
        let moreModel = moreaArr![indexPath.row]
        cell?.carModel = moreModel
        if (cell?.isSelected)! {
            cell?.backgroundColor =  UIColor.red
        }else {
            cell?.backgroundColor = UIColor(white: 0.935, alpha: 1.0)
        }
       cell?.titlelabel.tag = indexPath.row
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview:UICollectionReusableView!
        if kind == UICollectionElementKindSectionHeader
        {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath as IndexPath) as? CollectionReusableViewHeader
            (reusableview as! CollectionReusableViewHeader).label.text = dataSource[indexPath.section].name
        }
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var count: CGFloat = 0
        if self.type == "more" {
            count = CGFloat(self.dataSource[indexPath.section].list?.count ?? 4)
        }
        let  choiceInfo_Item_width: CGFloat = (UIScreen.main.bounds.size.width - (count+1)*15) / count
        return CGSize(width: choiceInfo_Item_width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 15, 0, 15)
    }
    
    //MARK : -- Cell是否可以选中
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK : -- Cell多选时是否支持取消功能
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? MoreMenuCollecCell
        cell?.backgroundColor = UIColor.red
        let index = cell?.titlelabel.tag

        let indexpath = self.collectionView.indexPath(for: cell!)
        
     let dd = cell?.titlelabel.superview?.superview
        
        print("titlelabel.tag \(String(describing: index))")
         deselect = false
        if let title = cell?.titlelabel.text {
            if delegate != nil{
                delegate?.selectedArrays(changeSelectStateWithCell(title, (cell?.carModel)!, deselect))
            }
        }
    }
    
    //MARK: -- Cell取消选中调用该方法
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? MoreMenuCollecCell
        cell?.backgroundColor = UIColor(white: 0.96, alpha: 1)
        let index = cell?.titlelabel.tag
        
        print("titlelabel.tag \(String(describing: index))")
        
        deselect = true
        if let title = cell?.titlelabel.text {
            if delegate != nil{
                delegate?.selectedArrays(changeSelectStateWithCell(title, (cell?.carModel)!, deselect))
            }
        }

    
    }
    
    fileprivate func changeSelectStateWithCell(_ title: String, _ carMore: CarMore ,  _ deselect: Bool) -> NSMutableDictionary{
        if deselect == false {
            
            if multipleSelected == false && selected_Objc.count > 0 {
                selected_Objc.removeAllObjects()
                _ = NSDictionary()
                
                
//                print(" =----------- \(selected_Objc)")
            }
            selected_Objc.setValue(carMore.value, forKey: carMore.key!)
//             print("+++++++++ \(selected_Objc)")
        } else {
            selected_Objc.removeObject(forKey: carMore.key as Any)
//             print(" ---- \(selected_Objc)")
        }
        
        return selected_Objc
    }
    
    
}


class MoreMenuCollecCell: UICollectionViewCell {
    var titlelabel:UILabel!
    var carModel: CarMore?{
        didSet{
            guard let model = carModel else { return  }
            titlelabel.text = model.title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titlelabel = UILabel(frame:contentView.bounds)
        titlelabel.textAlignment = .center
        titlelabel.font = UIFont.systemFont(ofSize: 13)
        titlelabel.textColor = UIColor.black
        
        contentView.addSubview(titlelabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

let headerIdentifier = "CollectionReusableViewHeader"
class CollectionReusableViewHeader: UICollectionReusableView {
    var label:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: CGRect(x: 15, y: 0, width: self.frame.size.width - 30, height: headerHeight))
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


