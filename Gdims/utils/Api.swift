//
//  Api.swift
//  GdimsIOS
//
//  Created by 李青松 on 2017/10/11.
//  Copyright © 2017年 bhy. All rights reserved.
//

import Foundation
class Api{
    var ip = ""
    var port = ""
    var ports = ""
    var userDefault = UserDefaultUtils()
    init() {
        self.ip = userDefault.getUser(forKey: "ips")!
        self.port = userDefault.getUser(forKey: "ports")!
        self.ports = "8090";
    }
    
    func getLoginUrl() -> String{
        let url = "http://"+ip+":"+port+"/meteor/findFunCfg.do"
        return url
    }
    
}

