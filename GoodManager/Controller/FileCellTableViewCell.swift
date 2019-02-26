//
//  FileCellTableViewCell.swift
//  GoodManager
//
//  Created by DJ on 2019/2/25.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import UIKit

class FileCellTableViewCell: UITableViewCell {

    @IBOutlet weak var underView: UIView!
    
    @IBOutlet weak var fileNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // 设置cell 圆角
        underView.layer.masksToBounds = true
        underView.layer.cornerRadius = 10
        self.selectedBackgroundView?.backgroundColor = UIColor.lightGray
        self.underView.backgroundColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
