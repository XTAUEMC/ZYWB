//
//  ZYEmojiTool.swift
//  ZYWB
//
//  Created by zhangyi on 17/1/9.
//  Copyright © 2017年 zhangyi. All rights reserved.
//

import UIKit

let RecentEmoticonDataPlist = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString).appendingPathComponent("recentEmoticons.archive")

class ZYEmojiTool: NSObject {
    //加载最近表情
    class func loadRecentEmoticon() ->ZYPackage{
        let package = ZYPackage(id: "")
        package.group_name_cn = "最近"
        if ZYEmojiTool.recentEmoticons() != nil {
            print(ZYEmojiTool.recentEmoticons()!)
            package.emoticons = ZYEmojiTool.recentEmoticons()
        }else{
            package.emoticons = [ZYEmoticon]()
            package.loadEmptyEmoticons()
        }
        return package
    }
    
    //将最近表情写入沙盒
    class func writeRecentEmoticons(emoticons:[ZYEmoticon]){
        NSKeyedArchiver.archiveRootObject(emoticons, toFile: RecentEmoticonDataPlist)
    }
    
    class func recentEmoticons() ->[ZYEmoticon]?{
        print(RecentEmoticonDataPlist)
        return NSKeyedUnarchiver.unarchiveObject(withFile: RecentEmoticonDataPlist) as? [ZYEmoticon]
    }
    
    
    
}
