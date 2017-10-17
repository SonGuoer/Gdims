//
//  BaseModel.swift
//  GdimsIOS
//
//  Created by 李青松 on 2017/10/11.
//  Copyright © 2017年 bhy. All rights reserved.
//

import Foundation
import ObjectMapper
class BaseModel :Mappable{
    var result: String?
    var code:String?
    var info: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        code <- map["code"]
        info <- map["info"]
    }
    
}

