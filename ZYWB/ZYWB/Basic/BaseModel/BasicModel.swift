//
//  BasicModel.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

class BasicModel: NSObject {
    
    /**
     字典转模型
    */
    class func model(dict:NSDictionary) -> BasicModel{
        let model = self.mj_object(withKeyValues: dict)
        return model!
    }
    
    /**
     模型转字典
     */
    public func keyValue() -> NSMutableDictionary{
        let dict = self.mj_keyValues()
        return dict!
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
