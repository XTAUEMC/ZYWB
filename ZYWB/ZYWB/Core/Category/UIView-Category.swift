//
//  UIView-Category.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/5.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

extension UIView{
    //** x */
    var x :CGFloat {
        set{
            frame.origin.x = newValue
        }
        get{
            return frame.origin.x
        }
    }
    
    //** y */
    var y :CGFloat {
        set{
            frame.origin.y = newValue
        }
        get{
            return frame.origin.y
        }
    }
    
    //** 宽度 */
    var width :CGFloat {
        set{
            frame.size.width = newValue
        }
        get{
            return frame.size.width
        }
    }
    
    //** 高度 */
    var height :CGFloat {
        set{
            self.frame.size.height = newValue
        }
        get{
            return self.frame.size.height
        }
    }
    
    //** centerX */
    var centerX :CGFloat {
        set{
            center.x = newValue
        }
        get{
            return center.x
        }
    }
    
    //** centerY */
    var centerY :CGFloat {
        set{
            center.y = newValue
        }
        get{
            return center.y
        }
    }
    
    //** maxX */
    var maxX :CGFloat {
        set{
            self.maxX = newValue
        }
        get{
            return x+width
        }
    }
    
    //** maxY */
    var maxY :CGFloat {
        set{
            self.maxY = newValue
        }
        get{
            return y+height
        }
    }
    
    //坐标
    var origin :CGPoint{
        set{
            self.frame.origin = newValue
        }
        get{
            return frame.origin
        }
    }
    
    //大小
    var size :CGSize{
        set{
            self.frame.size = newValue
        }
        get{
            return frame.size
        }
    }
    
    
}
