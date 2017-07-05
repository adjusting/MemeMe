//
//  SentMemesDetailViewController.swift
//  MemeMe
//
//  Created by Justin Gareau on 7/4/17.
//  Copyright © 2017 Justin Gareau. All rights reserved.
//

import UIKit

class SentMemesDetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true

        self.imageView!.image = meme.memedImage
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

}
