//
//  MacroTableViewCell.swift --- 自定义cell样式
//  Gdims
//
//  Created by 包宏燕 on 2017/10/27.
//  Copyright © 2017年 name. All rights reserved.
//

import UIKit

class MacroTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        yesBtn.addTarget(self, action: #selector(tapped1(_:)), for: .touchUpInside)
        noBtn.addTarget(self, action: #selector(tapped2(_:)), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func tapped1(_ btn: UIButton) {
        btn.setImage(UIImage(named:"checked"), for: .selected)
        btn.isSelected = true
        noBtn.setImage(UIImage(named:"unchecked"), for: .normal)
        noBtn.isSelected = false
    }
    
    @objc func tapped2(_ btn: UIButton) {
        btn.setImage(UIImage(named:"no"), for: .selected)
        btn.isSelected = true
        yesBtn.setImage(UIImage(named:"unchecked"), for: .normal)
        yesBtn.isSelected = false
    }
    
}
