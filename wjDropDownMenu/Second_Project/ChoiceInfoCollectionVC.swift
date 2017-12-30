//
//  ChoiceInfoCollectionVC.swift
//  Classified_Information
//
//  Created by ulinix on 2017-12-16.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit



let  choiceInfo_Item_height : CGFloat = 44

class ChoiceInfoCollectionVC: UICollectionView ,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
    var data_Source = [Filter]()
    
    var btnClickBlack:((_ cell: ChoiceInfoCell , _ filter: Filter, _ isCurrent: Bool, _ sender: UIButton) -> ())?
    //单选
     var currentBtn: UIButton? = nil
    //同一个筛选项是否被连续点击
    var isCurrrnt: Bool = false
    
    fileprivate func setupUI() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator  = false
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        //允许多选
        self.allowsMultipleSelection = true
        self.isScrollEnabled = false
        self .register(UINib.init(nibName: choiceInfoCell_Id, bundle: nil), forCellWithReuseIdentifier: choiceInfoCell_Id)
        self.reloadData()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return data_Source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: choiceInfoCell_Id, for: indexPath) as? ChoiceInfoCell
        cell?.filterModel = data_Source[indexPath.row]
        cell?.btn.tag = indexPath.row
        cell?.btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let  choiceInfo_Item_width: CGFloat = (UIScreen.main.bounds.size.width) / CGFloat(self.data_Source.count)
        return CGSize(width: choiceInfo_Item_width, height: choiceInfo_Item_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
   
    
   
}


extension ChoiceInfoCollectionVC {
    
    @objc fileprivate func btnClick(_ btn: UIButton) {
        let cell = cellForItem(at: IndexPath(row: btn.tag, section: 0)) as? ChoiceInfoCell
        let index = IndexPath(row: btn.tag, section: 0)
        let filter = data_Source[index.row]
        
        if currentBtn == nil {
            btn.isSelected = true
            currentBtn = btn
            isCurrrnt = false
        } else if currentBtn == btn{
            currentBtn = nil
            btn.isSelected = false
            isCurrrnt = true
        } else if self.currentBtn != btn {
            self.currentBtn?.isSelected = false
            btn.isSelected = true
            self.currentBtn = btn
            isCurrrnt = false
        }
        
        if btnClickBlack != nil {
            btnClickBlack!(cell!, filter, isCurrrnt, btn)
        }
    }
}




