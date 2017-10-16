//
//  DisasterView.swift
//  Gdims
//
//  Created by 包宏燕 on 2017/10/16.
//  Copyright © 2017年 name. All rights reserved.
//

import UIKit

class DisasterView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let tableView = UITableView()
    
    let Swidth = UIScreen.main.bounds.size.width
    let Sheight = UIScreen.main.bounds.size.height
    
    var clickNum:Int?
    var getClickNum:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = CGRect(x: 0, y: 35, width: Swidth, height: Sheight-20)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
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
        var cell = tableView.dequeueReusableCell(withIdentifier: str)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: str)
        }
        cell?.textLabel?.text = "这是第\(indexPath.section+1)个字段,第\(indexPath.row)个cell"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 10, y: 0, width: Swidth-20, height: 50))
        view.backgroundColor = UIColor.lightGray
        let title = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-10, height: 30))
        title.isUserInteractionEnabled = true
        title.tag = section
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(tap:)))
        title.addGestureRecognizer(tap)
        title.text = "这是第\(section+1)个段"
        view.addSubview(title)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func tapGesture(tap:UITapGestureRecognizer){
        clickNum = tap.view?.tag
        if getClickNum == clickNum{
            clickNum = nil
        }
        tableView.reloadData()
        getClickNum = clickNum
    }
    
}
