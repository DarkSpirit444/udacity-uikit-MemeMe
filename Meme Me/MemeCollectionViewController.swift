//
//  MemeCollectionViewController.swift
//  Meme Me
//
//  Created by David Teo on 5/5/16.
//  Copyright © 2016 Compete Co-op Networks. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    //var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        //memes = applicationDelegate.memes
        
        //TODO: Implement flowLayout here.
        let space: CGFloat = 3.0
        
        //var dimension: CGFloat
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionHeight = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimensionWidth, dimensionHeight)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! CustomMemeCell
        let meme = memes[indexPath.item]
        
        cell.setText(meme.top, bottomString: meme.bottom)
        let imageView = UIImageView(image: meme.image)
        cell.backgroundView = imageView
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! ViewController
        let meme = memes[indexPath.row]
        detailController.meme = meme
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}
