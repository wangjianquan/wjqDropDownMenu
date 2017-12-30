//
//  DropMenuModel.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-12-29.
//  Copyright © 2017 wjq. All rights reserved.
//

import Foundation
import UIKit

struct DropMenuModel: Decodable {
    
    let state: String?
    let title: String?
    let uptime: String?
    let up_time: String?
    let filter: [Filter]?
    let access_token: String?

}

struct Filter: Decodable {
    let name: String?
    let check_value: String?
    let check_type: String? //单选多选
    let filter_type: String? //类型(table, double_table, collection, sectionCollection)
    let list:[FilterInfo]?
    
}

struct FilterInfo: Decodable{
    let title: String?
    let value: String?
    let key: String?
    
    
    //筛选条件为其他的时候的数据,
    let name: String?
    let check_value: String?
    let check_type: String? //单选多选
    let filter_type: String? //类型(table, double_table, collection, sectionCollection)
    let list:[CarMore]?
}

struct CarMore: Decodable {
    let title: String?
    let value: String?
    let key: String?
}
