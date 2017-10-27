//
//  CDLoopDisplayBannerView.swift
//  CDLoopDisplayBannerViewDemo
//
//  Created by cd on 2017/10/27.
//  Copyright © 2017年 cd. All rights reserved.
//

import UIKit

private let kFrontImageTag = 300
private let kMiddleImageTag = 400
private let kBehindImageTag = 500

class CDLoopDisplayBannerView: UIView {
    var imageLinks : [String]? {
        didSet{
            if self.imageLinks != nil && self.imageLinks!.count != 0 {
                self.pageControl.numberOfPages = self.imageLinks!.count
                self.pageControl.currentPage = 0
                self.scrollView.isScrollEnabled = self.imageLinks!.count == 1 ? false : true
                ///////////////////////////////////
            }
        }
    }
    var autoScrollTimeInterval : TimeInterval = 4.0
    var placeHolderImage = "cd_banner_placeholder"
    var autoScroll = false
    var imageClickClousure : ((_ : Int)->Void)?
    var pageControlHidden = true {
        didSet{
            self.pageControl.isHidden = pageControlHidden
        }
    }
    var pageCtrlSelectColor : UIColor?
    var pageCtrlNormalColor : UIColor?
    private(set) var currentImageView : UIImageView?
    var imageViewEdgeInsets : UIEdgeInsets?
    
    private var tempPage = 0
    private var timer : Timer?
    private lazy var scrollView : UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.isPagingEnabled = true
        scrollV.delegate = self as? UIScrollViewDelegate
        scrollV.showsHorizontalScrollIndicator=false
        scrollV.showsVerticalScrollIndicator=false
        return scrollV
    }()
    private lazy var pageControl : UIPageControl = {
        let pageCtrl = UIPageControl()
        pageCtrl.isHidden = self.pageControlHidden
        pageCtrl.hidesForSinglePage=true
        if let selectColor = self.pageCtrlSelectColor {
            pageCtrl.currentPageIndicatorTintColor = selectColor
        }
        if let normalColor = self.pageCtrlNormalColor {
            pageCtrl.pageIndicatorTintColor = normalColor
        }
        return pageCtrl
    }()
    private lazy var imgViewsCachePool : [UIImageView] = {
        return [UIImageView]()
    }()
    
    deinit {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.scrollView)
        self.addSubview(self.pageControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func startScroll() -> Void {
        
    }
    
    
}
