//
//  ZYHomeUser.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

class ZYStatusUser: BasicModel {

    //用户id
    var idstr :String?
    //用户等级
    var mbrank :NSNumber?{
        didSet{
            let rank = mbrank?.intValue
            if rank! > 0 && rank! < 7 {
                rankImage = UIImage(named: "common_icon_membership_level\(rank!)")
            }
        }
    }
    //等级图标
    var rankImage :UIImage?
    //用户id
    var mbtype :NSNumber?
    //用户昵称
    var name :String?
    //用户图像
    var profile_image_url :String?{
        didSet{
            if let url = profile_image_url {
                imageUrl = NSURL(string: url)
            }
        }
    }
    //用户图像url
    var imageUrl :NSURL?
    //用户认证类型(-1: 没有认证,0: 认证用户,2/3/5: 企业认证,220:达人)
    var verified_type :NSNumber?{
        didSet{
            switch (verified_type?.intValue)! {
            case 2,3,5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
            }
        }
    }
    //认证图标
    var verifiedImage :UIImage?
    //vip等级
    var vip :NSNumber?
}
