//
//  XJbulletView.swift
//  XJBulletView
//
//  Created by xiejingbo on 2018/12/4.
//  Copyright © 2018年 xiejingbo. All rights reserved.
//

import UIKit
let Padding : CGFloat = 10
let PhotoHeight : CGFloat = 30

enum XJBulletMoveStatus {
    case start
    case enter
    case leave
}
//每一个弹幕view
class XJbulletView: UIView {
 
    var trajectory : Int = 0 //弹道
    var moveStatusBlock : ((XJBulletMoveStatus)->())?// 会掉的状态
    
    //显示的文字
    private lazy var bullteLable: UILabel = {
        let nameLable = UILabel()
        nameLable.font = UIFont.systemFont(ofSize: 14)
        nameLable.textColor = UIColor.white
        nameLable.textAlignment = .center
        return nameLable
    }()
    private lazy var bullteIcon: UIImageView = {
       let icon = UIImageView()
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        icon.backgroundColor = UIColor.white
        icon.layer.cornerRadius = (PhotoHeight + Padding) / 2
        icon.layer.borderWidth = 1.0
        return icon
    }()//显示的头像（加特效的一种）
    
    init(bulltestr: String) {
        super.init(frame: CGRect.zero)
        getUI(bulltestr : bulltestr)
    }
    
    func getUI(bulltestr : String) {
        self.backgroundColor = UIColor.red
        let font = UIFont.systemFont(ofSize: 14)
        let dic = [NSAttributedString.Key.font : font]
        let nameStr  = NSString(string: bulltestr)
        let strWidth = nameStr.size(withAttributes: dic)
        
        self.addSubview(self.bullteLable)
        self.bounds = CGRect(x: 0, y: 0, width: strWidth.width + Padding * 2 + PhotoHeight, height: PhotoHeight)
        self.bullteLable.text = bulltestr
        self.bullteLable.frame = CGRect(x: Padding + PhotoHeight, y: 0, width: strWidth.width, height: PhotoHeight)
        
        self.addSubview(self.bullteIcon)
        self.bullteIcon.frame = CGRect(x: -Padding, y: -Padding, width: PhotoHeight + Padding, height: PhotoHeight + Padding)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation(){
        guard self.moveStatusBlock != nil else {
            return
        }
        self.moveStatusBlock!(XJBulletMoveStatus.start)
        let width = UIScreen.main.bounds.size.width
        let bulletWidth = self.bounds.size.width
        let duration : CGFloat = (bulletWidth / (width / 4.0))  * 3.0;
        let speed = (bulletWidth + width) / duration
        let enterDuration = bulletWidth / speed
        
        self.perform(#selector(enterAnmation), with: nil, afterDelay: TimeInterval(enterDuration))
        var frame = self.frame
        frame.origin.x = width + Padding
        self.frame = frame
        UIView.animateKeyframes(withDuration: TimeInterval(duration), delay: 0.0, options: .calculationModeLinear, animations: {
            frame.origin.x = -bulletWidth
            self.frame = frame
        }) { (go) in
             self.moveStatusBlock!(XJBulletMoveStatus.leave)
        }
        
    }
    
    func stopAnimation() {
        RunLoop.cancelPreviousPerformRequests(withTarget: self, selector: #selector(enterAnmation), object: nil)
        self.layer.removeAllAnimations()
        self.removeFromSuperview()
    }
    
    @objc private func enterAnmation(){
        
        
        self.moveStatusBlock!(XJBulletMoveStatus.enter)
    }

}
