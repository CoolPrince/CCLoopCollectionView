//
//  ViewController.swift
//  TestLoopCollectionView
//
//  Created by cuicc on 2018/3/5.
//  Copyright © 2018年 cuicc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var adView: CCLoopCollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        var tempAry = [String]()
        for i in 0..<5 {
            tempAry.append(Bundle.main.path(forResource: "\(i+1)", ofType: "jpeg")!)
        }
//        let tempAry = [#imageLiteral(resourceName: "1.jpeg"), #imageLiteral(resourceName: "2.jpeg"), #imageLiteral(resourceName: "3.jpeg"), #imageLiteral(resourceName: "4.jpeg"), #imageLiteral(resourceName: "5.jpeg")]
        
        //code
        //根据frame创建view
        let v = CCLoopCollectionView(frame: CGRect(x: 30, y: 60, width: 175, height: 100))
        //给轮播图赋值内容（可以为UIImage或UIString）
        v.contentAry = tempAry as [AnyObject]
        //是否开始自动循环
        v.enableAutoScroll = true
        //循环间隔时间
        v.timeInterval = 2.0
        //是否显示UIPageControl
        v.showPageControl = false
        //UIPageControl当前颜色
        v.currentPageControlColor = UIColor.brown
        //UIPageControl其它颜色
        v.pageControlTintColor = UIColor.cyan
        //添加到父视图
        view.addSubview(v)
        
        
        //storyboard
        adView.contentAry = tempAry as [AnyObject]
        adView.isHidden = true
        adView.enableAutoScroll = true
        adView.timeInterval = 2.0
        adView.currentPageControlColor = UIColor.red
        adView.pageControlTintColor = UIColor.black
        adView.getClickedIndex { (index) in
            print("clicked index = \(index)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

