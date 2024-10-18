//
//  SubRatingCell.swift
//  GPS Map Camera
//
//  Created by iOS on 06/08/24.
//

import UIKit

//MARK: Cusmization
public struct UICustomizationSubRatingData {
    // View1
    var view1ImageRating: UIImage? = UIImage(named: "")
    var view1TitleLabel: String? = ""
    var view1SubTitleLabel: String? = ""
    // View2
    var view2ImagePlaceholder: UIImage? = UIImage(named: "")
    var ratingCountLabel: String? = ""
    var satisfiedCustLabel: String? = ""
    // View3
    var lblTitle: String? = ""
    var lblDetail: String? = ""
    var lblName: String? = ""
}

class SubRatingCell: UICollectionViewCell {
    
    //MARK: - IBOutlet(s).
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    //View 1
    @IBOutlet weak var view1ImageRating: UIImageView!
    @IBOutlet weak var viewRating1: UIView!
    @IBOutlet weak var view1TitleLabel: UILabel!
    @IBOutlet weak var view1SubTitleLabel: UILabel!
    
    //View 2
    @IBOutlet weak var view2ImagePlaceholder: UIImageView!
    @IBOutlet weak var viewRating2: UIView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var satisfiedCustLabel: UILabel!
    @IBOutlet weak var ratingCountView: UIView!
    
    //View 3
    @IBOutlet weak var viewRating3: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    static let identifier = "SubRatingCell"
    
    public var customizationSubRatingData = UICustomizationSubRatingData()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        updateUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        setupCorners()
    }
    
    private func setupCorners() {
        let cornerRadiusPercentage: CGFloat = 0.3
        let cornerRadius = ratingCountView.bounds.height * cornerRadiusPercentage
        ratingCountView.layer.cornerRadius = cornerRadius
        ratingCountView.layer.masksToBounds = true
        
        mainContentView.layer.shadowColor = hexStringToUIColor(hex: "7D8FB2").cgColor
        mainContentView.layer.shadowOpacity = 0.2
        mainContentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainContentView.layer.shadowRadius = 3
        mainContentView.layer.masksToBounds = false
        
        mainContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        mainContentView.layer.cornerRadius = mainContentView.bounds.height * 0.15
        mainStackView.layer.masksToBounds = true
        mainStackView.layer.cornerRadius = mainContentView.bounds.height * 0.15
    }
    
    private func setupUI() {
        view1TitleLabel.text = "Best AI Voice Changer App".localized()
        view1SubTitleLabel.text = "Creative, entertaining, and perfect for fun voice transformations.".localized()
        ratingCountLabel.text = "1,00,000"
        satisfiedCustLabel.text = "Satisfied Customer".localized()
        
        lblTitle.font = setCustomFont(name: .PlusJakartaSans_ExtraBold, iPhoneSize: 12, iPadSize: 19)
        lblDetail.font = setCustomFont(name: .PlusJakartaSans_Regular, iPhoneSize: 10, iPadSize: 16)
        lblName.font = setCustomFont(name: .PlusJakartaSans_Medium, iPhoneSize: 11, iPadSize: 16)
        
        view1TitleLabel.font = setCustomFont(name: .PlusJakartaSans_ExtraBold, iPhoneSize: 12, iPadSize: 19)
        view1SubTitleLabel.font = setCustomFont(name: .PlusJakartaSans_Regular, iPhoneSize: 11, iPadSize: 15)
        ratingCountLabel.font = setCustomFont(name: .PlusJakartaSans_ExtraBold, iPhoneSize: 18, iPadSize: 25)
        satisfiedCustLabel.font = setCustomFont(name: .PlusJakartaSans_Bold, iPhoneSize: 14, iPadSize: 19)
        
    }

}

//MARK: -
extension SubRatingCell {
    private func updateUI() {
        if let view1ImageRating = customizationSubRatingData.view1ImageRating {
            self.view1ImageRating.image = view1ImageRating
        }
        if let view1TitleLabel = customizationSubRatingData.view1TitleLabel {
            self.view1TitleLabel.text = view1TitleLabel
        }
        if let view1SubTitleLabel = customizationSubRatingData.view1SubTitleLabel {
            self.view1SubTitleLabel.text = view1SubTitleLabel
        }
        
        if let view2ImagePlaceholder = customizationSubRatingData.view2ImagePlaceholder {
            self.view2ImagePlaceholder.image = view2ImagePlaceholder
        }
        if let ratingCountLabel = customizationSubRatingData.ratingCountLabel {
            self.ratingCountLabel.text = ratingCountLabel
        }
        if let satisfiedCustLabel = customizationSubRatingData.satisfiedCustLabel {
            self.satisfiedCustLabel.text = satisfiedCustLabel
        }
        
        if let lblTitle = customizationSubRatingData.lblTitle {
            self.lblTitle.text = lblTitle
        }
        if let lblDetail = customizationSubRatingData.lblDetail {
            self.lblDetail.text = lblDetail
        }
        if let lblName = customizationSubRatingData.lblName {
            self.lblName.text = lblName
        }
    }
}
