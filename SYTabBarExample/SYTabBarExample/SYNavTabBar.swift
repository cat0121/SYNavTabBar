//
//  SYNavTabBar.swift
//  SYTabBarViewController
//
//  Created by ShuYan Feng on 2017/3/14.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

let kScreen_width = UIScreen.main.bounds.size.width
let kScreen_height = UIScreen.main.bounds.size.height

protocol SYNavTabBarDelegate: NSObjectProtocol {
    func itemDidSelected(index: NSInteger, currentIndex:NSInteger)
}

class SYNavTabBar: UIView {
    
    // 下划线
    var line: UIView?
    // 下划线的颜色
    var lineColor: UIColor?
    // 每一个模块的title
    var itemTitles: [String]?
    // 每一个模块的字体属性
    var attributes: [String: Any]?
    // 每一个模块的宽
    var itemWidth: [CGFloat]?
    // 按钮之间的间距
    var itemSpace = 15
    // 存放每一个模块
    var items: [UIButton]!
    // navTabBar的高度
    var navTabBarHeight: CGFloat = 42
    // button的字体颜色
    var buttonTextColor: UIColor = UIColor.black
    
    // 定义一个代理
    weak var delegate: SYNavTabBarDelegate?
    
    //MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.viewConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - event response
    /**
     * 点击button
     */
    func itemPressed(button: UIButton, currentIndex: NSInteger) {
        let index = items.index(of: button)
        delegate?.itemDidSelected(index: index!, currentIndex: self.currentIndex)
    }
    
    //MARK: - private method
    func viewConfig() {
        attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        self.addSubview(navigationTabBar)
    }
    
    /**
     * 获取button的宽
     */
    func getButtonWidth(titles: [String]) -> [CGFloat] {
        
        var array = [CGFloat]()
        for title in titles {
            let textMaxSize = CGSize(width: kScreen_width, height: CGFloat(MAXFLOAT))
            let textRealSize = title.boundingRect(with: textMaxSize, options: NSStringDrawingOptions(rawValue: 0), attributes: attributes, context: nil)
            array.append(CGFloat(textRealSize.width))
            
        }
        return array
    }
    
    /**
     *  下划线
     */
    func showLine(buttonWidth: CGFloat) {
        if line == nil {
            line = UIView(frame: CGRect(x: 15, y: 40, width: Int(buttonWidth), height: 2))
            line?.backgroundColor = lineColor
            navigationTabBar.addSubview(self.line!)
        }
        
        let button = items[currentIndex]
        button.setTitleColor(UIColor.red, for: .normal)
        self.itemPressed(button: button, currentIndex: currentIndex)
    }
    
    /**
     *  获取当前的button的宽度
     */
    func contentWidth(widths: [CGFloat]) -> CGFloat {
        var buttonX: CGFloat = 0;
        items = [UIButton]()
        for index in 0..<itemTitles!.count {
            let button = UIButton(type: .custom)
            button.setTitle(itemTitles![index], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            let textMaxSize = CGSize(width: kScreen_width, height: CGFloat(MAXFLOAT))
            var textRealSize = itemTitles![index].boundingRect(with: textMaxSize, options: NSStringDrawingOptions(rawValue: 0), attributes: attributes, context: nil).size
            textRealSize = CGSize(width: Int(textRealSize.width) + itemSpace*2, height: Int(navTabBarHeight))
            button.frame = CGRect(x: buttonX, y: 0, width: textRealSize.width, height: navTabBarHeight)
            button.setTitleColor(buttonTextColor, for: .normal)
            button.addTarget(self, action: #selector(itemPressed(button:currentIndex:)), for: .touchUpInside)
            navigationTabBar.addSubview(button)
            items.append(button)
            
            //改变button的宽
            buttonX = buttonX + button.frame.size.width
        }
        
        self.showLine(buttonWidth: widths[currentIndex])
        return buttonX
    }
    
    /**
     * 更新数据
     */
    func updateData() {
        itemWidth = self.getButtonWidth(titles: itemTitles!)
        if itemWidth!.count > 0 {
            let contentWidth = self.contentWidth(widths: itemWidth!)
            navigationTabBar.contentSize = CGSize(width: contentWidth, height: navTabBarHeight)
        }
    }
    
    //MARK: - setter and getter
    var _navigationTabBar: UIScrollView!
    var navigationTabBar: UIScrollView {
        if _navigationTabBar == nil {
            _navigationTabBar = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: navTabBarHeight))
            _navigationTabBar.backgroundColor = UIColor.clear
            _navigationTabBar.showsVerticalScrollIndicator = false
            _navigationTabBar.showsHorizontalScrollIndicator = false
        }
        return _navigationTabBar
    }
    //记录当前的位置
    var _currentIndex: NSInteger!
    var currentIndex: NSInteger {
        get {
            return _currentIndex
        }
        set {
            _currentIndex = newValue
            if items != nil {
                let button = items[_currentIndex]
                if button.frame.origin.x + button.frame.size.width + 50 >= kScreen_width {
                    var offsetX = button.frame.origin.x + button.frame.size.width - kScreen_width
                    if _currentIndex < itemTitles!.count - 1 {
                        offsetX = offsetX + button.frame.size.width
                    }
                    navigationTabBar.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
                    
                } else {
                    navigationTabBar.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
                for i in 0..<items.count {
                    if i == newValue {
                        items[i].setTitleColor(UIColor.red, for: .normal)
                    } else {
                        items[i].setTitleColor(UIColor.black, for: .normal)
                    }
                    
                }
                //下划线的偏移量
                UIView.animate(withDuration: 0.1) {
                    self.line?.frame = CGRect(x: button.frame.origin.x + CGFloat(self.itemSpace), y: self.line!.frame.origin.y, width: self.itemWidth![self._currentIndex], height: self.line!.frame.size.height)
                }
            }
        }
    }
    
}


