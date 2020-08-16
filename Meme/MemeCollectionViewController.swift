//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by Aditya Rana on 16.08.20.
//  Copyright © 2020 Aditaya Rana. All rights reserved.
//

import UIKit


class MemeCollectionViewController: UICollectionViewController {
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    @IBOutlet var memeCollectionView: UICollectionView!
    
    //   MEME Images Array Fetched from App Delegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Dimensions of flow layout defined
        let space:CGFloat = 1.0
        let dimensionW = (view.frame.size.width) / 3.0
        let dimensionH = (view.frame.size.height) / 7.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionW, height: dimensionH)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        memeCollectionView.reloadData()
        //        Collection view reloaded
        
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.memeImage1View.image = meme.memedImage
        
        return cell
        
    }
    
    // MARK: - Segue to MemeDetailViewController
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    
}

// MARK: - Class for Collection Cell
class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImage1View: UIImageView!
    
}
