//
//  MonitorView.swift --- 定量监测页面
//  Gdims
//
//  Created by 包宏燕 on 2017/10/16.
//  Copyright © 2017年 name. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import CoreLocation
import Toast_Swift
class MonitorView: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var monType: UILabel!
    // 灾害点名称
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var disasterName: UILabel!
    // 监测点名称
    @IBOutlet weak var monitorName: UILabel!
    // 发生日期
    @IBOutlet weak var happenDate: UILabel!
    // 定量监测名称
    @IBOutlet weak var inputName: UILabel!
    // 输入框
    @IBOutlet weak var inputNum: UITextField!
    
    // 偏好
    var userDefault = UserDefaultUtils()
    var sessionManager: SessionManager?
    var managedObectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()
    
    var names = [String]()
    var disNum:String!
    var dimension:String?
    var monTypeText:String?
    var strNowTime:String!
    var longitude:String! = "0.0"
    var latitude:String! = "0.0"
    var imageUrl: Any!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImageAction))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        initView()
    }
    @IBAction func saveBtn(_ sender: Any) {
        monitorDetel()
        saveMonitor()
    }
   
    @IBAction func postBtn(_ sender: Any) {
        let monitorType = "定量监测".data(using: String.Encoding.utf8)
        let serialNo = getTime().data(using: String.Encoding.utf8)
        let unifiedNumber = disNum!.data(using: String.Encoding.utf8)
        let monPointDate = happenDate.text!.data(using: String.Encoding.utf8)
        let measuredData = inputNum.text!.data(using: String.Encoding.utf8)
        let xpoint = longitude!.data(using: String.Encoding.utf8)
        let ypoint = latitude!.data(using: String.Encoding.utf8)
        let mobile = userDefault.getUser(forKey: "phoneNum")!.data(using: String.Encoding.utf8)
         let resets = "0".data(using: String.Encoding.utf8)
        //文件1
//        let path = Bundle.main.url(forResource: imageUrl as? String, withExtension: "png")!
//        let file1Data = try! Data(contentsOf: path)

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(xpoint!, withName: "xpoint")
                multipartFormData.append(ypoint!, withName: "ypoint")
                multipartFormData.append(mobile!, withName: "mobile")
                multipartFormData.append(resets!, withName: "resets")
                multipartFormData.append(serialNo!, withName: "serialNo")
                multipartFormData.append(monitorType!, withName: "monitorType")
                multipartFormData.append(unifiedNumber!, withName: "unifiedNumber")
                multipartFormData.append(monPointDate!, withName: "monPointDate")
                multipartFormData.append(measuredData!, withName: "measuredData")
//                multipartFormData.append(file1Data, withName: "file1",
//                                         fileName: "h.png", mimeType: "image/png")
        },
            to: Api.init().getSaveMonDateUrl(),
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        self.view.makeToast("上传成功", duration: 1, position: .center)
    }
    
    func initView() {
        disasterName.text = names[0]
        monitorName.text = names[1]
        // 步骤一：获取总代理和托管对象总管
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            managedObectContext = appDelegate.persistentContainer.viewContext
        }
        readMacro()
        monType.text = "\(monTypeText!)(\(dimension!)) :"
        readData()
    }
    
    func saveMonitor() {
        
        let entity = NSEntityDescription.entity(forEntityName: "MonitorData", in: self.managedObectContext)
        
        let monitorData = NSManagedObject(entity: entity!, insertInto: self.managedObectContext)
        monitorData.setValue(happenDate.text, forKey: "happenTime")
        monitorData.setValue(latitude, forKey: "latitude")
        monitorData.setValue(longitude, forKey: "longitude")
        monitorData.setValue(disNum, forKey: "disNum")
        monitorData.setValue(names[1], forKey: "monitorName")
        if inputNum.text == nil {
            monitorData.setValue(nil, forKey: "textNum")
        }else{
            monitorData.setValue(inputNum.text!.trimmingCharacters(in: .whitespaces), forKey: "textNum")
        }
        // 步骤四：保存entity到托管对象中。如果保存失败，进行处理
        do {
            try self.managedObectContext.save()
             self.view.makeToast("保存成功", duration: 1, position: .center)
        } catch  {
            fatalError("无法保存")
        }
    }
    private func readMacro() {
        // 步骤二：建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Macro")
        // 步骤三：执行请求
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [Macro]
            for one in fetchedResults! {
                if names[0] == one.name!{
                    self.disNum = one.unifiedNumber!
                    print(disNum)
                 readMonitor(number: disNum)
                }
            }
        } catch  {
            fatalError("获取失败")
        }
       
    }
    
    private func readData() {
        // 步骤二：建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MonitorData")
        // 步骤三：执行请求
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [MonitorData]
            for one in fetchedResults! {
                if one.happenTime != nil && disNum == one.disNum &&
                    names[1] == one.monitorName!{
                    happenDate.text = one.happenTime
                    inputNum.text = one.textNum
                    longitude = one.longitude
                    latitude = one.latitude
                    print(one.textNum!)
                }else{
                    let date = NSDate()
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    strNowTime = timeFormatter.string(from: date as Date) as String
                    happenDate.text = strNowTime
                    initLocation()
                }
            }
        } catch  {
            fatalError("获取失败")
        }
        
    }
    func getTime() -> String {
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let time = timeFormatter.string(from: date as Date) as String
        return time
    }
    private func readMonitor(number:String) {
        print("readMonitor,,,,,,,")
        // 步骤二：建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Monitor")
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [Monitor]
            for one in fetchedResults! {
                if disNum == one.unifiedNumber! && names[1] == one.monPointName{
                    self.dimension = one.dimension!
                    self.monTypeText = one.monType!
                   

                }
            }
        } catch  {
            fatalError("获取失败")
        }
    }
    
    fileprivate func monitorDetel() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.fetchLimit = 10
        fetchRequest.fetchOffset = 0
        
        let entity = NSEntityDescription.entity(forEntityName: "MonitorData", in: self.managedObectContext)
        fetchRequest.entity = entity
        
        fetchRequest.predicate = nil
        do {
            let fetchedObjects = try self.managedObectContext.fetch(fetchRequest) as! [MonitorData]
            for one: MonitorData in fetchedObjects {
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("didFinishPickingImage")
        //        self.imageView.image = info["UIImagePickerControllerEditedImage"] as? UIImage // 保存拍摄（编辑）后的图片到我们的imageView展示
        //        UIImageWriteToSavedPhotosAlbum((info["UIImagePickerControllerEditedImage"] as? UIImage)!, nil, nil, nil) // 将图片保存到相册
        print(info["UIImagePickerControllerReferenceURL"] as Any)
        imageUrl = info["UIImagePickerControllerReferenceURL"] as Any

        self.imageView.image = self.imageFromImage(imageFromImage: info["UIImagePickerControllerEditedImage"] as? UIImage, inRext: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        picker.dismiss(animated: true, completion: nil) // 退出相机界面
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        picker.dismiss(animated: true, completion: nil) // 退出相机界面
    }
    
    //2.实现这个方法,,就拿到了截取后的照片.
    func imageFromImage(imageFromImage:UIImage!,inRext:CGRect) ->UIImage{
        
        //将UIImage转换成CGImageRef
        
        let sourceImageRef:CGImage = imageFromImage.cgImage!
        
        //按照给定的矩形区域进行剪裁
        //        CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
        
        let newImageRef:CGImage = sourceImageRef.cropping(to: inRext)!
        //将CGImageRef转换成UIImage
        //        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
        let img:UIImage = UIImage.init(cgImage: newImageRef)
        
        //返回剪裁后的图片
        return img
        
    }
    
    func initLocation(){
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location:CLLocation = locations[0]
        latitude = String(location.coordinate.latitude)
        longitude = String(location.coordinate.longitude)
        print(latitude+longitude)
        
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
//MARK: 点击事件
extension MonitorView{
    
    @objc fileprivate func showImageAction(){
        // 先要判断相机是否可用
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.allowsEditing = true  // 允许拍摄图片后编辑
            self.present(picker, animated: true, completion: nil)
        } else {
            print("can't find camera")
        }
    }
}
