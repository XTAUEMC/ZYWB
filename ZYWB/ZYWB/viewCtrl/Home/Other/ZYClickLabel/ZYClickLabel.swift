//
//  ZYClickLabel.swift
//  ZYWB
//
//  Created by zhangyi on 17/1/12.
//  Copyright © 2017年 zhangyi. All rights reserved.
//

import UIKit

//点击特殊文字回调
typealias ClickAction = (ZYSpecialText?) -> Void

private let specialTextBackGroundViewTag = 999

class ZYClickLabel: UITextView {
    
    
    //点击特殊文字回调
    var clickSpecialAction :((ZYSpecialText)->Void)?
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        //初始化
        setUpUI()
    }
    
    private func setUpUI() {
        self.isEditable = false
        self.isScrollEnabled = false
        self.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
    }
    
    //设置特殊文字点击
    func setClickSpecialText(specialText:ZYSpecialText,clickAction:ClickAction?){
        //将specialText加入到specials数组里边
        addSpecialText(special: specialText)
        self.clickSpecialAction = {
            (special)->Void in
            if clickAction != nil {
                clickAction!(special)
            }
        }
    }
    
    private func addSpecialText(special:ZYSpecialText){
        for specialText in specials {
            if NSStringFromRange(special.range!) == NSStringFromRange((specialText as! ZYSpecialText).range!) {
                specials.remove(specialText)
            }
        }
        specials.add(special)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取触摸对象
        let touch = (touches as NSSet).anyObject() as! UITouch
        //获取触摸点
        let point = touch.location(in: touch.view)
        //获取特殊文字的矩形区域
        setUpSpecialRects()
        //根据触摸点获取对应special
        let special = touchSpecialTextWithPoint(point: point)
        if special != nil {
            if special?.backGroundColor != nil {
                for rect in (special?.racts!)! {
                    let backView = UIView(frame: rect as! CGRect)
                    backView.backgroundColor = special?.backGroundColor!
                    backView.tag = specialTextBackGroundViewTag
                    insertSubview(backView, at: 0)
                }
                
            }
            if clickSpecialAction != nil {
                clickSpecialAction!(special!)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.touchesCancelled(touches, with: event)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for subView in subviews {
            if subView.tag == specialTextBackGroundViewTag {
                subView.removeFromSuperview()
            }
        }
    }
    
    private func setUpSpecialRects(){
        for specialText in specials {
            let special = specialText as! ZYSpecialText
            //设置选中区域(设置选中区域后,selectedTextRange也会被设置)
            self.selectedRange = special.range!
            //根据选中区域获取选中区域的rects
            let selectedRects = self.selectionRects(for: self.selectedTextRange!) as! [UITextSelectionRect]
            //将选中区域清空
            self.selectedRange = NSRange(location: 0, length: 0)
            let rects = NSMutableArray()
            for selectionRect in selectedRects {
                let rect = selectionRect.rect
                if rect.size.width == 0 || rect.size.height == 0 {
                    continue
                }
                rects.add(rect)
            }
            special.racts = rects
        }
    }
    
    //根据触摸点获取specialText
    private func touchSpecialTextWithPoint(point:CGPoint) ->ZYSpecialText?{
        for specialText in specials {
            let special = specialText as! ZYSpecialText
            for rect in special.racts! {
                if (rect as! CGRect).contains(point) {
                    return special
                }
            }
        }
        return nil
    }
    
    
    
    //设置特殊文字的样式
    class func setSpecialTextStyle(specialText:ZYSpecialText) ->NSAttributedString{
        let attributed = NSMutableAttributedString(string: (specialText.text)!)
        attributed.addAttributes([NSForegroundColorAttributeName:specialText.textColor!], range: NSMakeRange(0, specialText.text!.characters.count))
        return attributed
    }
    
    
    
    //MARK: 懒加载
    lazy var specials:NSMutableArray = NSMutableArray()
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

   

}
