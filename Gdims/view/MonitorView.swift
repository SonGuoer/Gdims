//
//  MonitorView.swift --- 定量监测页面
//  Gdims
//
//  Created by 包宏燕 on 2017/10/16.
//  Copyright © 2017年 name. All rights reserved.
//

import UIKit

class MonitorView: UIViewController {
    
    // 灾害点名称
    @IBOutlet weak var disasterName: UILabel!
    // 监测点名称
    @IBOutlet weak var monitorName: UILabel!
    // 发生日期
    @IBOutlet weak var happenDate: UILabel!
    // 定量监测名称
    @IBOutlet weak var inputName: UILabel!
    // 输入框
    @IBOutlet weak var inputNum: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
