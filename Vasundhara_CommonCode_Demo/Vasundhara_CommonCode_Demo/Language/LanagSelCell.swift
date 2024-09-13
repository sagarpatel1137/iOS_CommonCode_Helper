//
//  LanagSelCell.swift
//  VoiceChanger
//
//  Created by IOS on 27/08/24.
//

import UIKit

class LanagSelCell: UITableViewCell {
    
    static let identifier = "LanagSelCell"
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocDetail: UILabel!
    @IBOutlet weak var viewSelected: Gradient!
    @IBOutlet weak var ic_tick: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMain.layer.cornerRadius = 8
    }
    
    func funSet(isSelected: Bool) {
         
        if isSelected {
            viewSelected.isHidden = false
            lblName.textColor = .white
            lblLocDetail.textColor = .white
            lblName.font = UIFont(name: WorkSans_SemiBold, size: UIDevice.current.isiPad == true ? 20.0 : 17.0)
            lblLocDetail.font = UIFont(name: WorkSans_Regular, size: UIDevice.current.isiPad == true ? 17.0 : 14.0)
        }
        else {
            viewSelected.isHidden = true
            lblName.textColor = hexStringToUIColor(hex: "181D33")
            lblLocDetail.textColor = hexStringToUIColor(hex: "9CA2B8")
            lblName.font = UIFont(name: WorkSans_SemiBold, size: UIDevice.current.isiPad == true ? 20.0 : 17.0)
            lblLocDetail.font = UIFont(name: WorkSans_Regular, size: UIDevice.current.isiPad == true ? 17.0 : 14.0)
        }
    }
}
