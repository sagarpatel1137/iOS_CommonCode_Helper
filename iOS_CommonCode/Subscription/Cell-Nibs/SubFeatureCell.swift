//
//  SubFeatureCell.swift
//  Voice GPS
//
//  Created by IOS on 23/08/24.
//

import UIKit
import MarqueeLabel

public class SubFeatureCell: UICollectionViewCell {

    static let identifier = "SubFeatureCell"
    
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblName: MarqueeLabel!
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
