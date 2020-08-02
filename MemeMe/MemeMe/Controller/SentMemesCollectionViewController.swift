//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by Ali Bahadori on 01.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: Outlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: Meme Data Resource
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlowLayout(for: view.frame.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: Configure Rotation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupFlowLayout(for: size)
    }
  
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        cell.meme = memes[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsViewController
        detailsVC.meme = memes[indexPath.item]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}

extension SentMemesCollectionViewController{
    
    //MARK: Configure Flow Layout
    
    private func setupFlowLayout(for size: CGSize){
        let space:CGFloat = 3.0
        let dimension = (size.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}
