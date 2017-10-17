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
import RealmSwift

class DisasterView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var myTableView: UITableView?
    let Swidth = UIScreen.main.bounds.size.width
    let Sheight = UIScreen.main.bounds.size.height
    var clickNum:Int?
    var getClickNum:Int?
    
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView = UITableView()
        self.myTableView!.frame = CGRect(x: 0, y: 80, width: Swidth, height: Sheight-20)
        self.myTableView!.delegate = self
        self.myTableView!.dataSource = self
        self.myTableView!.tableFooterView = UIView()
        self.view.addSubview(self.myTableView!)
        macroRequest()
        monitorRequst()
    }
    
    /*
     灾害点请求
     */
    func macroRequest() {
        url = "http://183.230.108.112:8099/meteor/findMacro.do"
    }
    
    /*
     灾害点的监测点请求
     */
    func monitorRequst()  {
        url = "http://183.230.108.112:8099/meteor/findMonitor.do?mobile=15702310784&&imei=0"
        Alamofire.request(url).responseObject { (response: DataResponse<BaseModel>) in
            let myResponse = response.result.value
            print(myResponse!.info!)
            let extractedExpr: [InfoModel]? = Mapper<InfoModel>().mapArray(JSONString: (myResponse?.info)!)
            //let realm = try! Realm()
            //try! realm.write {
            for forecast in extractedExpr! {
                //realm.create(InfoRealm.self, value: forecast, update: true)
                print(forecast.monPointName!)
                
            }
            //}
            //print("数据库路径: \(realm.configuration.fileURL)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numOfCells = [5,2,6,8,3]
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let str = "section"
        var cell = self.myTableView?.dequeueReusableCell(withIdentifier: str)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: str)
        }
        cell?.textLabel?.text = "这是第\(indexPath.section+1)个字段,第\(indexPath.row)个cell"
        
//        //设置
//        self.myTableView?.autoAddLineToCell(cell!, indexPath: indexPath, lineColor: UIColor.lightGray)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 10, y: 0, width: Swidth-20, height: 60))
        view.backgroundColor = UIColor.white
        //设置文本
        let title = UILabel(frame: CGRect(x: 18, y: 15, width: view.frame.size.width-10, height: 30))
        title.isUserInteractionEnabled = true
        title.tag = section
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(tap:)))
        title.addGestureRecognizer(tap)
        title.text = "这是第\(section+1)个段"
        title.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        //设置图标
        let icon = UIImageView(frame: CGRect(x: view.frame.size.width-12, y: 22, width: 10, height: 18))
        icon.image = UIImage(named: "right")
        //设置分隔线
        let line = UIView(frame: CGRect(x: 18, y: 59, width: Swidth-38, height: 1))
        line.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        view.addSubview(title)
        view.addSubview(icon)
        view.addSubview(line)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    @objc func tapGesture(tap:UITapGestureRecognizer){
        clickNum = tap.view?.tag
        if getClickNum == clickNum{
            clickNum = nil
        }
        myTableView!.reloadData()
        getClickNum = clickNum
//        tap.view?.backgroundColor = UIColor(red: 50/255, green: 187/255, blue: 170/255, alpha: 1)
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
        let view = UIView(frame: CGRect(x: 0, y: 99, width: self.bounds.width, height: 0.5))
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
