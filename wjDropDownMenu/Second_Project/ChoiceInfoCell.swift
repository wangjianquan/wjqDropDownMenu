//
//  ChoiceInfoCell.swift
//  Classified_Information
//
//  Created by ulinix on 2017-12-16.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit


let choiceInfoCell_Id = "ChoiceInfoCell"
class ChoiceInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet var btn: UIButton!
    

    
    var  choiceModel: ChoiceModel?{
        didSet{
            // 1.nil值校验
            guard let model = choiceModel else {
                return
            }
            title.text = model.tit
            btn.setTitle(model.tit, for: .normal)
            let lineImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 2, height: 10))
            lineImg.image = UIImage(named:"line")
           
        }
    }
    
    var filterModel:  Filter?{
        didSet{
            guard let model = filterModel else { return }
            btn.setTitle(model.name, for: .normal)
        }
        
    }
    
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
      

    }

}
