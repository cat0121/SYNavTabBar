//
//  SYNavTabBarController.swift
//  SYTabBarViewController
//
//  Created by ShuYan Feng on 2017/3/14.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // 
    // 存放控制器的数组
    var subViewControllers: [UIViewController]?
    // 当前所在控制器的索引
    var currentIndex: NSInteger?
//    {
//        willSet {
//            navTabBar.currentIndex = newValue!
//            if subViewControllers != nil {
//                let viewController = subViewControllers?[newValue!];
//                viewController?.view.frame = CGRect(x: CGFloat(newValue!) * kScreen_width, y: 0, width: kScreen_width, height: mainView.frame.size.height)
//                mainView.addSubview(viewController!.view)
//                self.addChildViewController(viewController!)
//                
//                mainView.setContentOffset(CGPoint(x: CGFloat(newValue!) * kScreen_width, y: 0), animated: false)
//                
//            }
//        }
//    }
    // 分页导航上的title数组
    var titles: [String]!
    // 热搜
    var hotSearchArray: [String]?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initControl()
        layoutPageSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        // 视图控制器索引和标题的设置(指定某一页)
        currentIndex = 1
    }

    
    // MARK: - private method
    // 初始化控件信息
    func initControl() {
        
        // 视图控制器索引和标题的设置
        currentIndex = 1
        navTabBar.currentIndex = currentIndex!
        
        // 初始化标题数组
        titles = ["推荐","热点","图集","视频","人物","现场","演出","旅游","赛事","会展","电影","话题"]
        
        var viewArray = [UIViewController]()
        for _ in 0..<titles.count {
            let society = SocietylViewController()
            viewArray.append(society)
        }
        
        subViewControllers = viewArray
        
        //添加视图控制器
        let viewController = subViewControllers?[0]
        viewController?.view.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height)
        
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
        // 设置控制器的尺寸
        mainView.contentSize = CGSize(width: kScreen_width*CGFloat(subViewControllers!.count), height: 0)
        
        
        // 将标题数组赋给分页导航的数组
        navTabBar.itemTitles = titles
        // 刷新数据
        navTabBar.updateData()
        
        view.addSubview(navTabBar)
        
    }
    
    private func layoutPageSubviews() {
        navTabBar.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.height.equalTo(42)
        }
    }
    
    // MARK: - setter and getter
    lazy var navTabBar: SYNavTabBar = {
        let navTabBar = SYNavTabBar(frame: .zero)
        navTabBar.delegate = self
        navTabBar.backgroundColor = UIColor.white
        navTabBar.navTabBarHeight = 42
        navTabBar.buttonTextColor = UIColor.black
        navTabBar.lineColor = UIColor.red
        return navTabBar
    }()
    // 下面的控制器
    lazy var mainView: UIScrollView = {
        let mainView = UIScrollView(frame: CGRect(x: 0, y: 44, width: kScreen_width, height: kScreen_height))
        mainView.delegate = self
        mainView.isPagingEnabled = true
        mainView.bounces = false
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        self.view.addSubview(mainView)
        return mainView
    }()
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        currentIndex = Int(scrollView.contentOffset.x) / Int(kScreen_width)
        navTabBar.currentIndex = currentIndex!
        
        /** 当scrollview滚动的时候加载当前视图 */
        let viewController = subViewControllers?[currentIndex!];
        viewController?.view.frame = CGRect(x: CGFloat(currentIndex!) * kScreen_width, y: 0, width: kScreen_width, height: mainView.frame.size.height)
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
    }
}
extension ViewController: SYNavTabBarDelegate {
    func itemDidSelected(index: NSInteger, currentIndex: NSInteger) {
        if currentIndex-index > 3 || currentIndex-index < -3 {
            mainView.contentOffset = CGPoint(x: CGFloat(index) * kScreen_width, y: 0)
        } else {
            mainView.setContentOffset(CGPoint(x: CGFloat(index) * kScreen_width, y: 0), animated: false)
        }
    }
}

