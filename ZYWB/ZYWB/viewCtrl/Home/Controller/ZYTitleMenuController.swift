//
//  ZYTitleMenuController.swift
//  ZYWB
//
//  Created by zhangyi on 16/11/18.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

class ZYTitleMenuController: UIViewController {
    
    var imageView:UIImageView?
    var tableView :UITableView?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        imageView = UIImageView()
        imageView?.frame = view.bounds
        let insets = UIEdgeInsetsMake(10, 10, 10, 10);
        //resizableImage
        //UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
        //UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片
        imageView!.image = UIImage(named: "popover_background")?.resizableImage(withCapInsets: insets, resizingMode: UIImageResizingMode.stretch)
        view.addSubview(imageView!)
        
        
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView!)
        
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView?.frame = view.bounds
        tableView?.frame = CGRect(x: 10, y: 15, width: view.bounds.width - 20, height: view.bounds.height - 25)
    }
    
    

    

}
