//
//  ZYRefreshControl.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

class ZYRefreshControl: UIRefreshControl {
    
    //旋转箭头
    private var rotationArrow :UIImageView?
    //提示文字
    private var tipTitle:UILabel?
    //加载视图
    private var loadView:UIImageView?
    //tipView
    private var tipView :UIView?

    override init() {
        super.init()
        //将自定义视图添加在refreshControl上边
        setUpView()
        //通过KVO监听下拉刷新的状态
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        
        tipView = UIView(frame: self.bounds)
        tipView?.backgroundColor = UIColor.color(hex: "e6e6e6")
        self.addSubview(tipView!)
        
        let arrowImage = UIImage(named: "tableview_pull_refresh")
        rotationArrow = UIImageView(frame: CGRect(x: 0, y: 0, width: (arrowImage?.size.width)!, height: (arrowImage?.size.height)!))
            rotationArrow?.image = arrowImage;
        rotationArrow?.centerY = (tipView?.height)!/2
        tipTitle = UILabel(frame: CGRect(x: (rotationArrow?.maxX)!, y: 0, width: 60, height: 60))
        tipTitle?.font = UIFont.systemFont(ofSize: 13)
        tipTitle?.textColor = UIColor.orange;
        tipTitle?.text = "下拉刷新"
        tipTitle?.sizeToFit()
        
        
        loadView = UIImageView(frame: (rotationArrow?.frame)!)
        loadView?.image = UIImage(named: "tableview_loading")
        loadView?.isHidden = true
        tipView?.addSubview(loadView!)
        tipView?.addSubview(rotationArrow!)
        tipView?.addSubview(tipTitle!)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tipTitle?.sizeToFit()
        tipTitle?.centerY = (tipView?.height)!/2
        tipView?.width = (tipTitle?.maxX)!
        tipView?.centerX = ScreenWidth/2
    }
    
    private var rotation = false
    //是否正在加载
    private var isLoading = false
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            let frameY = frame.origin.y
            if frameY >= 0 {
                return
            }
            
            if isRefreshing && !isLoading
            {
                //正在加载时
                isLoading = true
                startLoadingAnim()
                return
            }
            
            if frameY >= -self.height && rotation
            {
                rotation = false
                rotationAnimation(flag: rotation)
            }else if frameY < -self.height && !rotation{
                rotation = true
                rotationAnimation(flag: rotation)
            }
        }
    }
    
    //翻转箭头动画
    private func rotationAnimation(flag:Bool){
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        tipTitle?.text = flag ? "释放刷新" : "下拉刷新"
        UIView.animate(withDuration: 0.3) {
            self.rotationArrow?.transform = (self.rotationArrow?.transform)!.rotated(by: CGFloat(angle))
        }
    }
    
    //开始旋转加载动画
    private func startLoadingAnim() {
        tipTitle?.text = "加载中..."
        rotationArrow?.isHidden = true
        loadView?.isHidden = false
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2*M_PI
        anim.duration = 1.0
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = true
        loadView?.layer.add(anim, forKey: nil)
        
        
    }
    
    //停止旋转动画
    private func stopLoadingAnim() {
        rotationArrow?.isHidden = false
        loadView?.isHidden = true
        isLoading = false
        loadView?.layer.removeAllAnimations()
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        stopLoadingAnim()
    }
    

}


