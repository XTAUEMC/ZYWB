//
//  ZYPhotoBrowserController.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/28.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

private let photoBrowserCell = "photoBrowserCell"

class ZYPhotoBrowserController: UIViewController {
    
    //当前图片下标
    var photoIndex:Int = 0
    //当前图片下标
    var photoUrls:[NSURL]?
    init(index:Int,urls:[NSURL]) {
        super.init(nibName: nil, bundle: nil)
        photoIndex = index
        photoUrls = urls
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //1.初始化UI
        setUpUI()

    }

    private func setUpUI(){
        //1.添加视图
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        //2.布局UI
        collectionView.frame = view.frame
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.register(ZYPhotoBrowserCell.classForCoder(), forCellWithReuseIdentifier: photoBrowserCell)
        closeBtn.frame = CGRect(x: pixw(float: 10), y: ScreenHeight - pixw(float: 45), width: pixw(float: 100), height: pixw(float: 35))
        saveBtn.frame = CGRect(x: ScreenWidth - pixw(float: 110), y: ScreenHeight - pixw(float: 45), width: pixw(float: 100), height: pixw(float: 35))
        
        collectionView.scrollToItem(at: IndexPath(item: photoIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: true)

    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        //获取当前cell的indexPath数组
        let indexPath = collectionView.indexPathsForVisibleItems
        //获取当前正在展示的cell
        let cell = collectionView.cellForItem(at: indexPath.last!) as! ZYPhotoBrowserCell
        //获取当前cell上的图片
        let image = cell.imageView.image
        //将图片保存到相册
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(ZYPhotoBrowserController.image(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    func image(image:UIImage,didFinishSavingWithError error:Error?,contextInfo:Any) {
        if error != nil {
            //有错误,保存失败
            SVProgressHUD.showError(withStatus: "保存失败")
        }else{
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }
    }
    
    //MARK: 懒加载
    lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.darkGray
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("关闭", for: UIControlState.normal)
        button.addTarget(self, action: #selector(ZYPhotoBrowserController.close), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var saveBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.darkGray
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("保存", for: UIControlState.normal)
        button.addTarget(self, action: #selector(ZYPhotoBrowserController.save), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: ZYPhotoBrowserFlowLayout())
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension ZYPhotoBrowserController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowserCell, for: indexPath) as! ZYPhotoBrowserCell
        cell.photoUrl = photoUrls?[indexPath.item]
        cell.clickAction = {
            self.close()
        }
        return cell
    }
    
}



class ZYPhotoBrowserFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        itemSize = CGSize(width: ScreenWidth, height: ScreenHeight)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
    }
    
}

