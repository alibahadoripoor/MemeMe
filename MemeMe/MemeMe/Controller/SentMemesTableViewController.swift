//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Ali Bahadori on 01.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeTableViewCell"

class SentMemesTableViewController: UITableViewController {

    //MARK: Meme Data Resource
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    //MARK: View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MemeTableViewCell
        cell.meme = memes[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsViewController
        detailsVC.meme = memes[indexPath.item]
        navigationController?.pushViewController(detailsVC, animated: true)
    }

}
