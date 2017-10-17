//
//  HomepageView.swift
//  GdimsIOS
//
//  Created by 包宏燕 on 2017/10/12.
//  Copyright © 2017年 bhy. All rights reserved.
//

import UIKit
import CoreLocation
class HomepageView: UIViewController,CLLocationManagerDelegate  {
    @IBOutlet weak var gpsDate: UILabel!
    @IBOutlet weak var location: UIView!
    @IBOutlet weak var gdims: UIView!
    @IBOutlet weak var callPhone: UIView!
    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarBackgroundColor(color: .black)
        
        callPhone.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(callAction))
        tapGesture.numberOfTapsRequired = 1
        callPhone.addGestureRecognizer(tapGesture)
        
        location.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(locationAction))
        tapGesture2.numberOfTapsRequired = 1
        location.addGestureRecognizer(tapGesture2)
        
        gdims.isUserInteractionEnabled = true
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(showDisasterAction))
        tapGesture3.numberOfTapsRequired = 1
        gdims.addGestureRecognizer(tapGesture3)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        
        let location:CLLocation = locations[0]
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let geocoder = CLGeocoder()
        
        let location1 = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location1){ (placeMarks:[CLPlacemark]?, error:Error?) ->Void in
            if (placeMarks?.count)! > 0
            {
                let placeMark = placeMarks?.first
                print("地名：\(placeMark!.name!) 经度：\(longitude) 纬度：\(latitude)")
                self.gpsDate.text = "地名：\(placeMark!.name!) "
            }
        }
    }
}
//MARK: 点击事件
extension HomepageView{
    
    @objc fileprivate func showDisasterAction(){
        //跳转页面
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DisasterView") as! DisasterView
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc fileprivate func callAction(){
      UIApplication.shared.openURL(URL(string: "telprompt://10086")!)
    }
    
    @objc fileprivate func locationAction(){
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 10
        ////发送授权申请
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
    }
    
}
