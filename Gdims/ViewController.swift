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
class ViewController: UIViewController {
    @IBOutlet weak var ipView: UIView!
    @IBOutlet weak var portView: UIView!
    @IBOutlet weak var phoneView: UIView!
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
        phoneInput.delegate = self
        if ((userDefault.getUser(forKey: "isSave") as String!) != nil) {
            self.ipInput.text = userDefault.getUser(forKey: "ips")
            self.portInput.text = userDefault.getUser(forKey: "ports")
            self.phoneInput.text = userDefault.getUser(forKey: "phoneNum")
        }
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
     点击空白处收起keyboard
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneInput.resignFirstResponder()
    }
    
}

extension ViewController: UITextFieldDelegate {
    /*
     回收系统键盘
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.origin.y = 0
        })
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let ipframe = ipView.frame
        let portframe = portView.frame
        let phoneframe = phoneView.frame
        /*
         35:键盘上tabbar高度
         52:两个textField之间的距离
         42:textField的高度
         */
        if textField.isEqual(ipInput) {
            UIView.animate(withDuration: 0.4, animations: {
                //            self.view.frame.origin.y = -100
                self.ipView.frame.origin.y = ipframe.origin.y - 35
            })
        } else if textField.isEqual(portInput) {
            UIView.animate(withDuration: 0.4, animations: {
                self.ipView.frame.origin.y = ipframe.origin.y - 35 - 52
                self.portView.frame.origin.y = portframe.origin.y - 35 - 52
            })
        } else if textField.isEqual(phoneInput) {
            UIView.animate(withDuration: 0.4, animations: {
                self.ipView.frame.origin.y = ipframe.origin.y - 52 - 42
                self.portView.frame.origin.y = portframe.origin.y - 52  - 42
                self.phoneView.frame.origin.y = phoneframe.origin.y - 52 - 42
            })
        }
    }
    
}
