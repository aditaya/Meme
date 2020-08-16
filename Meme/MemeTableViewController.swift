//
//  MemeTableViewController.swift
//  Meme
//
//  Created by Aditya Rana on 16.08.20.
//  Copyright © 2020 Aditaya Rana. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    @IBOutlet var memeTableView: UITableView!
    @IBOutlet var memeImageView: UIImageView!
    @IBOutlet var memeLabelView: UILabel!
    
    
    //   MEME Images Array Fetched from App Delegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memeTableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        
        return cell
    }
    
    // MARK: - Segue to MemeDetailViewController
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}

