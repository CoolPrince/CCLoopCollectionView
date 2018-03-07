//
//  LoopCollectionView.swift
//  TestLoopCollectionView
//
//  Created by cuicc on 2018/3/5.
//  Copyright © 2018年 cuicc. All rights reserved.
//

import UIKit
import SDWebImage

public typealias SelectItemBlock = (Int) -> Void

public class CCLoopCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var mCollectionView: UICollectionView!
    private var loopPageControl: UIPageControl!
    
    private var currentFrame: CGRect!
    private var currentIndex = 1
    private var scrollTimer: Timer!
    
    /// 内容数组，可以是图片、本地路径或者网络路径
    public var contentAry = [AnyObject]() {
        didSet {
            if contentAry.count > 1 {
                contentAry.insert(contentAry.last!, at: 0)
                contentAry.append(contentAry[1])
            }
            if mCollectionView != nil {
                loopPageControl.frame = CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y+currentFrame.size.height-37.0, width: currentFrame.size.width, height: 37.0)
                loopPageControl.numberOfPages = contentAry.count > 1 ? (contentAry.count - 2) : 1
                
                mCollectionView.reloadData()
                mCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    /// 是否开始自动循环
    public var enableAutoScroll = false {
        didSet {
            if  mCollectionView != nil && enableAutoScroll == true {
                configAutoScroll()
            }
        }
    }
    /// 循环间隔时间
    public var timeInterval = 1.0 {
        didSet {
            if mCollectionView != nil && enableAutoScroll == true {
                configAutoScroll()
            }
        }
    }
    /// 是否显示UIPageControl，默认显示
    public var showPageControl = true {
        didSet {
            if loopPageControl != nil && showPageControl == false {
                loopPageControl.isHidden = true
            }
        }
    }
    /// UIPageControl当前颜色
    public var currentPageControlColor: UIColor? {
        didSet {
            if mCollectionView != nil {
                loopPageControl.currentPageIndicatorTintColor = currentPageControlColor
            }
        }
    }
    /// UIPageControl其它颜色
    public var pageControlTintColor: UIColor? {
        didSet {
            if mCollectionView != nil {
                loopPageControl.pageIndicatorTintColor = pageControlTintColor
            }
        }
    }
    var currentBlock: SelectItemBlock?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        currentFrame = frame
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func didMoveToSuperview() {
        if currentFrame == nil {
            currentFrame = frame
        }
        initAllViews(frame: currentFrame)
    }
    func initAllViews(frame: CGRect) {
        // 图片循环UICollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        mCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        mCollectionView.register(LoopCollectionViewCell.self, forCellWithReuseIdentifier: "LoopCollectionViewCellIdentifier")
        //
        mCollectionView.backgroundColor = UIColor.white
        mCollectionView.isPagingEnabled = true
        mCollectionView.showsHorizontalScrollIndicator = false
        self.superview?.addSubview(mCollectionView)
        if mCollectionView.numberOfItems(inSection: 0) > 0 {
            mCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        //loopPageControl
        if showPageControl {
            loopPageControl = UIPageControl(frame: CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y+currentFrame.size.height-37.0, width: currentFrame.size.width, height: 37.0))
            loopPageControl.numberOfPages = contentAry.count > 1 ? (contentAry.count - 2) : 1
            loopPageControl.currentPageIndicatorTintColor = currentPageControlColor
            loopPageControl.pageIndicatorTintColor = pageControlTintColor
            self.superview?.addSubview(loopPageControl)
        }
        
        
        // 是否开启自动循环
        if enableAutoScroll == true {
            configAutoScroll()
        }
    }
    
    
    
    //MARK: -  UICollectionView
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentAry.count
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: currentFrame.size.width, height: currentFrame.size.height)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoopCollectionViewCellIdentifier", for: indexPath) as? LoopCollectionViewCell
        if cell == nil {
            cell = LoopCollectionViewCell()
        }
        
        let content = contentAry[indexPath.item]
        if let realContent = content as? UIImage {
            cell?.contentImageView?.image = realContent
        }
        else if let realContent = content as? String, realContent.hasPrefix("http") {
            cell?.contentImageView?.sd_setImage(with: URL(string: realContent), placeholderImage: nil)
        }
        else if let realContent = content as? String, !realContent.hasPrefix("http") {
            cell?.contentImageView?.sd_setImage(with: URL(fileURLWithPath: realContent), placeholderImage: nil)
        }
        
        return cell!
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentBlock != nil {
            let index = (indexPath.item - 1) >= 0 ? (indexPath.item - 1) : 0
            currentBlock!(index)
        }
    }
    
    
    
    //MARK: -  UIScrollViewDelegate
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = true
        
        let index = Int(scrollView.contentOffset.x / currentFrame.size.width)
        currentIndex = index
        if index == contentAry.count-1 {
            mCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            currentIndex = 1
        }
        
        if index == 0 && contentAry.count > 1 {
            mCollectionView.scrollToItem(at: IndexPath(item: contentAry.count-2, section: 0), at: .centeredHorizontally, animated: false)
            currentIndex = contentAry.count-2
        }
        
        
        //更新loopPageControl
        loopPageControl?.currentPage = currentIndex-1
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = true
        
        let index = Int(scrollView.contentOffset.x / currentFrame.size.width)
        if index == contentAry.count-1 {
            mCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            currentIndex = 1
        }
        
        if index == 0 && contentAry.count > 1 {
            mCollectionView.scrollToItem(at: IndexPath(item: contentAry.count-2, section: 0), at: .centeredHorizontally, animated: false)
            currentIndex = contentAry.count-2
        }
        
        
        //更新loopPageControl
        loopPageControl?.currentPage = currentIndex-1
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = false
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    
    
    
    //MARK: -  Custom
    
    func configAutoScroll() {
        //设置定时器
        if scrollTimer != nil {
            scrollTimer.invalidate()
            scrollTimer = nil
        }
        scrollTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(autoScrollAction(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func autoScrollAction(timer: Timer) {
        if self.window != nil {
            currentIndex += 1
            if currentIndex >= contentAry.count {
                currentIndex = currentIndex % contentAry.count
            }
            mCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    
    /// 获取当前点击的item的index
    ///
    /// - Parameter index: index
    public func getClickedIndex(index: @escaping SelectItemBlock) {
        currentBlock = index
    }
}





class LoopCollectionViewCell: UICollectionViewCell {
    var contentImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentImageView = UIImageView(frame: CGRect(x: 0, y: frame.origin.y, width: frame.size.width, height: frame.size.height))
        self.addSubview(contentImageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
