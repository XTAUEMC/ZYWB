//
//  ZYStatusTool.swift
//  ZYWB
//
//  Created by zhangyi on 17/1/12.
//  Copyright © 2017年 zhangyi. All rights reserved.
//

import UIKit

class ZYStatusTool: NSObject {
    
    //设置除表情外的正则表达式规则
    class func setUpPattern() ->String{
        // @的规则
        let atPattern = "@[0-9a-zA-Z\\u4e00-\\u9fa5]+"
        // #话题#的规则
        let topicPattern = "#[0-9a-zA-Z\\u4e00-\\u9fa5]+#"
        //url链接规则
        let urlPattern = "\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))"
        return atPattern + "|" + topicPattern + "|" + urlPattern
    }
    
    //设置表情
    class func setUpEmoticonText(text:String,EmoticonText:((NSAttributedString,NSRange)->())?){
        //1.正则表达式规则
        let pattern = "\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]"
        let array = self.matchSpecialText(text: text, pattern: pattern)
        if array != nil {
            var count = (array?.count)!
            while count > 0 {
                count -= 1
                let special = array![count] as! ZYSpecialText
                let emoticon = ZYEmoticon.emoticonWithChs(chs: special.text!)
                if let emo = emoticon {
                    let imageText = ZYEmojiAttachment.imageText(emoticon: emo, font: 17)
                    if EmoticonText != nil {
                        EmoticonText!(imageText,special.range!)
                    }
                }
            }
        }
    }
    
    
    //根据正则表达式规则匹配对应的特殊文字
    class func matchSpecialText(text:String,pattern:String) -> NSMutableArray?{
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let array = regex.matches(in: text, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, text.characters.count)) as [NSTextCheckingResult]
            let specials = NSMutableArray()
            for result in array {
                let range = result.range
                let specialText = ZYSpecialText()
                specialText.range = range
                specialText.text = (text as NSString).substring(with: range)
                specialText.textColor = UIColor.orange
                specialText.backGroundColor = UIColor.red
                specials.add(specialText)
            }
            return specials
        }catch{
            return nil
        }
        
        
    }
    
}
