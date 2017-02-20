//
//  ZYWBModel.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//  微博模型

import UIKit

class ZYStatus: BasicModel {
    //
    var attitudes_count :NSNumber?
    //评论数
    var comments_count :NSNumber?
    //创建时间
    var created_at :String?{
        didSet{
            let date = NSDate.dateWithStr(time: created_at!)
            created_at = date.desTime
        }
    }
    //微博id
    var idstr :String?
    //微博图片数组
    var pic_urls :[[String:AnyObject]]?{
        didSet{
            picUrls = NSMutableArray()
            picLargeUrls = [NSURL]()
            if pic_urls == nil {
                return
            }
            for dict:[String:AnyObject] in pic_urls! {
                let picUrl = dict["thumbnail_pic"] as! String
                picUrls?.add(NSURL(string: picUrl))
                let largeUrl = picUrl.replacingOccurrences(of: "thumbnail", with: "large")
                picLargeUrls?.append(NSURL(string: largeUrl)!)
            }
        }
    }
    //图片URLS
    var picUrls :NSMutableArray?
    //大图数组
    var picLargeUrls:[NSURL]?
    //大图数组urls
    var largeUrls :[NSURL]?{
        return retweeted_status != nil ? retweeted_status?.picLargeUrls : picLargeUrls
    }
    //reposts_count
    var reposts_count :NSNumber?
    //来源
    var source :String?{
        didSet{
            if let str = source {
                //获取开始位置
                let startLocation = (str as NSString).range(of: ">").location + 1
                //获取长度
                let length = (str as NSString).range(of: "<", options: NSString.CompareOptions.backwards).location - startLocation
                source = "来自:" + (str as NSString).substring(with: NSRange(location: startLocation, length: length))
            }
        }
    }
    //微博内容
    var text :String?{
        didSet{
            if let textStr = text {
            attributedText = NSMutableAttributedString(string: text!)
            //2.设置表情图片
            ZYStatusTool.setUpEmoticonText(text: textStr, EmoticonText: { (imageText,range) in
                self.attributedText?.replaceCharacters(in: range, with: imageText)
            })
            //1.处理话题和其他特殊字符
                //设置规则
                let pattern = ZYStatusTool.setUpPattern()
                //根据规则拿到匹配后的结果
                let specials = ZYStatusTool.matchSpecialText(text: (attributedText?.string)!, pattern: pattern)
                if specials != nil {
                    self.specials = specials
                    for special in specials! {
                        let speaiclText = special as! ZYSpecialText
                        //设置特殊文字的样式
                        let specialAtt = ZYClickLabel.setSpecialTextStyle(specialText: speaiclText)
                        self.attributedText?.replaceCharacters(in: speaiclText.range!, with: specialAtt)
                    }
                }else{
                    self.specials = nil
                }
               
                attributedText?.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 15)], range: NSMakeRange(0, (attributedText?.length)!))
            }
        }
    }
    //富文本微博内容
    var attributedText :NSMutableAttributedString?
    //特殊文字数组
    var specials :NSMutableArray?
    //转发微博
    var retweeted_status :ZYStatus?
    //微博发布人
    var user :ZYStatusUser?
}
