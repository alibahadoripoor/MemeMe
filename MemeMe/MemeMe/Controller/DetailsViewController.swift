//
//  DetailsViewController.swift
//  MemeMe
//
//  Created by Ali Bahadori on 02.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!

    //MARK: Meme Data Resource
    
    var meme: Meme!
    
    //MARK: View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        if let meme = meme {
            imageView.image = meme.memedImage
        }
    }
}

