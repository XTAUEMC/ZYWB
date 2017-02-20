//
//  ZYPostStatusController.swift
//  ZYWB
//
//  Created by zhangyi on 16/11/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//  发送微博界面

import UIKit

class ZYPostStatusController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.初始化导航条
        setUpNavigation()
        //2.初始化UI
        setUpUI()
        NotificationCenter.default.addObserver(self, selector: #selector(ZYPostStatusController.selectedEmoji), name: NSNotification.Name(selectedEmojiNotifation), object: nil)
    }
    
    func selectedEmoji(noti:Notification) {
        let emoticon:ZYEmoticon = noti.userInfo?[selectedEmojiKey] as! ZYEmoticon
        //将这个表情加入到最近列表中
        emojiKeyBoard.recentListView.addEmoticonToRecent(emoticon: emoticon)
        //点击删除按钮
        if emoticon.isRemove == true {
            textView.deleteBackward()
            return
        }
        if emoticon.emoji != nil {
            textView.insertText(emoticon.emoji!)
        }
        if emoticon.imagePath != nil {
            let attributed = NSMutableAttributedString(attributedString: textView.attributedText)
            let font = textView.font!.lineHeight
            let imageText = ZYEmojiAttachment.imageText(emoticon: emoticon, font: font)
            let range = textView.selectedRange
            attributed.replaceCharacters(in: range, with: imageText)
            attributed.addAttributes([NSFontAttributeName:textView.font!], range: NSRange(location: 0, length: attributed.length))
            textView.attributedText = attributed
            textView.selectedRange = NSRange(location: range.location + 1, length: 0)
            textViewDidChange(textView)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    private func setUpNavigation() {
        let leftBtn = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ZYPostStatusController.close))
        leftBtn.tintColor = UIColor.orange
        navigationItem.leftBarButtonItem = leftBtn
        let rightBtn = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ZYPostStatusController.post))
        rightBtn.tintColor = UIColor.orange
        rightBtn.isEnabled = false
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    private func setUpUI() {
        addChildViewController(emojiKeyBoard)
        //1.添加视图
        textView.addSubview(placeholder)
        view.addSubview(textView)
        //2.布局视图
        textView.delegate = self
        textView.inputAccessoryView = editToolBar
        editToolBar.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.frame = view.frame
        placeholder.origin = CGPoint(x: 5, y: 5)
        
                
    }
    
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func post() {
        var text = ""
        textView.attributedText.enumerateAttributes(in: NSRange(location: 0, length: textView.attributedText.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (objc, range, _) in
            if objc["NSAttachment"] != nil {
                //表情
                let attachment = objc["NSAttachment"] as! ZYEmojiAttachment
                text += attachment.chs!
            }else{
                //文字
                text += (textView.text as NSString).substring(with: range)
            }
        }
        print(text)
    }
    
    func switchEmojiKeyBoard(){
        if textView.inputView == nil {
            //弹出表情键盘
            textView.inputView = emojiKeyBoard.view
            editToolBar.isShowEmojiKeyBoard = true
        }else{
            textView.inputView = nil
            editToolBar.isShowEmojiKeyBoard = false
        }
        textView.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.textView.becomeFirstResponder()
        }
    }
    
    
    //MARK: 懒加载
    lazy var textView:UITextView = UITextView()
    lazy var placeholder:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.text = "分享新鲜事..."
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var popupView: UIView = {
        let inputView = UIView()
        inputView.size = CGSize(width: ScreenWidth, height: 40)
        inputView.backgroundColor = UIColor.orange
        return inputView
    }()
    
    lazy var emojiKeyBoard:ZYEmojiKeyBoardController = ZYEmojiKeyBoardController()
    
    lazy var editToolBar = ZYEditStatusToolBar(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: pixw(float: 50)))


}

extension ZYPostStatusController:UITextViewDelegate,ZYEditStatusToolBarDelegate {
    
    //MARK: UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        placeholder.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    //MARK: ZYEditStatusToolBarDelegate
    func changeEditStatus(toolBar: ZYEditStatusToolBar, button: UIButton) {
        switch button.tag {
        case 0:
            //拍照
            break
        case 1:
            //相册
            break
        case 2:
            //@好友
            break
        case 3:
            break
        case 4:
            //表情键盘
            switchEmojiKeyBoard()
            break
        default:
            break
        }
    }
}
