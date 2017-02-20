//
//  ZYPhotoBrowserCell.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/29.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit


protocol ZYPhotoBrowserCellDelegate:NSObjectProtocol {
    func clickPhoto()
}


class ZYPhotoBrowserCell: UICollectionViewCell {
    
    
    var clickAction:(()->Void)?
    //图片url
    var photoUrl :NSURL?{
        didSet{
            initScrollView()
            imageView.sd_setImage(with: photoUrl as! URL) { (image, error, _, _) in
                let size = self.photoSize(image: self.imageView.image!)
                var photoY = (ScreenHeight - size.height) * 0.5
                if photoY <= 0 {
                    photoY = 0
                }
                self.scrollView.contentInset = UIEdgeInsets(top: photoY, left: 0, bottom: photoY, right: 0)
                self.imageView.frame = CGRect(origin: CGPoint(), size: size)
                if size.height >= ScreenHeight {
                    self.scrollView.contentSize = size
                }else{
                    self.scrollView.contentSize = CGSize(width: ScreenWidth, height: ScreenHeight)
                }
            }
        }
    }
    
    //还原scrollView
    private func initScrollView() {
        scrollView.contentSize = CGSize()
        scrollView.contentInset = UIEdgeInsets()
        scrollView.contentOffset = CGPoint()
        imageView.transform = CGAffineTransform.identity
    }
    
    private func photoSize(image:UIImage)->CGSize{
        let width = ScreenWidth
        //获取图片宽高比
        let scale = image.size.height / image.size.width
        let height = width * scale
        return CGSize(width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //初始化UI
        setUpView()
    }
    
    private func setUpView() {
        //1.添加子视图
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        //2.布局子控件
        scrollView.frame = UIScreen.main.bounds
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ZYPhotoBrowserCell.closeBrowser))
        imageView.addGestureRecognizer(tap)
    }
    
    func closeBrowser() {
        if clickAction != nil {
            clickAction!()
        }
    }
    
    
    //MARK: 懒加载
    lazy var imageView:UIImageView = UIImageView()
    lazy var scrollView:UIScrollView = UIScrollView()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZYPhotoBrowserCell : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        var offX = (ScreenWidth - (view?.frame.width)!) * 0.5
        var offY = (ScreenHeight - (view?.frame.height)!) * 0.5
        offX = offX <= 0 ? 0 : offX
        offY = offY <= 0 ? 0 : offY
        scrollView.contentInset = UIEdgeInsets(top: offY, left: offX, bottom: offY, right: offX)
    }
}
