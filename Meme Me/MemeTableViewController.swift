//
//  MemeTableViewController.swift
//  Meme Me
//
//  Created by David Teo on 5/5/16.
//  Copyright © 2016 Compete Co-op Networks. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        //memes = applicationDelegate.memes
    }
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomMemeCell")!
        let meme = memes[indexPath.row]
        
        //cell.setText(meme.top, bottomString: meme.bottom)
        cell.imageView?.image = meme.image
        cell.textLabel?.text = meme.top
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottom
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! ViewController
        let meme = memes[indexPath.row]
        detailController.meme = meme
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}