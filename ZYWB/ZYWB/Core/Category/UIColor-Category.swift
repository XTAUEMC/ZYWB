//
//  UIColor-Category.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

extension UIColor {
    //将16进制颜色值转换为UIColor
    class func color(hex:String) -> UIColor {
        var cString:String = (hex as NSString).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    class func randomColor()->UIColor {
        return UIColor(red: random(), green: random(), blue: random(), alpha: 1.0)
    }
    
    class func random() ->CGFloat {
        return CGFloat(arc4random()%256) / 255.0
    }
    
}
