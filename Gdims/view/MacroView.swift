//
//  MacroView.swift --- 宏观观测页面
//  Gdims
//
//  Created by 包宏燕 on 2017/10/25.
//  Copyright © 2017年 name. All rights reserved.
//

import UIKit

class MacroView: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var images: UIImageView?
    var phenosStr: String?
    var arrayPhenos = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        arrayPhenos = (phenosStr?.components(separatedBy: ","))!
        for i in arrayPhenos{
            print("arrayPhenos: \(i)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     点击拍照事件
     */
    @IBAction func doCamera(_ sender: Any) {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 保存拍摄（编辑）后的图片到我们的imageView展示
        self.images?.image = self.imageFromCutout(cutImage: info["UIImagePickerControllerEditedImage"] as? UIImage, inRext: CGRect(x: 0, y: 0, width: 80, height: 80))
        // 退出相机界面
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 退出相机界面
        picker.dismiss(animated: true, completion: nil)
    }
    
    /*
     获取裁剪后的图片
     */
    func imageFromCutout(cutImage: UIImage!,inRext: CGRect) -> UIImage {
        //将UIImage转换成CGImageRef
        let sourceImageRef:CGImage = cutImage.cgImage!
        let newImageRef:CGImage = sourceImageRef.cropping(to: inRext)!
        //将CGImageRef转换成UIImage
        let img:UIImage = UIImage.init(cgImage: newImageRef)
        //返回剪裁后的图片
        return img
    }
    
    /*
     返回TableView的行数，必须实现该方法
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("1---\(arrayPhenos.count)")
        return arrayPhenos.count-1
    }
    
    /*
     自定义每一行要显示的效果，必须实现该方法
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myTableView.dequeueReusableCell(withIdentifier:
            "macroCell", for: indexPath) as! MacroTableViewCell
        //取消选中cell的颜色
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.title.text = arrayPhenos[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    /*
     释放当前页面
     */
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

