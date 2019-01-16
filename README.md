# TTTabBarView

swift版tabbar标签栏。测试封装框架用


首次尝试封装框架成功!!!!!!!!!!!!!!!!!!!!!!!

![Gif]
(https://github.com/491365585/TTTabBarView/blob/master/TTTabBarView/tttabbar.gif)

版本
1.0.5 - 初始版本

使用pod以集成到项目中
```swift
///当前最新版本1.0.5
pod TTTabBarView 
```




```swift
    ///标签控制器
        let tabbarView = FixedTabbarView()
    ///标签页
        let tabbarShowView = TabbarShowView()
    
    ///添加并设置其frame
        view.addSubview(tabbarView)
        view.addSubview(tabbarShowView)
        
        tabbarView.tabbarShowView = tabbarShowView
        tabbarView.firstIndex = 2
        tabbarView.rowColor = UIColor.red
        tabbarView.titleSelectColor = UIColor.red
        tabbarView.frame = CGRect(x: 0, y:  navHeight, width: screenWidth, height: 35)
        tabbarShowView.frame = CGRect(x: 0, y: 35 + navHeight, width: screenWidth, height: screenHeight - 35 - navHeight)
        

        tabbarView.moveViewIsFirst = {[unowned self] index in
             print("(\(index))--->first load")
        }
        
        ///把初始化数据放到前面，最后再调用填充数据的方法
        tabbarShowView.setViews(views: [UIView(),UITableView()])
        tabbarView.setTitlesAndControllers(titles: ["第一页","第二页"])
```
