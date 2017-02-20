//
//  ZYEmojiKeyBoardController.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/30.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit


class ZYEmojiKeyBoardController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.初始化UI
        setUpUI()
    }
    
    private func setUpUI() {
        view.addSubview(contentView)
        view.addSubview(toolBar)
        
        contentView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 176)
        toolBar.y = contentView.maxY
        toolBar.delegate = self
        clickButton(toolBar: toolBar, buttonTag: 1)
    }
    
    //MARK: 懒加载
    
    //加载packages数据
    lazy var packages:[ZYPackage] = ZYPackage.loadPackages()!
    lazy var contentView:UIView = UIView()
    
    lazy var toolBar: ZYEmojiToolBar = ZYEmojiToolBar(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
    
    //最近
    lazy var recentListView: ZYEmojiListView = {
        let listView = ZYEmojiListView(frame: CGRect())
        listView.package = self.packages[0]
        return listView
    }()
    
    //默认
    lazy var defaultListView: ZYEmojiListView = {
        let listView = ZYEmojiListView(frame: CGRect())
        listView.package = self.packages[1]
        return listView
    }()
    //emoji
    lazy var emojiListView: ZYEmojiListView = {
        let listView = ZYEmojiListView(frame: CGRect())
        listView.package = self.packages[2]
        return listView
    }()
    
    //浪小花
    lazy var lxhListView: ZYEmojiListView = {
        let listView = ZYEmojiListView(frame: CGRect())
        listView.package = self.packages[3]
        return listView
    }()

}

extension ZYEmojiKeyBoardController: ZYEmojiToolBarDelegate{
    
    //MARK: ZYEmojiToolBarDelegate
    func clickButton(toolBar: ZYEmojiToolBar, buttonTag: Int) {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        switch buttonTag {
        case 0:
            contentView.addSubview(self.recentListView)
            break
        case 1:
            contentView.addSubview(self.defaultListView)
            break
        case 2:
            contentView.addSubview(self.emojiListView)
            break
        case 3:
            contentView.addSubview(self.lxhListView)
            break
        default:
            break
        }
        let view = contentView.subviews.last
        view?.frame = contentView.bounds.insetBy(dx: 0, dy: 0)
        
    }
    
}




