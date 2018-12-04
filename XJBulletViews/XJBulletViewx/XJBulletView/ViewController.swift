//
//  ViewController.swift
//  XJBulletView
//
//  Created by xiejingbo on 2018/12/4.
//  Copyright © 2018年 xiejingbo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var viewmanger: XJBulletManger = XJBulletManger()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewmanger.moveView = {
            [weak self] (bulletview) -> () in
            self?.addBulletView(bulletview: bulletview)
        }
        
        let button = UIButton(type: .custom)
        button.setTitle("start", for: [])
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.yellow, for: [])
        view.addSubview(button)
        button.frame = CGRect(x: 80, y: 80, width: 30, height: 30)
        button.addTarget(self, action: #selector(start), for: .touchUpInside)
        
    }
    @objc func start() {
        self.viewmanger.start()
    }

  
    func addBulletView(bulletview : XJbulletView) {
        let screenWidth = UIScreen.main.bounds.size.width
        bulletview.frame = CGRect(x: screenWidth + Padding, y: CGFloat(bulletview.trajectory) * 50.0 + 200.0, width: bulletview.bounds.size.width, height: bulletview.bounds.size.height)
        self.view.addSubview(bulletview)
        bulletview.startAnimation()
        
    }
}

