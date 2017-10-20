//
//  MonitorView.swift --- 定量监测页面
//  Gdims
//
//  Created by 包宏燕 on 2017/10/16.
//  Copyright © 2017年 name. All rights reserved.
//

import UIKit

class MonitorView: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
    
    var names = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImageAction))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        initView()
    }
    
    func initView() {
        disasterName.text = names[0]
        monitorName.text = names[1]
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        happenDate.text = strNowTime
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("didFinishPickingImage")
//        self.imageView.image = info["UIImagePickerControllerEditedImage"] as? UIImage // 保存拍摄（编辑）后的图片到我们的imageView展示
//        UIImageWriteToSavedPhotosAlbum((info["UIImagePickerControllerEditedImage"] as? UIImage)!, nil, nil, nil) // 将图片保存到相册
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
