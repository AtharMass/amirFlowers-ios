//
//  CollectionViewCell.swift
//  AmirFlowers@2019
//
//  Created by Athar Mass on 16/06/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var trash: UIButton!
    @IBOutlet weak var removeFrom: UIButton!
}
