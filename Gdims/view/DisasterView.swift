//
//  DisasterView.swift
//  Gdims
//
//  Created by 包宏燕 on 2017/10/16.
//  Copyright © 2017年 name. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import Toast_Swift
import CoreData
class DisasterView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var myTableView: UITableView?
    let Swidth = UIScreen.main.bounds.size.width
    let Sheight = UIScreen.main.bounds.size.height
    var clickNum: Int?
    var getClickNum: Int?
    var array = [String]()
    var arrayNum = [String]()
    var monitorArray = [String]()
    //排序后的监测点
    var monitors = [String]()
    var url = ""
    var readMonitorNum: String?
    // 偏好
    var userDefault = UserDefaultUtils()
    var sessionManager: SessionManager?
    var managedObectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    // #333333
    let textLabelColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    // #e5e5e5
    let lineColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 步骤一：获取总代理和托管对象总管
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            managedObectContext = appDelegate.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
        }
        if userDefault.getUser(forKey: "isChange")! == "yChange"{
            //网络请求
            print(userDefault.getUser(forKey: "isChange")!)
            macroRequst()
            monitorRequst()
        }else{
            print(userDefault.getUser(forKey: "isChange")!)
            if userDefault.getUser(forKey: "isSaveMacro") != nil{
                print("2")
                readMacro()
            }else{
                //网络请求
                print("3")
                macroRequst()
            }
        }

    }
    
    private func readMonitor(number:String) {
        print("进入readMonitor")
        // 清空数组
        self.monitorArray = []
        // 步骤二：建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Monitor")
        // 断言
        let predicates = NSPredicate(format: "unifiedNumber='\(number)'", "")
        fetchRequest.predicate = predicates
        // 步骤三：执行请求
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [Monitor]
            for one in fetchedResults! {
                self.monitorArray += [one.monPointName!]
                print("单位：名称：\(one.monPointName!) ")
            }
        } catch  {
            fatalError("获取失败")
        }
    }
    
    private func readMacro() {
        // 步骤二：建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Macro")
        // 步骤三：执行请求
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [Macro]
            print("进入macro数据库")
            for one in fetchedResults! {
                self.array += [one.name!]
                self.arrayNum += [one.unifiedNumber!]
            }
        } catch  {
            fatalError("获取失败")
        }
         self.setTable()
    }
    

    fileprivate func setTable() {
        self.myTableView = UITableView()
        self.myTableView!.frame = CGRect(x: 0, y: 80, width: self.Swidth, height: self.Sheight-20)
        self.myTableView!.delegate = self
        self.myTableView!.dataSource = self
        self.myTableView!.tableFooterView = UIView()
        self.myTableView!.separatorStyle = .none
        self.view.addSubview(self.myTableView!)
    }
    
    func macroRequst()  {
        url = Api.init().getMacroUrl()
        // 需要上传的参数集合
        let parameters = ["mobile": userDefault.getUser(forKey: "phoneNum")!,"imei":"0" ] as [String : Any]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        sessionManager?.request(url, method: .post, parameters: parameters).responseObject { (response: DataResponse<BaseModel>) in
            switch response.result {
            case .success:
                let myResponse = response.result.value
                //                        print(myResponse!.info!)
                let extractedExpr: [MacroInfoModel]? = Mapper<MacroInfoModel>().mapArray(JSONString: (myResponse?.info)!)
                
                if self.userDefault.getUser(forKey: "isSaveMacro") != nil{
                    self.macroDetel()
                }else{
                   
                }
                
                for forecast in extractedExpr! {
                    // 步骤二：建立一个entity
                    let entity = NSEntityDescription.entity(forEntityName: "Macro", in: self.managedObectContext)
                    
                    let macro = NSManagedObject(entity: entity!, insertInto: self.managedObectContext)
                    macro.setValue(forecast.disasterType, forKey: "disasterType")
                    macro.setValue(forecast.latitude, forKey: "latitude")
                    macro.setValue(forecast.legalR, forKey: "legalR")
                    macro.setValue(forecast.longitude, forKey: "longitude")
                    macro.setValue(forecast.macroscopicPhenomenon, forKey: "macroscopicPhenomenon")
                    macro.setValue(forecast.name, forKey: "name")
                    macro.setValue(forecast.unifiedNumber, forKey: "unifiedNumber")
                }
                // 步骤四：保存entity到托管对象中。如果保存失败，进行处理
                do {
                    try self.managedObectContext.save()
                    print("保存成功")
                    self.userDefault.putUser(text:"true", forKey: "isSaveMacro")
                    self.readMacro()
                } catch  {
                    fatalError("无法保存")
                }
            
            case .failure( _):
                  self.view.makeToast("数据请求失败", duration: 1, position: .center)
            }
           
        }
    }
    
    fileprivate func monitorDetel() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.fetchLimit = 10
        fetchRequest.fetchOffset = 0
        
        let entity = NSEntityDescription.entity(forEntityName: "Monitor", in: self.managedObectContext)
        fetchRequest.entity = entity
        
        fetchRequest.predicate = nil
        do {
            let fetchedObjects = try self.managedObectContext.fetch(fetchRequest) as! [Monitor]
            for one: Monitor in fetchedObjects {
                self.managedObectContext.delete(one)
                if #available(iOS 10.0, *) {
                    self.appDelegate.saveContext()
                } else {
                    // Fallback on earlier versions
                }
            }
        } catch  {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
        }
    }
    
    fileprivate func macroDetel() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.fetchLimit = 10
        fetchRequest.fetchOffset = 0
        
        let entity = NSEntityDescription.entity(forEntityName: "Macro", in: self.managedObectContext)
        fetchRequest.entity = entity
        fetchRequest.predicate = nil
        do {
            let fetchedObjects = try self.managedObectContext.fetch(fetchRequest) as! [Macro]
            for one: Macro in fetchedObjects {
                self.managedObectContext.delete(one)
         
                if #available(iOS 10.0, *) {
                    self.appDelegate.saveContext()
                } else {
                    // Fallback on earlier versions
                }
            }
            
        } catch  {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
        }
    }
    
    /*
     灾害点的监测点请求
     */
    func monitorRequst()  {
        url = "\(Api.init().getMonitorUrl())?mobile=\(userDefault.getUser(forKey: "phoneNum")!)&&imei=0"
        Alamofire.request(url).responseObject { (response: DataResponse<BaseModel>) in
            let myResponse = response.result.value
            let extractedExpr: [InfoModel]? = Mapper<InfoModel>().mapArray(JSONString: (myResponse?.info)!)
            self.monitorDetel()
            
            for forecast in extractedExpr! {
                // 步骤二：建立一个entity
                let entity = NSEntityDescription.entity(forEntityName: "Monitor", in: self.managedObectContext)
                
                let monitor = NSManagedObject(entity: entity!, insertInto: self.managedObectContext)
                
                // 步骤三：保存文本框中的值到monitor
                monitor.setValue(forecast.dimension, forKey: "dimension")
                monitor.setValue(forecast.instrumentConstant, forKey: "instrumentConstant")
                monitor.setValue(forecast.instrumentNumber, forKey: "instrumentNumber")
                monitor.setValue(forecast.legalR, forKey: "legalR")
                monitor.setValue(forecast.monAngle, forKey: "monAngle")
                monitor.setValue(forecast.monContent, forKey: "monContent")
                monitor.setValue(forecast.monDirection, forKey: "monDirection")
                monitor.setValue(forecast.monPointLocation, forKey: "monPointLocation")
                monitor.setValue(forecast.monPointName, forKey: "monPointName")
                monitor.setValue(forecast.monPointNumber, forKey: "monPointNumber")
                monitor.setValue(forecast.monType, forKey: "monType")
                monitor.setValue(forecast.unifiedNumber, forKey: "unifiedNumber")
                monitor.setValue(forecast.xpoint, forKey: "xpoint")
                monitor.setValue(forecast.ypoint, forKey: "ypoint")
            }
            do {
                try self.managedObectContext.save()
                print("保存成功")
            } catch  {
                fatalError("无法保存")
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     返回节的个数
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        print("1-")
        return array.count
    }

    /*
     返回某个节中的行数
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("2-")
        //默认至少有一个子项代表“宏观观测”
        var numOfCells = Array(repeating: 1, count: array.count)
        numOfCells[section] = monitorArray.count+1
        
        if clickNum == nil{
            return 0
        } else {
            if section == clickNum{
                return numOfCells[section]
            } else {
                return 0
            }
        }
    }

    /*
     为表视图单元格提供数据，该方法是必须实现的方法
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("3-")
        let str = "section"
        var cell = self.myTableView?.dequeueReusableCell(withIdentifier: str)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: str)
        }
        cell?.textLabel?.textAlignment = NSTextAlignment.center
        cell?.textLabel?.textColor = textLabelColor
        if indexPath.row == 0 {
            cell?.textLabel?.text = "宏观观测"
        } else{
            self.monitors = []
            // 对监测点数组排序
            self.monitors = monitorArray.sorted()
            for index in 1...monitors.count{
                if indexPath.row == index{
                    cell?.textLabel?.text = monitors[index-1]
                }
            }
        }
        //设置分隔线
        self.myTableView?.autoAddLineToCell(cell!, indexPath: indexPath, lineColor: lineColor)
        return cell!
    }
    
    /*
     选择cell
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath: \(indexPath.row)")
        self.myTableView!.deselectRow(at: indexPath, animated: true)
        //跳转页面
        if indexPath.row == 0 {
            //宏观观测页面
            
        } else{
            var senders = Array(repeating: "", count: 2)
            // 灾害点名称
            senders[0] = array[indexPath.section]
            // 监测点名称
            senders[1] = monitors[indexPath.row-1]
            self.performSegue(withIdentifier: "MonitorView", sender: senders)
        }
        
    }

    /*
     当触发segue的时候会调用此方法
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MonitorView" {
            let vc = segue.destination as! MonitorView
            let array1 = sender as? Array<String>
            vc.names = array1!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("4-")
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Swidth-20, height: 60))
        view.backgroundColor = UIColor.white
        //设置文本
        let title = UILabel(frame: CGRect(x: 18, y: 15, width: view.frame.size.width-10, height: 30))
        title.isUserInteractionEnabled = true
        title.tag = section
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(tap:)))
        title.addGestureRecognizer(tap)
        title.text = array[section]
        title.textColor = textLabelColor
        //设置图标
        let icon = UIImageView(frame: CGRect(x: view.frame.size.width-12, y: 22, width: 10, height: 18))
        icon.image = UIImage(named: "right")
        //设置分隔线
        let line = UIView(frame: CGRect(x: 18, y: 59, width: Swidth-38, height: 1))
        line.backgroundColor = lineColor
        view.addSubview(title)
        view.addSubview(icon)
        view.addSubview(line)
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        print("5-")
        return 60
    }

    @objc func tapGesture(tap:UITapGestureRecognizer){
        clickNum = tap.view?.tag
        readMonitorNum = arrayNum[clickNum!]
        print(readMonitorNum!)
        readMonitor(number: readMonitorNum!)
        if getClickNum == clickNum{
            clickNum = nil
        }
        myTableView!.reloadData()
        getClickNum = clickNum
    }

}

extension UITableView {
    private var FLAG_TABLE_VIEW_CELL_LINE: Int {
        get { return 977322 }
    }
    
    //自动添加线条
    func autoAddLineToCell(_ cell: UITableViewCell, indexPath: IndexPath, lineColor: UIColor) {
        let lineView = cell.viewWithTag(FLAG_TABLE_VIEW_CELL_LINE)
        if self.isNeedShow(indexPath) {
            if lineView == nil {
                self.addLineToCell(cell, lineColor: lineColor)
            }
        } else {
            lineView?.removeFromSuperview()
        }
    }
    
    private func addLineToCell(_ cell: UITableViewCell, lineColor: UIColor){
        let view = UIView(frame: CGRect(x: 18, y: 0, width: self.bounds.width-38, height: 0.5))
        view.tag = FLAG_TABLE_VIEW_CELL_LINE
        view.backgroundColor = lineColor
        cell.contentView.addSubview(view)
    }
    
    private func isNeedShow(_ indexPath: IndexPath) -> Bool {
        let countCell = self.countCell(indexPath.section)
        if 0 == countCell {
            return false
        }
        return true
    }
    
    private func countCell(_ atSection: Int) -> Int {
        return self.numberOfRows(inSection: atSection)
    }
}

