//
//  ZYTitleButton.swift
//  ZYWB
//
//  Created by zhangyi on 16/11/18.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

class ZYTitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor.black, for: UIControlState.normal)
        setImage(UIImage(named:"navigationbar_arrow_down"), for: UIControlState.normal)
        setImage(UIImage(named:"navigationbar_arrow_up"), for: UIControlState.selected)
        sizeToFit()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.maxX
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
