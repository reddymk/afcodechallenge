//
//  CollectionViewCell.swift
//  AFCodeTest
//
//  Created by Manish Reddy on 10/30/16.
//  Copyright © 2016 Manish. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topDescription: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var promoMessage: UILabel!
    @IBOutlet weak var bottomDescription: UITextView!
    var button: UIButton = UIButton()
}
