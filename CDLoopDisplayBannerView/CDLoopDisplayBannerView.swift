//
//  CDLoopDisplayBannerView.swift
//  CDLoopDisplayBannerViewDemo
//
//  Created by cd on 2017/10/27.
//  Copyright © 2017年 cd. All rights reserved.
//

import UIKit
import Kingfisher

private let kFrontImageTag = 300
private let kMiddleImageTag = 400
private let kBehindImageTag = 500

class CDLoopDisplayBannerView: UIView, UIScrollViewDelegate {
    var imageLinks : [String] = [String]() {
        didSet{
            if self.imageLinks.count != 0 {
                self.pageControl.numberOfPages = self.imageLinks.count
                self.pageControl.currentPage = 0
                self.scrollView.isScrollEnabled = self.imageLinks.count == 1 ? false : true
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
    var currentImageView : UIImageView? {
        get {
            return self.imgViewsCachePool[self.pageControl.currentPage]
        }
    }
    var imageViewEdgeInsets = UIEdgeInsets.zero
    
    private var tempPage = 0
    private var timer : Timer?
    private lazy var scrollView : UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.isPagingEnabled = true
        scrollV.delegate = self
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
        invalidateTimer()
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
        let imageViewTopMagin = self.imageViewEdgeInsets.top
        let imageViewLeftMagin = self.imageViewEdgeInsets.left
        let imageViewBottomMagin = self.imageViewEdgeInsets.bottom
        let imageViewRightMagin = self.imageViewEdgeInsets.right
        
        self.scrollView.frame=self.bounds
        
        let imgWidth = self.scrollView.frame.size.width
        let imgHeight = self.scrollView.frame.size.height
        
        let currentimgWidth = self.scrollView.frame.size.width - imageViewLeftMagin - imageViewRightMagin
        let currentimgHeight = self.scrollView.frame.size.height - imageViewTopMagin - imageViewBottomMagin
        
        let size = self.pageControl.size(forNumberOfPages: (self.imageLinks.count))
        self.pageControl.frame=CGRect(x: 10 + imageViewLeftMagin, y: self.frame.size.height-size.height, width: size.width, height: size.height)
        
        let firstSlideImage = self.scrollView.viewWithTag(kFrontImageTag)
        firstSlideImage?.frame = CGRect(x: imageViewLeftMagin, y: imageViewTopMagin, width: currentimgWidth, height: currentimgHeight)
        
        for i in 0..<self.imageLinks.count {
            let scrollImg = self.scrollView.viewWithTag(kMiddleImageTag+i)
            scrollImg?.frame=CGRect(x: imgWidth * CGFloat(i+1) + imageViewLeftMagin, y: imageViewTopMagin, width: currentimgWidth, height: currentimgHeight)
        }
        
        let lastSlideImage = self.scrollView.viewWithTag(kBehindImageTag)
        lastSlideImage?.frame=CGRect(x: CGFloat(imageLinks.count + 1) * imgWidth + imageViewLeftMagin, y: imageViewTopMagin, width: currentimgWidth, height: currentimgHeight)
        
        self.scrollView.contentSize=CGSize(width: imgWidth * CGFloat(imageLinks.count + 2), height: imgHeight)
        
        self.scrollView.scrollRectToVisible(CGRect(x: imgWidth, y: 0, width: imgWidth, height: imgHeight), animated: false)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        var page = Int(floorf(Float((scrollView.contentOffset.x - pageWidth/CGFloat(imageLinks.count+2)) / pageWidth))) + 1
        page -= 1
        self.pageControl.currentPage = page;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let pageHeight = scrollView.frame.size.height
        let currentPage = Int(floorf(Float((scrollView.contentOffset.x - pageWidth/CGFloat(imageLinks.count+2)) / pageWidth))) + 1
        
        if currentPage == 0 {
            scrollView.scrollRectToVisible(CGRect(x: pageWidth * CGFloat(imageLinks.count), y: 0, width: pageWidth, height: pageHeight), animated: false)
        }else if currentPage == imageLinks.count + 1 {
            scrollView.scrollRectToVisible(CGRect(x: pageWidth, y: 0, width: pageWidth, height: pageHeight), animated: false)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let pageHeight = scrollView.frame.size.height
        if tempPage == 0 {
            scrollView.scrollRectToVisible(CGRect(x: pageWidth * CGFloat(imageLinks.count), y: 0, width: pageWidth, height: pageHeight), animated: false)
        }else if tempPage == imageLinks.count {
            scrollView.scrollRectToVisible(CGRect(x: pageWidth, y: 0, width: pageWidth, height: pageHeight), animated: false)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startScroll()
    }
    
    // MARK: - public
    func startScroll() -> Void {
        if self.autoScroll {
            startTimer()
        }
    }
    
    // MARK: - private
    private func startTimer() -> Void {
        invalidateTimer()
        timer=Timer(timeInterval: autoScrollTimeInterval, target: self, selector: Selector(("scrollToNextPage")), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
    }
    
    private func invalidateTimer() -> Void {
        timer?.invalidate()
        timer=nil
    }
    
    private func scrollToNextPage() -> Void {
        var page = pageControl.currentPage
        page += 1
        tempPage = page
        scrollView.scrollRectToVisible(CGRect(x: scrollView.frame.size.width * CGFloat(page + 1), y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height), animated: true)
    }
    
    @objc private func imageClick(_ recognizer : UITapGestureRecognizer){
        if let clickClousure = imageClickClousure {
            clickClousure((recognizer.view?.tag)!-kMiddleImageTag)
        }
    }
    
    private func layoutScrollViewSubviews(){
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        for i in 0..<imageLinks.count + 2 {
            var scrollImg : UIImageView? = nil
            if imgViewsCachePool.count < i {
                scrollImg = imgViewsCachePool[i]
            }
            if scrollImg != nil {
                scrollImg!.image=nil
                for recognizer in scrollImg!.gestureRecognizers! {
                    if recognizer.isKind(of: UITapGestureRecognizer.self) {
                        scrollImg?.removeGestureRecognizer(recognizer)
                    }
                }
            }else{
                scrollImg = UIImageView()
                scrollImg!.isUserInteractionEnabled=true
                imgViewsCachePool.append(scrollImg!)
            }
            if i == imageLinks.count {
                scrollImg!.tag = kFrontImageTag
                let url = URL(string: imageLinks[imageLinks.count-1])
                scrollImg!.kf.setImage(with:url)
            }else if i == imageLinks.count+1 {
                scrollImg!.tag = kBehindImageTag
                let url = URL(string: imageLinks[0])
                scrollImg!.kf.setImage(with:url)
            }else{
                scrollImg!.tag = kMiddleImageTag + i
                let url = URL(string: imageLinks[i])
                scrollImg!.kf.setImage(with:url)
            }
            let tap = UITapGestureRecognizer(target: self, action: Selector(("imageClick")))
            scrollImg!.addGestureRecognizer(tap)
            scrollView.addSubview(scrollImg!)
        }
        self.setNeedsLayout()
    }
    
}
