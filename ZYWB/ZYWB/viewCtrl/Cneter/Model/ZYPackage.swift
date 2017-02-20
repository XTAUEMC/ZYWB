//
//  ZYPackage.swift
//  ZYWB
//
//  Created by zhangyi on 17/1/6.
//  Copyright © 2017年 zhangyi. All rights reserved.
//

import UIKit

class ZYPackage: NSObject {
    //分组id
    var id :String?
    //分组名称
    var group_name_cn :String?
    //分组emoticons
    var emoticons :[ZYEmoticon]?
    
    init(id:String) {
        super.init()
        self.id = id
    }
    
    class func loadPackages() -> [ZYPackage]? {
        let path = Bundle.main.path(forResource: "emoticons", ofType: "plist", inDirectory: "Emoticons.bundle")
        let rootDict = NSDictionary(contentsOfFile: path!)
        let array = rootDict?["packages"] as! [[String:Any]]
        var packages = [ZYPackage]()
        packages.append(ZYEmojiTool.loadRecentEmoticon())
        for dict in array {
            let package = ZYPackage(id: dict["id"] as! String)
            package.loadEmoticons()
            package.loadEmptyEmoticons()
            packages.append(package)
        }
        
        return packages
    }
    
    private func loadEmoticons(){
        let dict = NSDictionary(contentsOfFile: infoPath())
        group_name_cn = dict?["group_name_cn"] as? String
        let emoticonArray = dict?["emoticons"] as! [[String:Any]]
        emoticons = [ZYEmoticon]()
        var index = 0
        for dic in emoticonArray {
            let emoticon = ZYEmoticon(dict: dic as NSDictionary, id: id!)
            if index == 20 {
                emoticons?.append(ZYEmoticon(isRemove: true))
                index = 0
            }
            emoticons?.append(emoticon)
            index += 1
        }
        
    }
    
    func loadEmptyEmoticons(){
        let count = emoticons!.count % 21
        for _ in count..<20 {
            emoticons?.append(ZYEmoticon(isRemove: false))
        }
        emoticons?.append(ZYEmoticon(isRemove: true))
        
    }
    
    private func infoPath() -> String {
        return ((ZYPackage.emoticonsPath() as NSString).appendingPathComponent(id!) as NSString).appendingPathComponent("info.plist")
    }
    
    class func emoticonsPath() -> String {
        return (Bundle.main.bundlePath as NSString).appendingPathComponent("Emoticons.bundle")
    }

}


class ZYEmoticon: NSObject,NSCoding {
    //emoji表情对应十六进制字符串
    var code :String?{
        didSet{
            //1.创建扫描器
            let scanner = Scanner(string: code!)
            //2.扫描16进制
            var result:UInt32 = 0
            scanner.scanHexInt32(&result)
            //3.生成表情字符串
            emoji = "\(Character(UnicodeScalar(result)!))"
        }
    }
    //emoji
    var emoji :String?
    //表情对应文字
    var chs :String?
    //表情对应图片
    var png :String?{
        didSet{
            if let pngStr = png {
                imagePath = ((ZYPackage.emoticonsPath() as NSString).appendingPathComponent(id!) as NSString).appendingPathComponent(pngStr)
            }
        }
    }
    //对应分组Id
    var id :String?
    
    //图片全路径
    var imagePath :String?
    
    //是否是删除按钮
    var isRemove :Bool = false
    
    init(isRemove:Bool) {
        super.init()
        self.id = ""
        self.isRemove = isRemove
    }
    
    init(dict:NSDictionary,id:String) {
        super.init()
        self.id = id
        self.setValuesForKeys(dict as! [String : Any])
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    //根据表情文字生成表情对象
    class func emoticonWithChs(chs:String) ->ZYEmoticon?{
        var emoticon:ZYEmoticon?
        for package in ZYPackage.loadPackages()! {
            emoticon = package.emoticons?.filter({ (emoticon) -> Bool in
                return emoticon.chs == chs
            }).last
            if emoticon != nil {
                break
            }
        }
        return emoticon
    }
    
    //MARK: 归档反归档
    func encode(with aCoder: NSCoder) {
        mj_encode(aCoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        //注意:这里要提前给id赋值,因为遍历属性赋值的顺序不确定,再给png赋值的时候,如果id=nil,就会导致程序崩溃
        self.id = aDecoder.decodeObject(forKey: "id") as! String?
        mj_decode(aDecoder)
        //这里需要重新计算imagePath的路径,因为这个路径存入硬盘后就固定不变了,而绝对路径在杀掉app重启app后就会改变,所以需要重新计算imagePath的路径
        if self.png != nil && self.id != nil {
            self.imagePath = ((ZYPackage.emoticonsPath() as NSString).appendingPathComponent(self.id!) as NSString).appendingPathComponent(self.png!)
        }
    }
    
    
}


