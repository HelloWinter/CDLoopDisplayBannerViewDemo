//
//  ViewController.swift
//  CDLoopDisplayBannerViewDemo
//
//  Created by cd on 2017/10/27.
//  Copyright © 2017年 cd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var bannerView : CDLoopDisplayBannerView = {
        let view = CDLoopDisplayBannerView()
        view.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 200)
        view.imageViewEdgeInsets=UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.imageLinks=["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1509795200172&di=54892a949e67d414d2a9503ff9412492&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fa1ec08fa513d26970b89ebb45ffbb2fb4216d885.jpg","https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3503317788,3980318350&fm=27&gp=0.jpg","https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1821827134,1825389224&fm=27&gp=0.jpg","https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1250325353,3805256155&fm=27&gp=0.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1509427531099&di=bf010022464a9cdedfba2edbe0e01ec3&imgtype=0&src=http%3A%2F%2Fa3.topitme.com%2F6%2F43%2Fe0%2F119420257091ce0436o.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1509427619350&di=1766339daa061ea9979367689401e34b&imgtype=jpg&src=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D844255205%2C1431848195%26fm%3D214%26gp%3D0.jpg","http://a.hiphotos.baidu.com/zhidao/pic/item/8b13632762d0f703198503e70afa513d2697c5d2.jpg","http://b.hiphotos.baidu.com/image/pic/item/4034970a304e251ffc87952aad86c9177e3e53eb.jpg"]
        view.autoScroll=true
        view.startScroll()
//        view.pageControlHidden=true
        view.imageClickClousure = { (index : Int) -> Void in
                print(index)
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.bannerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

