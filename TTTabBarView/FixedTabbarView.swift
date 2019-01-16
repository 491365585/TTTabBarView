//
//  MainTabbarView.swift
//  SwiftFrameSet
//
//  Created by mac on 2019/1/15.
//  Copyright © 2019年 tai. All rights reserved.
//

import Foundation
import UIKit


//MARK: - 自定义tabBarView
public class FixedTabbarView: UIView{
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewWidth = bounds.width / 3.0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = self.backColor
        tabbarShowView.delegate = self
        
        var tabbarWidth = CGFloat(0)
        for (index,title) in tabbarTitles.enumerated() {
            
            let tabbarBtn = TabbarButton(frame: CGRect(x: tabbarWidth, y: 0, width: viewWidth, height: self.bounds.height))
            addSubview(tabbarBtn)
            tabbarBtn.btnTitleLabel.text = title
            tabbarBtn.btnTitleLabel.textColor = titleColor
            
            tabbarWidth += tabbarBtn.bounds.width
            tabbarBtn.tag = index
            tabbarBtn.addTarget(self, action: #selector(changeVC(btn:)), for: .touchUpInside)
            
            tabbarBtnArr.append(tabbarBtn)
            btnFrameArr.append(tabbarBtn.frame)
            if index == firstIndex{
                changeVC(btn: tabbarBtn)
                
                getNowViewIsFirsh(index: firstIndex)
            }
            
        }
        addSubview(bottomView)
        bottomView.backgroundColor = rowColor
        bottomView.frame = CGRect(x: CGFloat(firstIndex) * viewWidth, y: self.frame.size.height - 2, width: viewWidth, height: 2)
        
    }
    
    public func setTitlesAndControllers(titles: Array<String>) {
        
        tabbarTitles = titles
        
        
        
        viewWidth = bounds.width / CGFloat(titles.count)
        scrollWidth = bounds.width * CGFloat(titles.count)
        bottomMaxWidth = bounds.width / CGFloat(titles.count) * CGFloat(titles.count)
        setupUI()
        
    }
    
    
    
    @objc private func changeVC(btn: TabbarButton) {//根据选中的模块去判断scroller需要滚动到哪里
        if nowIndex == btn.tag {
            ///重复点击已选中的标签页
            return
        }
        
        moveBtn(index: btn.tag)
    }
    
    
    
    
    
    
    private func getNowViewIsFirsh(index: Int) {
        let isFirst = tabbarBtnArr[index].isFirst
        if isFirst {
            moveViewIsFirst?(index)
            tabbarBtnArr[index].isFirst = false
        }
    }
    
    
    
    
    
    
    
    private var viewWidth: CGFloat = 0
    
    private var bottomMaxWidth = CGFloat(0.0)
    private var scrollWidth = CGFloat(0.0)
    private var tabbarTitles = Array<String>()
    private let bottomView = UIView()
    
    ///未选中标题颜色
    public var titleColor = UIColor.black
    ///行颜色
    public var rowColor = UIColor.black
    ///背景颜色
    public var backColor = UIColor.white
    ///选中后的颜色
    public var titleSelectColor = UIColor.black
    
    
    private var tabbarBtnArr = Array<TabbarButton>()
    
    private var btnFrameArr = Array<CGRect>()
    
    
    
    
    
    
    public var tabbarShowView = TabbarShowView()
    ///当前view移动之后
    public typealias MoveView = (_ lastIndex: Int,_ nowIndex: Int)->Void
    public var moveView: MoveView?
    ///首次显示该View
    public typealias MoveViewIsFirst = (_ firstIndex: Int)->Void
    public var moveViewIsFirst: MoveViewIsFirst?
    
    ///指定首次显示的页面
    public var firstIndex = 0
    ///当前index
    public var nowIndex = 0
    ///是否禁止滑动
    public var dontPan = false
    ///是否加粗
    public var isBig = true
    
