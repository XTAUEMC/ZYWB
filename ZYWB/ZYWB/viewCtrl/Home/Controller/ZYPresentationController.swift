//
//  ZYPresentationController.swift
//  ZYWB
//
//  Created by zhangyi on 16/11/18.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

class ZYPresentationController: UIPresentationController {
    
    var presentedFrame = CGRect.zero

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func containerViewWillLayoutSubviews() {
        //修改弹出视图的大小
        //containerView 容器视图
        //presentedView 被展示出来的视图
        if presentedFrame == CGRect.zero {
            presentedView?.frame = CGRect(x: 100, y: 56, width: 200, height: 250)
            presentedView?.center.x = UIScreen.main.bounds.width/2
        }else{
            presentedView?.frame = presentedFrame
        }
        
        //给容器视图上添加一个蒙版
        containerView?.insertSubview(coverView, at: 0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ZYPresentationController.close))
        coverView.addGestureRecognizer(tap)
        
        
    }
    
    func close() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.2
        coverView.frame = UIScreen.main.bounds
        return coverView
    }()
}
