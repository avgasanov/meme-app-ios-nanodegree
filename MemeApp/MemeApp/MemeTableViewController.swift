//
//  MemeTableViewController.swift
//  MemeApp
//
//  Created by Abdulla Hasanov on 11/15/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import UIKit

class MemeTableViewController : UITableViewController {
 
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addPlusAction()
        tableView.reloadData()
    }
    
    
    @objc override func saveCompleted() {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath)
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("pressed at \(indexPath.item)")
        if let memes = memes {
            let image = memes[indexPath.item].memedImage
            pushDetailController(image)
        }
    }
}
