//
//  XJBulletManger.swift
//  XJBulletView
//
//  Created by xiejingbo on 2018/12/4.
//  Copyright © 2018年 xiejingbo. All rights reserved.
//

import UIKit

class XJBulletManger {
    
    var moveView: ((XJbulletView) -> ())?
    //这里以后可以回放入一个model类。结合z实际情况 不行就any
    private lazy var datasource: [String] = {
        var arr = [String]()
       arr.append("123")
        arr.append("1723749024023")
        arr.append("4234534")
        arr.append("634927932203284028302")
        arr.append("shfahshfkabskdhfkahksks")
        arr.append("09")
        arr.append("sdfsfsdfsds")
        arr.append("999999")
        return arr
    }()
    
    //存储弹幕的每个反悔的字段的数组
    private lazy var bulletStrArr: [String] = {
        let bullteArr = [String]()
        return bullteArr
    }()
    //弹幕的viewa数组
    private lazy var bullteViewArr: [XJbulletView] = {
        let viewArr = [XJbulletView]()
        return viewArr
    }()
    
    
    private var animationStop: Bool = true
    
    private func initStr()  {
        var trajecArr = [1,2,3] //弹道数组 你可以多设计几个 这个不用用全局的数组 这个数组用完 在这个方法作用域就被系统收回了 不占用多余内存
        let count = trajecArr.count
        
        //这里如果弹幕的条数少于弹道的话需要做一个判断
        for _ in 0 ..< count {
            
            let index = Int(arc4random()) % trajecArr.count
            print(index)
            let tracjec = trajecArr[index]
            trajecArr.remove(at: index)
            
            let str = self.bulletStrArr.first! //数组是否大于弹道数
            self.bulletStrArr.remove(at: 0)
            self.creatBulletView(bulletStr: str, trajectory: tracjec)
      
        }
        
    }
   private func creatBulletView(bulletStr: String, trajectory: Int) {
        guard animationStop != true else {
            return
        }
        print(11111)
        let view = XJbulletView(bulltestr: bulletStr)
        view.trajectory = trajectory
        self.bullteViewArr.append(view)
        weak var bulletview = view
    
        view.moveStatusBlock = {
             [weak self](status) -> () in
            guard self?.animationStop != true else {
                return
            }
            switch status {
            case XJBulletMoveStatus.start:
                
                self?.bullteViewArr.append(bulletview!)
                break
            case XJBulletMoveStatus.enter:
                
                let nextStr = self?.nextBulletStr()
                guard nextStr != nil else {
                    return
                }
                print(66666666666)
                self?.creatBulletView(bulletStr: nextStr!, trajectory: trajectory)
                
                break
                
            case XJBulletMoveStatus.leave:
                print(77777)
                if (self?.bullteViewArr.contains(bulletview!))! {
                    bulletview?.stopAnimation()
                    self?.bullteViewArr = self?.bullteViewArr.filter{ (views) -> Bool in
                        return views != bulletview
                        } ?? [XJbulletView]()
    
                }
                break
            }
            
        }
    guard self.moveView != nil else {
        return
    }
    self.moveView!(view)
        
    }
    
    func start() {
        guard animationStop != false else {
            return
        }
        animationStop = false
        self.bulletStrArr.removeAll()
        self.bulletStrArr.append(contentsOf: self.datasource)
        self.initStr()
    }
    
    func stop() {
        guard animationStop != true else {
            return
        }
        animationStop = true
        guard self.bullteViewArr.count != 0 else {
            return
        }
        for view in self.bullteViewArr {
            view.stopAnimation()
        }
        self.bullteViewArr.removeAll()
    }
    
    private func nextBulletStr() -> String? {
        if self.bulletStrArr.count == 0 {
            return nil
        }
        let bullet = self.bulletStrArr.first
        self.bulletStrArr.remove(at: 0)
        return bullet
        
    }
    
    //用于请求数据 可以根据传递的参数 在这里完成数据请求
    func getData(userId: String,page: Int, pageNo: Int) {
         //post
    }
}
