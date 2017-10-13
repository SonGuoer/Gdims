//
//  UserDefaultUtils.swift
//  GdimsIOS
//
//  Created by 李青松 on 2017/10/11.
//  Copyright © 2017年 bhy. All rights reserved.
//

import Foundation
class UserDefaultUtils{
    let useDefault = UserDefaults.standard
    init() {
    }
    /*String 储存和修改*/
    func putUser(text:String,forKey:String) {
        useDefault.set(text, forKey: forKey)
        //设置同步
        useDefault.synchronize()
    }
    /*数组 储存和修改*/
    func putUserAry(text:Array<String>,forKey:String) {
        useDefault.setValue(text, forKey: forKey)
        //设置同步
        useDefault.synchronize()
    }
    /*数组读取*/
    func getUserAry(forKey:String) ->Array<String>?{
        let text:Array<String>? = useDefault.object(forKey: "String") as? [String]
        return text
    }
    /*String 读取*/
    func getUser(forKey:String) ->String?{
        let s:String?=useDefault.value(forKey: forKey) as? String
        return s
    }
    /*删除*/
    func removeUser(forKey:String){
        useDefault.removeObject(forKey: forKey)
    }
    
}

