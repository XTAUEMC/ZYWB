//
//  ZYStatusForWardCell.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

class ZYStatusForWardCell: ZYHomeStatusCell {
    
    //在swift中重写父类的didSet方法不会覆盖父类的实现
    override var status :ZYStatus?{
        didSet{
            forwardText.attributedText = status?.retweeted_status?.attributedText
            forwardText.specials = (status?.retweeted_status?.specials) != nil ? (status?.retweeted_status?.specials)! : NSMutableArray()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        forwardBg.y = contentText.maxY + pixw(float: 10)
        forwardText.sizeToFit()
        forwardText.width = ScreenWidth - pixw(float: 20)
        picView.y = forwardText.maxY + pixw(float: 10) + pixw(float: forwardBg.y)
        let margin:CGFloat = picView.height == 0 ? pixw(float: 10) : pixw(float: 20)
        forwardBg.height = forwardText.maxY + margin + picView.height
        footer.y = forwardBg.maxY
        fullView.height = footer.maxY
    }
    

    override func setUpView() {
        super.setUpView()
        forwardBg.backgroundColor = UIColor.color(hex: "f7f7f7")
        forwardBg.addSubview(forwardText)
        fullView.insertSubview(forwardBg, belowSubview: picView)
        
        forwardBg.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 0)
        forwardText.origin = CGPoint(x: pixw(float: 10), y: pixw(float: 10))
    }
    
    lazy var forwardText: ZYClickLabel = {
        let label = ZYClickLabel()
        label.textColor = UIColor.darkGray
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 15)
        label.clickSpecialAction = {
            (special)->Void in
            let specialText = special as ZYSpecialText
            SVProgressHUD.showSuccess(withStatus: specialText.text)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                SVProgressHUD.dismiss()
            })
        }
        return label
    }()
    
    lazy var forwardBg:UIButton = UIButton()

}
