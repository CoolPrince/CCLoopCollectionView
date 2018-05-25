# CCLoopCollectionView
Loop UICollectionView(include UIPageControl) for swift.


一、安装方法：

pod 'CCLoopCollectionView'


二、使用方法：

1.纯代码：

let v = CCLoopCollectionView(frame: CGRect(x: 30, y: 60, width: 175, height: 100))   //根据frame创建view

v.contentAry = tempAry as [AnyObject]   //给轮播图赋值内容（可以为UIImage或UIString）

v.enableAutoScroll = true   //是否开始自动循环

v.timeInterval = 2.0   //循环间隔时间

v.imageShowMode = .scaleToFill   //默认模式

v.showPageControl = false   //是否显示UIPageControl，默认显示

v.currentPageControlColor = UIColor.brown   //UIPageControl当前颜色

v.pageControlTintColor = UIColor.cyan   //UIPageControl其它颜色

v.getClickedIndex { (index) in   //获取当前点击的item的index

    print("1--- = \(index)")
    
}

view.addSubview(v)   //添加到父视图




2.storyboard：

①拖拽一个UIView到VC上，将其class改为CCLoopCollectionView，并赋值IBOutlet，命名为v。

②在对应的swift文件中添加如下代码：


v.contentAry = tempAry as [AnyObject]   //给轮播图赋值内容（可以为UIImage或UIString）

v.enableAutoScroll = true   //是否开始自动循环

v.timeInterval = 2.0   //循环间隔时间

v.imageShowMode = .scaleToFill   //默认模式

v.currentPageControlColor = UIColor.red   //UIPageControl当前颜色

v.pageControlTintColor = UIColor.black   //UIPageControl其它颜色

v.getClickedIndex { (index) in   //获取当前点击的item的index

    print("2--- = \(index)")
    
}

