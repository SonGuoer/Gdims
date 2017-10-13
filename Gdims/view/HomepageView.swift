//
//  HomepageView.swift
//  GdimsIOS
//
//  Created by 包宏燕 on 2017/10/12.
//  Copyright © 2017年 bhy. All rights reserved.
//

import UIKit

class HomepageView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarBackgroundColor(color: .black)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // 设置状态栏背景颜色
    func setStatusBarBackgroundColor(color : UIColor) {
        let statusBarWindow: UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar: UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }
    
    
}

