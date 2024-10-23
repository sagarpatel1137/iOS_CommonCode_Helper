//
//  SubRatingCell.swift
//  GPS Map Camera
//
//  Created by iOS on 06/08/24.
//

import UIKit

//MARK: Cusmization
public struct UICustomizationSubRatingData {
    public var view1ImageRating: UIImage
    public var view1TitleLabel: String
    public var view1SubTitleLabel: String
    public var view2ImagePlaceholder: UIImage
    public var ratingCountLabel: String
    public var satisfiedCustLabel: String
    
    public init(view1ImageRating: UIImage, view1TitleLabel: String, view1SubTitleLabel: String, view2ImagePlaceholder: UIImage, ratingCountLabel: String, satisfiedCustLabel: String) {
        self.view1ImageRating = view1ImageRating
        self.view1TitleLabel = view1TitleLabel
        self.view1SubTitleLabel = view1SubTitleLabel
        self.view2ImagePlaceholder = view2ImagePlaceholder
        self.ratingCountLabel = ratingCountLabel
        self.satisfiedCustLabel = satisfiedCustLabel
    }
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
    
    public var customizationSubRatingData: UICustomizationSubRatingData? {
        didSet {
            updateUI()
        }
    }
    
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
        func configureFont(for label: UILabel, fontName: FontApp, iPhoneSize: CGFloat, iPadSize: CGFloat) {
            label.font = setCustomFont(name: fontName, iPhoneSize: iPhoneSize, iPadSize: iPadSize)
        }
        
        // Setting fonts for the labels
        configureFont(for: lblTitle, fontName: .PlusJakartaSans_SemiBold, iPhoneSize: 16, iPadSize: 20)
        configureFont(for: lblDetail, fontName: .PlusJakartaSans_Medium, iPhoneSize: 14, iPadSize: 15)
        configureFont(for: lblName, fontName: .PlusJakartaSans_Medium, iPhoneSize: 15, iPadSize: 16)
        
        // Using ResizeText_Rating once and reusing the calculated values
        let titleSize = ResizeText_Rating(iphone: 13, iPad: 19)
        let subTitleSize = ResizeText_Rating(iphone: 11, iPad: 17)
        let ratingSize = ResizeText_Rating(iphone: 18, iPad: 25)
        let custLabelSize = ResizeText_Rating(iphone: 14, iPad: 19)
        
        configureFont(for: view1TitleLabel, fontName: .PlusJakartaSans_Bold, iPhoneSize: titleSize, iPadSize: titleSize)
        configureFont(for: view1SubTitleLabel, fontName: .PlusJakartaSans_Medium, iPhoneSize: subTitleSize, iPadSize: subTitleSize)
        configureFont(for: ratingCountLabel, fontName: .PlusJakartaSans_ExtraBold, iPhoneSize: ratingSize, iPadSize: ratingSize)
        configureFont(for: satisfiedCustLabel, fontName: .PlusJakartaSans_Bold, iPhoneSize: custLabelSize, iPadSize: custLabelSize)
    }
}

//MARK: -
extension SubRatingCell {
    private func updateUI() {
        if let view1ImageRating = customizationSubRatingData?.view1ImageRating {
            self.view1ImageRating.image = view1ImageRating
        }
        if let view1TitleLabel = customizationSubRatingData?.view1TitleLabel {
            self.view1TitleLabel.text = view1TitleLabel
        }
        if let view1SubTitleLabel = customizationSubRatingData?.view1SubTitleLabel {
            self.view1SubTitleLabel.text = view1SubTitleLabel
        }
        if let view2ImagePlaceholder = customizationSubRatingData?.view2ImagePlaceholder {
            self.view2ImagePlaceholder.image = view2ImagePlaceholder
        }
        if let ratingCountLabel = customizationSubRatingData?.ratingCountLabel {
            self.ratingCountLabel.text = ratingCountLabel
        }
        if let satisfiedCustLabel = customizationSubRatingData?.satisfiedCustLabel {
            self.satisfiedCustLabel.text = satisfiedCustLabel
        }
    }
}
