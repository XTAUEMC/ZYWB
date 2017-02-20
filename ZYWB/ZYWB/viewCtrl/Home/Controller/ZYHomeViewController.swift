//
//  ZYHomeViewController.swift
//  ZYWB
//
//  Created by zhangyi on 16/11/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit


private let nomalCell = "NomalCell"
private let forWardCell = "ForWardCell"

class ZYHomeViewController: UITableViewController {
    
    //rowCache
    var rowCache :[String:CGFloat] = [String:CGFloat]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化导航条
        setUpNavation()
        //初始化UI
        setUpTableView()
        //接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(ZYHomeViewController.change), name: NSNotification.Name(titleMenuWillShow), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZYHomeViewController.change), name: NSNotification.Name(titleMenuWillDismiss), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZYHomeViewController.showPhotoBrowser), name: NSNotification.Name(ZYPictureViewSelected), object: nil)
       
    }
    
    private func setUpTableView() {
        tableView.register(ZYStatusForWardCell.classForCoder(), forCellReuseIdentifier: forWardCell)
        tableView.register(ZYHomeStatusCell.classForCoder(), forCellReuseIdentifier: nomalCell)
        tableView.backgroundColor = UIColor.color(hex: "e6e6e6")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //加载数据
        loadData()
        refreshControl = ZYRefreshControl.init()
        refreshControl?.addTarget(self, action: #selector(ZYHomeViewController.loadData), for: UIControlEvents.valueChanged)
    }
    
    @objc private func loadData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            self.refreshControl?.endRefreshing()
        }
    }
    
    //MARK: 接收通知消息
    func change(){
        let button = navigationItem.titleView as! ZYTitleButton
        button.isSelected = !button.isSelected
    }
    
    func showPhotoBrowser(noti:Notification) {
        //先判断是否接收到数据
        let userInfo = noti.userInfo
        if userInfo?[ZYPictureViewSelectedIndex] == nil {
            return
        }
        if userInfo?[ZYPictureViewSelectedUrls] == nil {
            return
        }
        let browser = ZYPhotoBrowserController(index: (userInfo?[ZYPictureViewSelectedIndex] as! NSIndexPath).item, urls: userInfo?[ZYPictureViewSelectedUrls] as! [NSURL])
        self .present(browser, animated: true, completion: nil)
    }
    
    
    //MARK: 导航相关
    
    //初始化导航条
    private func setUpNavation(){
        
        //初始化左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem(image: "navigationbar_friendattention", target: self, action: #selector(ZYHomeViewController.navLeftButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem(image: "navigationbar_pop", target: self, action: #selector(ZYHomeViewController.navRightButtonClick))
        
        //初始化标题按钮
        let titleBtn = ZYTitleButton()
        titleBtn.setTitle("雪中寒梅 ", for: UIControlState.normal)
        titleBtn.addTarget(self, action: #selector(ZYHomeViewController.titleButtonClick), for: UIControlEvents.touchUpInside)
        navigationItem.titleView = titleBtn
        

    }
    
    func titleButtonClick(button:ZYTitleButton) {
        let titleMenu = ZYTitleMenuController()
        titleMenu.transitioningDelegate = presentAnimator
        titleMenu.modalPresentationStyle = UIModalPresentationStyle.custom
        
        present(titleMenu, animated: true, completion: nil)
        
        
    }
    
    func navLeftButtonClick() {
        print("点击了左边")
    }
    
    func navRightButtonClick() {
        let storyboard = UIStoryboard.init(name: "ORCode", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
        
    }
    
    //MARK: 懒加载
    lazy var presentAnimator: ZYPresentAnimator = {
        let animator = ZYPresentAnimator()
        animator.presentedFrame = CGRect(x: (UIScreen.main.bounds.width - 200)/2, y: 56, width: 200, height: 300)
        return animator
    }()
    
    
    lazy var dataArray: NSMutableArray = {
        let dict = NSDictionary(contentsOfFile: (Bundle.main.path(forResource: "fakeStatus", ofType: "plist"))!)
        let status = dict?["statuses"] as! NSArray
        var dataArray = NSMutableArray()
        for dic in status{
            let model = ZYStatus.model(dict: dic as! NSDictionary)
            dataArray.add(model)
        }
        return dataArray
    }()
    
    //控制器被销毁
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(titleMenuWillShow), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(titleMenuWillDismiss), object: nil)
    }
    
    func cellID(status:ZYStatus) ->String{
        return status.retweeted_status != nil ? forWardCell : nomalCell
    }
 
}


extension ZYHomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let status = dataArray[indexPath.row] as! ZYStatus
        let cell:ZYHomeStatusCell? = tableView.dequeueReusableCell(withIdentifier: cellID(status: status)) as! ZYHomeStatusCell?
        cell?.status = status
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let status = dataArray[indexPath.row] as! ZYStatus
        if let height = rowCache[status.idstr!] {
            return height
        }
        let cell:ZYHomeStatusCell = tableView.dequeueReusableCell(withIdentifier: cellID(status: status)) as! ZYHomeStatusCell
        let height = cell.rowHeight(status: status)
        rowCache[status.idstr!] = height
        return height
    }
}

