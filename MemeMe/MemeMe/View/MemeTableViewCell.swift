//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Ali Bahadori on 01.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var customImageView: UIImageView!{
        didSet{
            customImageView.backgroundColor = .black
            customImageView.layer.borderColor = UIColor.systemGray5.cgColor
            customImageView.layer.borderWidth = 1.0
        }
    }
    
    //MARK: Meme Data Resource
    
    var meme: Meme?{
        didSet{
            if let meme = meme {
                customImageView.image = meme.memedImage
                topLabel.text = meme.topText
                bottomLabel.text = meme.bottomText
            }
        }
    }
    
}
