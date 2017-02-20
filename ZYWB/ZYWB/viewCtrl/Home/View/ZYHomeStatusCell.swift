//
//  ZYHomeStatusCell.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit

let picCell = "picCell"

class ZYHomeStatusCell: UITableViewCell {
    
    //微博模型
    var status :ZYStatus?{
        didSet{
            if let url = status?.user?.imageUrl {
                userImage.sd_setImage(with: url as URL, placeholderImage: UIImage(named: "avatar_default"))
            }
            verifiedImage.image = status?.user?.verifiedImage
            nickName.text = status?.user?.name
            rankImage.image = status?.user?.rankImage
            creatTime.text = status?.created_at
            source.text = status?.source
            contentText.attributedText = status?.attributedText
            contentText.specials = (status?.specials) != nil ? (status?.specials)! : NSMutableArray()
            picView.status = status?.retweeted_status != nil ? status?.retweeted_status : status
            footer.status = status
            layoutSubviews()
        }
    }
    
    func rowHeight(status:ZYStatus) -> CGFloat {
        self.status = status
        layoutIfNeeded()
        return fullView.maxY + pixw(float: 10)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.none
        //初始化UI
        setUpView()
    }
    
    func setUpView() {
        //1.添加视图
        contentView.backgroundColor = UIColor.color(hex: "e6e6e6")
        fullView.backgroundColor = UIColor.white
        contentView.addSubview(fullView)
        fullView.addSubview(userImage)
        fullView.addSubview(verifiedImage)
        fullView.addSubview(nickName)
        fullView.addSubview(rankImage)
        fullView.addSubview(creatTime)
        fullView.addSubview(source)
        fullView.addSubview(contentText)
        fullView.addSubview(picView)
        fullView.addSubview(footer)
        //2.布局视图
        userImage.frame = CGRect(x: pixw(float: 10), y: pixw(float: 10), width: pixw(float: 50), height: pixw(float: 50))
        verifiedImage.frame = CGRect(x: userImage.maxX - pixw(float: 8), y: userImage.maxY - pixw(float: 8), width: pixw(float: 15), height: pixw(float: 15))
        nickName.x = userImage.maxX + pixw(float: 10)
        creatTime.x = nickName.x
        contentText.origin = CGPoint(x: userImage.x, y: userImage.maxY + pixw(float: 10))
        fullView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 0)
        picView.x = contentText.x
        footer.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: pixw(float: 35))
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nickName.sizeToFit()
        rankImage.sizeToFit()
        creatTime.sizeToFit()
        source.sizeToFit()
        contentText.sizeToFit()
        contentText.width = ScreenWidth - pixw(float: 20)
        nickName.y = userImage.y + pixw(float: 5)
        rankImage.x = nickName.maxX + pixw(float: 5)
        rankImage.centerY = nickName.centerY
        creatTime.y = nickName.maxY + pixw(float: 5)
        source.x = creatTime.maxX + pixw(float: 5)
        source.centerY = creatTime.centerY
        let margin:CGFloat = picView.height == 0 ? 0 : pixw(float: 10)
        picView.y = contentText.maxY + margin
        footer.y = picView.maxY + pixw(float: 10)
        fullView.height = footer.maxY
    }
    
    
    //MARK: 懒加载
    
    private lazy var userImage = UIImageView(image: UIImage(named: "avatar_default"))
    private lazy var verifiedImage = UIImageView(image: UIImage(named: "avatar_vip"))
    private lazy var nickName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.color(hex: "f46200")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private lazy var rankImage = UIImageView()
    private lazy var creatTime: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private lazy var source: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var contentText: ZYClickLabel = {
        let label = ZYClickLabel()
        label.textColor = UIColor.darkGray
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 15)
        label.clickSpecialAction = {
            (special)->Void in
            let specialText = special as ZYSpecialText
            SVProgressHUD.showSuccess(withStatus: specialText.text)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                SVProgressHUD.dismiss()
            })
        }
        return label
    }()
    
    lazy var fullView = UIView()
    
    lazy var picView = ZYPictureView()
    
    lazy var footer:ZYStatusFooter = ZYStatusFooter()
        
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}









