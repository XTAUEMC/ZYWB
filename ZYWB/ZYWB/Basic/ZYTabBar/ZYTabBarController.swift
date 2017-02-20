//
//  ZYTabBarController.swift
//  ZYWB
//
//  Created by zhangyi on 16/11/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

class ZYTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.orange
        //添加子视图控制器
        setUpChildController()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //tabBar添加加号按钮
        tabBar.addSubview(centerBtn)
        
        let width = UIScreen.main.bounds.width/CGFloat((viewControllers?.count)!)
        centerBtn.frame = CGRect(x: 0, y: 0, width: width, height: 45)
        centerBtn.center = CGPoint(x: tabBar.bounds.width/2.0, y: tabBar.bounds.height/2.0)
        
    }
    
    //添加子视图控制器
    private func setUpChildController()  {
        
        //获取本地路径
        let path = Bundle.main.path(forResource: "MainVCSettings", ofType: "json")
        if let jsonPath = path {
            let data = NSData(contentsOfFile: jsonPath)
            do{
                //有可能发生异常的代码放到这里边
                //try :  发生异常会跳到catch中继续执行
                //try! : 发生异常程序直接崩溃
                let array = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                //在swift中,如果需要遍历一个数组,必须明确数据的类型
                for dict in array as! [[String:String]] {
                    setChileController(controller: dict["vcName"]!, title: dict["title"]!, image: dict["imageName"]!)
                }

            }catch{
                //发生异常之后会执行的代码
                setChileController(controller: "ZYHomeViewController", title: "首页", image: "tabbar_home")
                setChileController(controller: "ZYMessageViewController", title: "消息", image: "tabbar_message_center")
                setChileController(controller: "ZYPostStatusController", title: "", image: "")
                setChileController(controller: "ZYDiscoveryViewController", title: "发现", image: "tabbar_discover")
                setChileController(controller: "ZYMineViewController", title: "我的", image: "tabbar_profile")
                
            }
            
        }
    }
    
    //设置子视图控制器的属性
    private func setChileController(controller:String,title:String,image:String)  {
        //动态获取命名空间
        let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let className = NSClassFromString(name+"."+controller) as! UIViewController.Type
        let childVC = className.init()
        
        let nav = UINavigationController(rootViewController: childVC)
        childVC.navigationItem.title = title
        nav.tabBarItem.title = title;
        nav.tabBarItem.image = UIImage(named: image)
        nav.tabBarItem.selectedImage = UIImage(named:image+"_highlighted")
        self.addChildViewController(nav)
        
    }
    
    //MARK: 懒加载
    
    lazy var centerBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: UIControlState.selected)
  btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(ZYTabBarController.centerButtonClick), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    
    /**
     监听加号按钮点击
     注意:监听按钮点击的方法不能使私有方法
     按钮点击的方法是由运行循环监听,并以消息机制传递的,因此按钮点击的方法不能是私有的
     */
    func centerButtonClick() {
        let postVC = ZYPostStatusController()
        let nav = UINavigationController(rootViewController: postVC)
        present(nav, animated: true, completion: nil)
    }

    
}
