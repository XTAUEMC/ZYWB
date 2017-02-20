//
//  ZYPresentAnimation.swift
//  ZYWB
//
//  Created by zhangyi on 16/11/18.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit


let titleMenuWillShow = "titleMenuWillShow"
let titleMenuWillDismiss = "titleMenuWillDismiss"


class ZYPresentAnimator: NSObject ,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning
{
    
    var isShow :Bool?
    var presentedFrame = CGRect.zero

    //MARK: UIViewControllerTransitioningDelegate
    
    //实现代理方法,告诉系统谁来转场
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?{
        let VC = ZYPresentationController(presentedViewController: presented, presenting: presenting) 
        VC.presentedFrame = presentedFrame
        return VC
    }
    
    //MARK: 只要实现了这两个方法,系统默认的动画就没有了,所有的动画都需要我们自己实现
    //告诉系统谁来负责modal的展现动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        //将要展示时,将isShow设为true
        NotificationCenter.default.post(name: NSNotification.Name(titleMenuWillShow), object: self)
        isShow = true
        return self
    }
    
    //告诉系统谁来负责modal的消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        //将要消失时,将isShow设为false
        NotificationCenter.default.post(name: NSNotification.Name(titleMenuWillDismiss), object: self)
        isShow = false
        return self
    }
    
    
    //MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        
        if isShow == true {
            //1.获取将要展示的视图
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            toView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
            //2.注意:一定要将视图添加到容器视图上
            if let view = toView {
                transitionContext.containerView.addSubview(view)
                view.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            }
            
            //3.设置展示视图的动画
            UIView.animate(withDuration: 0.5, animations: {
                //3.1清空transform
                toView?.transform = CGAffineTransform.identity
                
            }, completion: {
                (_)->() in
                //3.2 动画执行完毕,一定要告诉系统
                //如果不写,可能导致一些位置错误
                transitionContext.completeTransition(true)
            })
        }else{
            //获取fromView
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            UIView.animate(withDuration: 0.3, animations: {
                fromView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.00000001)
            }, completion: { (_) in
                //告诉系统已经完成
                transitionContext.completeTransition(true)
            })
            
            
        }
    }
    
    
    
    
}

