//
//  ChoiceModel.swift
//  CollectionSelected
//
//  Created by ulinix on 2017-12-20.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit

class ChoiceModel: NSObject {
    
    @objc var tit : String?
    @objc var subTitle : String?
    @objc var type : String?
    @objc var isEdit : String?
    /// 会员等级 ,取值范围 1~6
    var mbrank: Int = -1
    
    
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override var description: String{
        let property = ["tit","subTitle","type","isEdit"]
        //通过key取出所有的value
        let dic = dictionaryWithValues(forKeys: property)
        return "\(dic)"
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
    
}
