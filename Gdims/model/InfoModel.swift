//
//  InfoModel.swift
//  GdimsIOS
//
//  Created by 李青松 on 2017/10/11.
//  Copyright © 2017年 bhy. All rights reserved.
//

import Foundation
import ObjectMapper
class InfoModel: Mappable{
    
    var monAngle:String?
    var monPointName:String?
    var unifiedNumber:String?
    var monPointNumber:String?
    var ypoint:String?
    var instrumentConstant:String?
    var dimension:String?
    var monDirection:String?
    var instrumentNumber:String?
    var monType:String?
    var legalR:String?
    var xpoint:String?
    var monContent:String?
    var monPointLocation:String?
    
    
    required init?(map: Map) {
        
    }


    func mapping(map: Map) {
        monAngle <- map["monAngle"]
        monPointName <- map["monPointName"]
        unifiedNumber <- map["unifiedNumber"]
        monPointNumber <- map["monPointNumber"]
        ypoint <- map["ypoint"]
        instrumentConstant <- map["instrumentConstant"]
        dimension <- map["dimension"]
        monDirection <- map["monDirection"]
        instrumentNumber <- map["instrumentNumber"]
        monType <- map["monType"]
        legalR <- map["legalR"]
        xpoint <- map["xpoint"]
        monContent <- map["monContent"]
        monPointLocation <- map["monPointLocation"]
    }
}

