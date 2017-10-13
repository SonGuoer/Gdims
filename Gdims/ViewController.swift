//
//  ViewController.swift
//  GdimsIOS
//
//  Created by 包宏燕 on 2017/10/10.
//  Copyright © 2017年 bhy. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import Toast_Swift
import RealmSwift
class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var ipInput: UITextField!
    @IBOutlet weak var portInput: UITextField!
    @IBOutlet weak var phoneInput: UITextField!
    var ips = "192.168.1.1"
    var ports = "8080"
    var phoneNum = "110"
    var activityIndicator:UIActivityIndicatorView!
    var sessionManager:SessionManager?
    var userDefault = UserDefaultUtils()
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var style = ToastStyle()
        style.messageColor = .blue
        ipInput.delegate = self
        portInput.delegate = self
        if ((userDefault.getUser(forKey: "isSave") as String!) != nil) {
            self.ipInput.text = userDefault.getUser(forKey: "ips")
            self.portInput.text = userDefault.getUser(forKey: "ports")
            self.phoneInput.text = userDefault.getUser(forKey: "phoneNum")
        }
        // macroRequst()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phoneCheck(_ sender: Any) {
        if (self.phoneInput.text?.characters.count)!>11{
            self.view.makeToast("号码不能超过11位", duration: 1, position: .center)
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        print("123")
        /*获取输入框文本*/
        phoneNum = phoneInput.text!.trimmingCharacters(in: .whitespaces)
        ips = ipInput.text!.trimmingCharacters(in: .whitespaces)
        ports = portInput.text!.trimmingCharacters(in: .whitespaces)
        /*设置存储信息*/
        userDefault.putUser(text: phoneNum, forKey: "phoneNum")
        userDefault.putUser(text:ips, forKey: "ips")
        userDefault.putUser(text:ports, forKey: "ports")
        userDefault.putUser(text:"true", forKey: "isSave")
        if phoneNum.isEmpty {
            self.view.makeToast("号码不能为空", duration: 1, position: .center)
        }else if ips.isEmpty {
            self.view.makeToast("ip不能为空", duration: 1, position: .center)
            
        }else if ports.isEmpty {
            self.view.makeToast("端口不能为空", duration: 1, position: .center)
            
        }else{
            //启动网络请求
            loginRequst()
            self.view.makeToastActivity(.center)
        }
    }
    
    func loginRequst()  {
        url = Api.init().getLoginUrl()
        
        self.view.isUserInteractionEnabled = false
        /*需要上传的参数集合*/
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        let parameters = ["mobile": phoneNum,"imei":"0" ] as [String : Any]
        sessionManager = Alamofire.SessionManager(configuration: configuration)
        /*上传的Alamofire方法*/
        sessionManager?.request(url,method:.post, parameters: parameters).responseObject { (response: DataResponse<BaseModel>) in
            switch response.result {
            case .success:
                if let values = response.result.value {
                    print(values.info!)
                    if values.result == "1" {
                        if values.info == "{}"{
                            self.view.makeToast("没有查到该号码对应的群测群防人员", duration: 1, position: .center)
                            self.view.hideToastActivity()
                        }
                        else{
                            self.view.hideToastActivity()
                            self.view.makeToast("登录成功", duration: 1, position: .center)
                            //跳转页面
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "HomepageView") as! HomepageView
                            self.present(vc, animated: true, completion: nil)
                        }
                    }else{
                        self.view.makeToast("没有查到该号码对应的群测群防人员", duration: 1, position: .center)
                        self.view.hideToastActivity()
                    }
                    
                    self.view.isUserInteractionEnabled = true
                }
            case .failure(let error):
                print(error)
                self.view.makeToast("登录失败,请检查登录信息", duration: 1, position: .center)
                self.view.isUserInteractionEnabled = true
                self.view.hideToastActivity()
            }
        }
    }
    
    /*
     回收系统键盘
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
     点击空白处收起keyboard
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneInput.resignFirstResponder()
    }
    
    //     func macroRequst()  {
    //            url = "http://183.230.108.112:8099/meteor/findMonitor.do?mobile=15702310784&&imei=0"
    //            Alamofire.request(url).responseObject { (response: DataResponse<BaseModel>) in
    //                let myResponse = response.result.value
    //                print(myResponse!.info!)
    //                let extractedExpr: [InfoModel]? = Mapper<InfoModel>().mapArray(JSONString: (myResponse?.info)!)
    //                let realm = try! Realm()
    //                try! realm.write {
    //                    for forecast in extractedExpr! {
    //                    realm.create(InfoRealm.self, value: forecast, update: true)
    //
    //                    }
    //               }
    //                print("数据库路径: \(realm.configuration.fileURL)")
    //            }
    //        }
    
}
