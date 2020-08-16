//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Aditya Rana on 16.08.20.
//  Copyright © 2020 Aditaya Rana. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
     override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        self.imageView!.image = meme.memedImage // IMAGE LOADED
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false 
    }


}
