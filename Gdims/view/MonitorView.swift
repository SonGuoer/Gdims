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
    
    var names = [String]()
    
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
    
    /*
     释放当前页面
     */
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
