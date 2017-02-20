//
//  ZYEmojiListView.swift
//  ZYWB
//
//  Created by zhangyi on 17/1/6.
//  Copyright © 2017年 zhangyi. All rights reserved.
//

import UIKit

private let emojiCellIdentifier = "emojiCellIdentifier"
//点击表情通知
let selectedEmojiNotifation = "SelectedEmojiNotifation"
let selectedEmojiKey = "selectedEmojiKey"



class ZYEmojiListView: UIView {
    
    //package
    var package :ZYPackage?{
        didSet{
            collectionView.reloadData()
            let count = Int((package?.emoticons?.count)!/21)
            pageControl.numberOfPages = count == 1 ? 0 : count
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    private func setUpUI() {
        backgroundColor = UIColor.white
        addSubview(collectionView)
        addSubview(pageControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds.insetBy(dx: pixw(float: 20), dy: 0)
        collectionView.y = pixw(float: 15)
        collectionView.height = (collectionView.width/7)*3
        pageControl.y = collectionView.maxY + pixw(float: 10)
        pageControl.width = self.width
    }
    
    //添加表情到最近
    func addEmoticonToRecent(emoticon:ZYEmoticon){
        if emoticon.id?.characters.count == 0 {
            return
        }
        if emoticon.isRemove == true {
            return
        }
        let contain = package?.emoticons?.contains(emoticon)
        if contain == true {
            return
        }
        package?.emoticons?.insert(emoticon, at: 0)
        package?.emoticons?.removeLast()
        package?.emoticons?.removeLast()
        package?.emoticons?.append(ZYEmoticon(isRemove: true))
        collectionView.reloadData()
        //将最近表情写入沙盒
        ZYEmojiTool.writeRecentEmoticons(emoticons: (package?.emoticons)!)
        
    }
    
    //MARK: 懒加载
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: ZYEmojiCollectionLayout()) as UICollectionView
        collection.backgroundColor = UIColor.white
        collection.dataSource = self
        collection.delegate = self
        collection.register(ZYEmojiCollectionCell.classForCoder(), forCellWithReuseIdentifier: emojiCellIdentifier)
        return collection
    }()
    
    lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_normal")!)
        page.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_selected")!)
        return page
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ZYEmojiListView: UICollectionViewDataSource,UICollectionViewDelegate {
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return package?.emoticons?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emojiCellIdentifier, for: indexPath) as! ZYEmojiCollectionCell
        let emoticon = package?.emoticons?[indexPath.item]
        cell.emoticon = emoticon
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = package?.emoticons?[indexPath.item]
        NotificationCenter.default.post(name: NSNotification.Name(selectedEmojiNotifation), object: self, userInfo: [selectedEmojiKey:emoticon!])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offX = scrollView.contentOffset.x
        let current = offX/scrollView.width
        pageControl.currentPage = Int(current)
    }
    
    
}


class ZYEmojiCollectionLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        let width = (collectionView?.width)!/7
        itemSize = CGSize(width: width, height: width)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
    }
}


class ZYEmojiCollectionCell:UICollectionViewCell {
    
    //emoticon
    var emoticon :ZYEmoticon?{
        didSet{
            if emoticon?.chs != nil {
                iconButton.setImage(UIImage(named:(emoticon?.imagePath)!), for: UIControlState.normal)
            }else{
                iconButton.setImage(UIImage(named:""), for: UIControlState.normal)
            }
            iconButton.setTitle(emoticon?.emoji ?? "", for: UIControlState.normal)
            if emoticon?.isRemove == true {
                iconButton.setImage(UIImage(named:"compose_emotion_delete"), for: UIControlState.normal)
                iconButton.setImage(UIImage(named:"compose_emotion_delete_highlighted"), for: UIControlState.highlighted)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    private func setUpUI() {
        contentView.addSubview(iconButton)
        iconButton.frame = contentView.bounds.insetBy(dx: 4, dy: 4)
        iconButton.isUserInteractionEnabled = false
    }
    
    //MARK: 懒加载
    lazy var iconButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


