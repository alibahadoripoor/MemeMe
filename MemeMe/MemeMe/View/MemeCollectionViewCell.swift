//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Ali Bahadori on 01.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.backgroundColor = .black
            imageView.layer.borderColor = UIColor.systemGray5.cgColor
            imageView.layer.borderWidth = 1.0
        }
    }
    
    //MARK: Meme Data Resource
    
    var meme: Meme?{
        didSet{
            if let meme = meme {
                imageView.image = meme.memedImage
            }
        }
    }
    
}
