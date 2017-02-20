
//
//  NSDate-Category.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/26.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import Foundation

extension NSDate {
    class func dateWithStr(time:String) ->NSDate{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        formatter.locale = Locale(identifier: "en")
        let date = formatter.date(from: time)
        return date! as NSDate
    }
    
    //具体时间
    var desTime :String{
        //获取日历
        let calender = Calendar.current
        var formatterStr = " HH:mm"
        
        //1.判断是否是今天
        if calender.isDateInToday(self as Date) {
            let since = Int(NSDate().timeIntervalSince(self as Date))
            if since < 60 {
                //1.1 一分钟内
                return "刚刚"
            }else if since < 60*60 {
                //1.2 一小时内
                return "\(since/60)分钟前"
            }
            //1.3 多少小时前
            return "\(since/60/60)小时前"
        }else if calender.isDateInYesterday(self as Date){
            //2.判断是否是昨天
            formatterStr = "昨天"+formatterStr
        }else{
            //MARK: Waring - 比较年份有问题
            let comp = calender.compare(self as Date, to: NSDate() as Date, toGranularity: Calendar.Component.year)
            if comp.rawValue < 1 {
                //3.一年内(年份相差小于1年)
                formatterStr = "MM-dd"+formatterStr
            }else{
                //4.更早时间(年份相差大于或等于1年)
                formatterStr = "yyyy-MM-dd"+formatterStr
            }
        }
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        formatter.locale = Locale(identifier: "en")
        
        return formatter.string(from: self as Date)
    }
    
    
}
