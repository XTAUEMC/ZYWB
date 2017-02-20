//
//  UIBarButtonItem-Category.swift
//  ZYWB
//
//  Created by zhangyi on 16/11/18.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    //如果再func前面加上class,就相当于OC中的+号方法
    class func creatBarButtonItem(image:String,target:Any?,action:Selector)->UIBarButtonItem{
        let button = UIButton()
        button.setImage(UIImage(named:image), for: UIControlState.normal)
        button.setImage(UIImage(named:image+"_highlighted"), for: UIControlState.highlighted)
        button.sizeToFit()
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        return UIBarButtonItem(customView: button)
    }

}
