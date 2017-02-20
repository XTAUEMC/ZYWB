//
//  ZYQRCodeViewController.swift
//  ZYWB
//
//  Created by zhangyi on 16/12/1.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

import UIKit
import AVFoundation

class ZYQRCodeViewController: UIViewController  {
    
    @IBOutlet weak var tabBar: UITabBar!
    //容器视图
    var containerView :UIView?
    //边框
    var scanBorder :UIImageView?
    //扫码
    var scanLine :UIImageView?
    
    //MARK: 懒加载
    //1.会话
    lazy var session : AVCaptureSession = AVCaptureSession()
    //2.拿到输入设备
    lazy var deviceInput: AVCaptureDeviceInput? = {
        //获取摄像头
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch{
            print(error)
            return nil
        }
    }()
    
    //3.拿到输出对象
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    //预览图层
    lazy var preView: AVCaptureVideoPreviewLayer = {
        let preView = AVCaptureVideoPreviewLayer(session: self.session)
        preView?.frame = UIScreen.main.bounds
        return preView!
    }()
    

    @IBAction func closeClick() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.orange;
        tabBar.selectedItem = tabBar.items!.first
        tabBar.delegate = self
        //添加扫码视图
        setUpScanView();

        

    }
    
    private func setUpScanView(){
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: pixw(float: 280), height: pixw(float: 280)))
        containerView?.center = view.center
        view.addSubview(containerView!)
        
        scanBorder = UIImageView(frame: (containerView?.bounds)!)
        scanBorder?.image = UIImage(named: "qrcode_border")
        containerView?.addSubview(scanBorder!)
        
        scanLine = UIImageView(frame: (containerView?.bounds)!)
        scanLine?.image = UIImage(named: "qrcode_scanline_barcode")
        containerView?.addSubview(scanLine!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
        //开始扫描
//        startScan()
    }
    
    private func startScan(){
        //1.判断是否能够将输入添加到会话中
        if !session.canAddInput(deviceInput) {
            return
        }
        //2.判断是否能够将输出添加到会话中
        if !session.canAddOutput(output) {
            return
        }
        //3.将输入和输出都添加到会话
        session.addInput(deviceInput)
        session.addOutput(output)
        //4.设置输出能够解析的数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        //5.设置输出对象的代理,只要解析成功就会通知代理
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //6.添加预览图层
        view.layer.insertSublayer(preView, at: 0)
        //7.告诉会话开始扫描
        session.startRunning()
    }
    
    func startAnimation(){
        scanLine?.frame.origin.y = -(containerView?.frame.height)!
        scanLine?.layoutIfNeeded()
        UIView.animate(withDuration: 2.0, delay: 0.0, options: UIViewAnimationOptions.repeat, animations: {
            self.scanLine?.frame.origin.y = (self.containerView?.frame.height)!
            self.scanLine?.layoutIfNeeded()
        }, completion: nil)
    }
   
}


//MARK: 代理
extension ZYQRCodeViewController: UITabBarDelegate,AVCaptureMetadataOutputObjectsDelegate{
    
    //MARK: UITabBarDelegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            containerView?.height = pixw(float: 150)
        }else{
            containerView?.height = pixw(float: 280)
        }
        containerView?.center = view.center
        scanBorder?.frame = (containerView?.bounds)!
        scanLine?.frame = (containerView?.bounds)!
        startAnimation()
    }
    
    //MARK: AVCaptureMetadataOutputObjectsDelegate
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){
        let last = metadataObjects.last as! AVMetadataMachineReadableCodeObject
        if last.stringValue.characters.count > 0 {
            print(last.stringValue)
            session.stopRunning()
        }
        
    }
    
    
    
}
