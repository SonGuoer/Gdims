//
//  MonitorView.swift --- 定量监测页面
//  Gdims
//
//  Created by 包宏燕 on 2017/10/16.
//  Copyright © 2017年 name. All rights reserved.
//

import UIKit

class MonitorView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = NSDate()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        let strNowTime = timeFormatter.string(from: date as Date) as String
        print(strNowTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
