//
//  MacroInfoModel.swift
//  Gdims
//
//  Created by 包宏燕 on 2017/10/17.
//  Copyright © 2017年 name. All rights reserved.
//

import Foundation
import ObjectMapper

class MacroInfoModel: Mappable{
    
    var legalR: String?
    var unifiedNumber: String?
    var name: String?
    var disasterType: String?
    var longitude: String?
    var latitude: String?
    var macroscopicPhenomenon: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        legalR <- map["legalR"]
        unifiedNumber <- map["unifiedNumber"]
        name <- map["name"]
        disasterType <- map["disasterType"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        macroscopicPhenomenon <- map["macroscopicPhenomenon"]
    }
    
}
