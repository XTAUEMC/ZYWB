//
//  ZYPictureView.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

let ZYPictureViewSelected = "ZYPictureViewSelected"
let ZYPictureViewSelectedIndex = "ZYPictureViewSelectedIndex"
let ZYPictureViewSelectedUrls = "ZYPictureViewSelectedUrls"

class ZYPictureView: UICollectionView {
    //status
    var status :ZYStatus?{
        didSet{
            self.size = calculateCollectionViewSize()
            self.reloadData()
        }
    }
    
    private var flowLayout = UICollectionViewFlowLayout()
    
    init() {
        super.init(frame: CGRect(), collectionViewLayout: flowLayout)
        
        backgroundColor = UIColor.clear
        register(ZYPicCell.classForCoder(), forCellWithReuseIdentifier: picCell)
        flowLayout.minimumLineSpacing = pixw(float: 8)
        flowLayout.minimumInteritemSpacing = pixw(float: 8)
        delegate = self
        dataSource = self
    }
    
    
    func calculateCollectionViewSize() ->CGSize{
        let picArray = status?.picUrls
        let count = picArray?.count
        let itemWidth = pixw(float: 90)
        let margin = pixw(float: 8)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        if count == 0 {
            flowLayout.itemSize = CGSize()
            return CGSize()
        }else if count == 4 {
            return CGSize(width: itemWidth*2 + margin, height: itemWidth*2 + margin)
        }else{
            var width:CGFloat = 0.0
            var height:CGFloat = 0.0
            let row = Int((count!+2)/3)
            if count! <= 3 {
                width = itemWidth * CGFloat(count!) + margin * CGFloat(count! - 1)
            }else{
                width = itemWidth * 3 + margin * 2
            }
            height = CGFloat(row) * itemWidth + CGFloat(row - 1) * margin
            return CGSize(width: width, height: height)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

extension ZYPictureView:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.picUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ZYPicCell = collectionView.dequeueReusableCell(withReuseIdentifier: picCell, for: indexPath) as! ZYPicCell
        let picUrl = status?.picUrls?[indexPath.row]
        cell.picUrl = picUrl as! NSURL?
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userInfo = [ZYPictureViewSelectedIndex:indexPath,ZYPictureViewSelectedUrls:status!.largeUrls!] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(ZYPictureViewSelected), object: self, userInfo: userInfo)
    }
}

class ZYPicCell: UICollectionViewCell {
    //图片链接
    var picUrl :NSURL?{
        didSet{
            if let url = picUrl {
                self.imageView.sd_setImage(with: url as URL, placeholderImage: UIImage(named: ""))
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.imageView)
        self.imageView.frame = self.bounds
//        self.imageView.contentMode = UIViewContentMode.scaleAspectFill
//        self.imageView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView = UIImageView()
    
    
}
