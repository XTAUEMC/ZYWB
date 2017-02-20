//
//  ZYEmojiToolBar.swift
//  ZYWB
//
//  Created by zhangyi on 17/1/6.
//  Copyright © 2017年 zhangyi. All rights reserved.
//

import UIKit

protocol ZYEmojiToolBarDelegate:NSObjectProtocol {
    func clickButton(toolBar:ZYEmojiToolBar,buttonTag:Int)
}


class ZYEmojiToolBar: UIView {
    
    //当前选中的按钮
    var selectedBtn :UIButton?
    
    //代理
    weak var delegate :ZYEmojiToolBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    private func setUpUI(){
        let recentBtn = setUpButton(title: "最近", index: 0)
        let defaBtn = setUpButton(title: "默认", index: 1)
        let emojiBtn = setUpButton(title: "emoji", index: 2)
        let lxhBtn = setUpButton(title: "浪小花", index: 3)
        addSubview(recentBtn)
        addSubview(defaBtn)
        addSubview(emojiBtn)
        addSubview(lxhBtn)
        clickButton(button: defaBtn)
 
        
    }
    
    private func setUpButton(title:String,index:Int) -> UIButton{
        let button = UIButton()
        let width = self.width/4
        button.frame = CGRect(x: width * CGFloat(index), y: 0, width: width, height: self.height)
        button.setTitle(title, for: UIControlState.normal)
        button.setTitleColor(UIColor.color(hex: "ffffff"), for: UIControlState.normal)
        button.setTitleColor(UIColor.color(hex: "282828"), for: UIControlState.selected)
        button.backgroundColor = UIColor.color(hex: "b6b6b6")
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.tag = index
        button.addTarget(self, action: #selector(ZYEmojiToolBar.clickButton), for: UIControlEvents.touchUpInside)
        return button
    }
    
    func clickButton(button:UIButton){
        if button == self.selectedBtn {
            return
        }
        self.selectedBtn?.backgroundColor = UIColor.color(hex: "b6b6b6")
        self.selectedBtn?.isSelected = false
        button.backgroundColor = UIColor.color(hex: "f2f0f1")
        button.isSelected = true
        self.selectedBtn = button
        delegate?.clickButton(toolBar: self, buttonTag: button.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
