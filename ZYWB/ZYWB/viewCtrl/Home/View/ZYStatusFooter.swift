//
//  ZYStatusFooter.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

class ZYStatusFooter: UIView {
    
    //status
    var status :ZYStatus?{
        didSet{
            let array = [status?.attitudes_count,status?.comments_count,status?.reposts_count]
            for i in 0 ..< btnArray.count {
                let button = btnArray[i]
                let number = array[i]
                if (number?.intValue)! > 0 {
                    button.setTitle(" \(number!)", for: UIControlState.normal)
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        //初始化UI
        setUpView()
    }
    
    
    private func setUpView(){
        addSubview(line)
        
        let imageArray = ["timeline_icon_retweet","timeline_icon_comment","timeline_icon_unlike"]
        for i in 0...2 {
            let button = UIButton(type: UIButtonType.custom)
            let btnWidth = ScreenWidth/3
            button.frame = CGRect(x: btnWidth * CGFloat(i), y: 0, width: btnWidth, height: pixw(float: 35))
            button.setImage(UIImage(named:imageArray[i]), for: UIControlState.normal)
            self.addSubview(button)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            btnArray.append(button)
            if i < 2 {
                let line = UIView(frame: CGRect(x: btnWidth * CGFloat(i+1), y: pixw(float: 7), width: 0.5, height: pixw(float: 21)))
                line.backgroundColor = UIColor.color(hex: "e6e6e6")
                addSubview(line)
            }
        }
        
    }
    
    
    
    lazy var line: UIView = {
        let line = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.5))
        line.backgroundColor = UIColor.color(hex: "e6e6e6")
        return line
    }()
    
    lazy var btnArray:[UIButton] = [UIButton]()

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
