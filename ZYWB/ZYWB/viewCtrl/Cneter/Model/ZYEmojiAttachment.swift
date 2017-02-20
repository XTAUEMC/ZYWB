//
//  ZYEmojiAttachment.swift
//  ZYWB
//
//  Created by zhangyi on 17/1/9.
//  Copyright © 2017年 zhangyi. All rights reserved.
//

import UIKit

class ZYEmojiAttachment: NSTextAttachment {
    
    //表情对应文字
    var chs :String?
    
    class func imageText(emoticon:ZYEmoticon,font:CGFloat)->NSAttributedString{
        let imageText = ZYEmojiAttachment()
        imageText.chs = emoticon.chs
        imageText.image = UIImage(contentsOfFile: emoticon.imagePath!)
        imageText.bounds = CGRect(x: 0, y: -4, width: font, height: font)
        return NSAttributedString(attachment: imageText)
    }

}
