//
//  Albuum.swift
//  AlbumView
//
//  Created by Sai on 15/3/16.
//  Copyright (c) 2015年 OurSound. All rights reserved.
//

import UIKit
@IBDesignable
class AlbumView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AlbumViewDelegate{
    var indexPath: NSIndexPath!
    var collectionView:UICollectionView!
    let identifier = "Cell"
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        initLayout()
    }
    func initLayout() {
        if(collectionView != nil){ return }
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clearColor()//背景色为透明
        collectionView.pagingEnabled = true//每次滚一页
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerClass(AlbumViewCell.self, forCellWithReuseIdentifier: identifier)
        self.addSubview(collectionView)
        
        if(indexPath != nil){
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        }
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 20
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(self.frame.size.width, self.frame.size.height)
    }
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let row = indexPath.row
        var cell: AlbumViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as AlbumViewCell
        cell.setData()
        cell.delegate = self
        return cell
        
    }
    func onAlbumItemClick(){
        //点击cell回调
    }
}
class AlbumViewCell: UICollectionViewCell ,UIScrollViewDelegate{
    var vScrollView: UIScrollView!
    var startContentOffsetX :CGFloat!
    var startContentOffsetY :CGFloat!
    var vImage: UIImageView!
    var delegate: AlbumViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        vImage = UIImageView()
        vImage.frame.size = frame.size
        vImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        vScrollView = UIScrollView()
        vScrollView.frame.size = frame.size
        vScrollView.addSubview(vImage)
        
        vScrollView.delegate = self
        vScrollView.minimumZoomScale = 0.5
        vScrollView.maximumZoomScale = 2
        vScrollView.showsVerticalScrollIndicator = false
        vScrollView.showsHorizontalScrollIndicator = false
        //添加单击
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewTapped:")
        vScrollView.addGestureRecognizer(tapRecognizer)
        self.addSubview(vScrollView)
    }
    
    func setData() {
        vScrollView.zoomScale = 1
        vImage.image = UIImage(named:"IMG_1798")
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return vImage
    }
    //缩放触发
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()//缩小图片的时候把图片设置到scrollview中间
    }
    func centerScrollViewContents() {
        let boundsSize = vScrollView.bounds.size
        var contentsFrame = vImage.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        vImage.frame = contentsFrame
    }
    func scrollViewTapped(recognizer: UITapGestureRecognizer) {
        //单击回调
        if(delegate != nil){
            delegate.onAlbumItemClick()
        }
    }
    
}
protocol AlbumViewDelegate{
    func onAlbumItemClick()
}