    ///移动
    public func moveBtn(index: Int) {//根据选中的模块去判断scroller需要滚动到哪里
        if nowIndex == index {
            return
        }
        moveView?(nowIndex,index)
        getNowViewIsFirsh(index: index)
        
        nowIndex = index
        
        for btn in tabbarBtnArr {
            
            if isBig {///原先的按钮
                btn.isSelected = false
                btn.btnTitleLabel.textColor = titleColor
                btn.btnTitleLabel.font = UIFont(name: "Helvetica", size: 13)//取消加粗
            }
            
            if btn.tag == index {//当前的按钮
                
                tabbarShowView.setContentOffset(CGPoint(x: CGFloat(btn.tag) * bounds.width, y: 0), animated: true)
                btn.isSelected = true
                if isBig {
                    btn.btnTitleLabel.font = UIFont(name: "Helvetica-Bold", size: 16)//加粗
                }
                btn.btnTitleLabel.textColor = titleSelectColor
            }
            
        }
        
    }
    
    
    ///设置未选中时的文字颜色
    public func setTitleColor(color: UIColor){
        titleColor = color
        //        for btn in subviews {//遍历
        //            if btn is TabbarButton {
        for btn in tabbarBtnArr {
            btn.btnTitleLabel.textColor = color
        }
    }
    ///设置选中时的文字颜色
    public func setTitleSelectColor(color: UIColor){
        for btn in tabbarBtnArr {
            if btn.tag == nowIndex {
                btn.btnTitleLabel.font = UIFont(name: "Helvetica-Bold", size: 16)//加粗
                btn.btnTitleLabel.textColor = color
                titleSelectColor = color
                return
            }
        }
    }
    
    ///设置禁止拖动
    public func setNotScroll(type: Bool) {
        tabbarShowView.isScrollEnabled = type
    }
    ///设置行颜色
    public func setRowColor(color: UIColor){
        bottomView.backgroundColor = color
        rowColor = color
    }
    ///设置背景颜色
    public func setBackColor(color: UIColor){
        backgroundColor = color
        backColor = color
    }
    
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tabbarShowView {
            
            dontPan = true
            let value = scrollView.contentOffset
            
            
            ///根据移动距离去计算移动比例
            let bili = value.x  / scrollWidth
            
            let offset = bottomMaxWidth * bili
            
            
            
            
            
            var bottomFrame = bottomView.frame
            bottomFrame.origin.x = offset
            bottomView.frame = bottomFrame
            // 动画
            UIView.animate(withDuration: 0.1) { () -> Void in
                self.layoutIfNeeded()
            }
        }
    }
    
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tabbarShowView {
            
            let value = scrollView.contentOffset
            
            
            ///根据移动距离去计算移动比例
            let bili = value.x  / scrollWidth
            
            let offset = bottomMaxWidth * bili
            for (index,btnFrame) in btnFrameArr.enumerated() {
                let maxX = btnFrame.origin.x + btnFrame.width
                let minX = btnFrame.minX
                if Int(minX) <= Int(offset) && Int(offset) < Int(maxX){
                    ///作移动后处理
                    moveBtn(index: index)
                    break
                }
            }
            
        }
    }
    
    
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == tabbarShowView {
            
            dontPan = false
        }
    }
}

extension FixedTabbarView: UIScrollViewDelegate {
    
    
}


class TabbarButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        addSubview(btnTitleLabel)
        
        btnTitleLabel.font = UIFont.systemFont(ofSize: 13)
        btnTitleLabel.textAlignment = .center
        btnTitleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: self.frame.size.height - 2)
        
        
    }
    
    func isViewAlpha(alpha: CGFloat){
        
    }
    
    ///tabbar底下的高亮线条
    var btnTitleLabel = UILabel()
    var isFirst = true
    
    
    
    
}

public class TabbarShowView: UIScrollView {//主页面上的scroll，里面装每个不同的页面
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setViews(views: Array<UIView>){
        
        showViews = views
        for (index,view) in views.enumerated() {
            self.addSubview(view)
            view.frame = CGRect(x: CGFloat(index) * bounds.width, y: 0, width: bounds.width, height: bounds.height)
        }
        
        
        setupUI()
        
    }
    
    func setupUI(){
        //self.isScrollEnabled = false
        self.contentSize = CGSize(width: bounds.width*CGFloat(showViews.count), height: 0)
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
    }
    
    
    
    
    
    
    
    
    var showViews = Array<UIView>()
    var myWidth: CGFloat = 0
}
