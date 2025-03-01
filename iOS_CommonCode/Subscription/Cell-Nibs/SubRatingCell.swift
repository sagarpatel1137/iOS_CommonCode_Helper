//
//  SubRatingCell.swift
//  GPS Map Camera
//
//  Created by iOS on 06/08/24.
//

import UIKit

//MARK: Cusmization
public struct UICustomizationSubRatingData {
    public var view1ImageRating: UIImage?
    public var view1TitleLabel: String?
    public var view1SubTitleLabel: String?
    public var view2ImagePlaceholder: UIImage?
    public var ratingCountLabel: String?
    public var satisfiedCustLabel: String?
    
    public init(view1ImageRating: UIImage? = nil, view1TitleLabel: String? = nil, view1SubTitleLabel: String? = nil, view2ImagePlaceholder: UIImage? = nil, ratingCountLabel: String? = nil, satisfiedCustLabel: String? = nil) {
        self.view1ImageRating = view1ImageRating
        self.view1TitleLabel = view1TitleLabel
        self.view1SubTitleLabel = view1SubTitleLabel
        self.view2ImagePlaceholder = view2ImagePlaceholder
        self.ratingCountLabel = ratingCountLabel
        self.satisfiedCustLabel = satisfiedCustLabel
    }
}

public class SubRatingCell: UICollectionViewCell {
    
    //MARK: - IBOutlet(s).
    @IBOutlet public weak var imgQuate: UIImageView!
    @IBOutlet public weak var imgQuate3: UIImageView!
    @IBOutlet public weak var imgLikeSub: UIImageView!
    @IBOutlet public weak var mainContentView: UIView!
    @IBOutlet public weak var mainStackView: UIStackView!
    
    //View 1
    @IBOutlet public weak var view1ImageRating: UIImageView!
    @IBOutlet public weak var viewRating1: UIView!
    @IBOutlet public weak var view1TitleLabel: UILabel!
    @IBOutlet public weak var view1SubTitleLabel: UILabel!
    
    //View 2
    @IBOutlet public weak var view2ImagePlaceholder: UIImageView!
    @IBOutlet public weak var viewRating2: UIView!
    @IBOutlet public weak var ratingCountLabel: UILabel!
    @IBOutlet public weak var satisfiedCustLabel: UILabel!
    @IBOutlet public weak var ratingCountView: UIView!
    
    //View 3
    @IBOutlet public weak var viewRating3: UIView!
    @IBOutlet public weak var lblTitle: UILabel!
    @IBOutlet public weak var lblDetail: UILabel!
    @IBOutlet public weak var lblName: UILabel!
    
    static let identifier = "SubRatingCell"
    
    public var customizationSubRatingData: UICustomizationSubRatingData? {
        didSet {
            updateUI()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        updateUI()
    }
    
    public override func layoutSubviews() {
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
            label.font = setCustomFont_WithoutRatio(name: fontName, iPhoneSize: iPhoneSize, iPadSize: iPadSize)
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
        imgQuate.image = ImageHelper.image(named: "ic_quote")
        imgQuate3.image = ImageHelper.image(named: "ic_quote")
        imgLikeSub.image = ImageHelper.image(named: "ic_like_sub")
    }
}

//MARK: -
extension SubRatingCell {
    private func updateUI() {
        if let view1ImageRating = customizationSubRatingData?.view1ImageRating {
            self.view1ImageRating.image = view1ImageRating
        } else {
            self.view1ImageRating.image = nil
        }
        if let view1TitleLabel = customizationSubRatingData?.view1TitleLabel {
            self.view1TitleLabel.text = view1TitleLabel
        } else {
            self.view1TitleLabel.text = ""
        }
        if let view1SubTitleLabel = customizationSubRatingData?.view1SubTitleLabel {
            self.view1SubTitleLabel.text = view1SubTitleLabel
        } else {
            self.view1SubTitleLabel.text = ""
        }
        if let view2ImagePlaceholder = customizationSubRatingData?.view2ImagePlaceholder {
            self.view2ImagePlaceholder.image = view2ImagePlaceholder
        } else {
            self.view2ImagePlaceholder.image = ImageHelper.image(named: "ic_rating_backgroud")
        }
        if let ratingCountLabel = customizationSubRatingData?.ratingCountLabel {
            self.ratingCountLabel.text = ratingCountLabel
        } else {
            self.ratingCountLabel.text = ""
        }
        if let satisfiedCustLabel = customizationSubRatingData?.satisfiedCustLabel {
            self.satisfiedCustLabel.text = satisfiedCustLabel
        } else {
            self.satisfiedCustLabel.text = ""
        }
    }
}
