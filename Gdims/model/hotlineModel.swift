//
//  hotlineModel.swift
//  Gdims
//
//  Created by 包宏燕 on 2017/11/2.
//  Copyright © 2017年 name. All rights reserved.
//

import Foundation
import ObjectMapper

class hotlineModel :Mappable{
    var message: String?
    var status:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
    }
    
}
