//
//  Define.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/5.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import Foundation
import UIKit

/** 屏幕宽度 */
let ScreenWidth = UIScreen.main.bounds.size.width
/** 屏幕高度 */
let ScreenHeight = UIScreen.main.bounds.size.height
/** iphone6和6s的适配尺寸 */
func pixw(float:CGFloat)->CGFloat{
    return (ScreenWidth/375.0) * float
}
