//
//  MemeDetail.swift
//  MemeApp
//
//  Created by Abdulla Hasanov on 11/17/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import UIKit

class MemeDetail : UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    
    var memeImagePre: UIImage?
    
    override func viewDidLoad() {
        memeImage.image = memeImagePre
    }
}
