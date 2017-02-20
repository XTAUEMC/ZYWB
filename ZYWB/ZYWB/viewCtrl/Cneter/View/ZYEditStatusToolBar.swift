//
//  ZYEditStatusToolBar.swift
//  ZYWB
//
//  Created by zhangyi on 17/1/9.
//  Copyright © 2017年 zhangyi. All rights reserved.
//

import UIKit

protocol ZYEditStatusToolBarDelegate:NSObjectProtocol {
    func changeEditStatus(toolBar:ZYEditStatusToolBar,button:UIButton)
}

class ZYEditStatusToolBar: UIView {
    
    //代理
    weak var delegate :ZYEditStatusToolBarDelegate?
    //是否显示表情键盘
    var isShowEmojiKeyBoard :Bool?{
        didSet{
            var image:String?;
            var higImage:String?
            if isShowEmojiKeyBoard == true {
                image = "compose_keyboardbutton_background"
                higImage = "compose_keyboardbutton_background_highlighted"
            }else{
                image = "compose_emoticonbutton_background"
                higImage = "compose_emoticonbutton_background_highlighted"
            }
            emojiBtn.setImage(UIImage(named:image!), for: UIControlState.normal)
            emojiBtn.setImage(UIImage(named:higImage!), for: UIControlState.highlighted)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.color(hex: "f7f7f7")
        let cameraBtn = setUpToolBarButton(index: 0, img: "compose_camerabutton_background")
        let pictureBtn = setUpToolBarButton(index: 1, img: "compose_toolbar_picture")
        let mentionbtn = setUpToolBarButton(index: 2, img: "compose_mentionbutton_background")
        let trendbtn = setUpToolBarButton(index: 3, img: "compose_trendbutton_background")
        addSubview(cameraBtn)
        addSubview(pictureBtn)
        addSubview(mentionbtn)
        addSubview(trendbtn)
        addSubview(emojiBtn)

        
    }
    
    private func setUpToolBarButton(index:Int,img:String) ->UIButton{
        let button = UIButton(type: UIButtonType.custom)
        button.tag = index
        let width = self.width/5
        button.frame = CGRect(x: width * CGFloat(index), y: 0, width: width, height: self.height)
        button.setImage(UIImage(named:img), for: UIControlState.normal)
        button.setImage(UIImage(named:"\(img)_highlighted"), for: UIControlState.highlighted)
        button.addTarget(self, action: #selector(ZYEditStatusToolBar.changeEditMode), for: UIControlEvents.touchUpInside)
        return button

    }
    
    func changeEditMode(button:UIButton) {
        delegate?.changeEditStatus(toolBar: self, button: button)
    }
    
    //MARK: 懒加载
    lazy var emojiBtn:UIButton = self.setUpToolBarButton(index: 4, img: "compose_emoticonbutton_background")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
