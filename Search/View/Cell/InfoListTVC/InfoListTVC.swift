//
//  InfoListTVC.swift
//  leonardo
//
//  Created by Rotach Roman on 28.07.2022.
//

import UIKit
import Kingfisher

protocol IconType {}
extension UIImage: IconType {}
extension String: IconType {}

class InfoListTVC: UITableViewCell {
    
    private var obj: InfoList!
    
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var subtitleLbl: UILabel!
    @IBOutlet private weak var aboutLbl: UILabel!
    @IBOutlet private weak var helperTitleLbl: UILabel!
    @IBOutlet private weak var iconIv: UIImageView!
    @IBOutlet private weak var backV: UIView!
    @IBOutlet private weak var arrowIcon: UIImageView!
    @IBOutlet private weak var bottomConstaint: NSLayoutConstraint!
    @IBOutlet private weak var topConstaint: NSLayoutConstraint!
    @IBOutlet private weak var heightIconConstraint: NSLayoutConstraint!
    @IBOutlet private weak var widthIconConstraint: NSLayoutConstraint!
    @IBOutlet private weak var iconTopConstraint: NSLayoutConstraint!
    private var bottomConstraintsState = true
    private var topConstraintsState = false
    private var showSeparatorState = false
    private var heightAndWidthIconConst = 24
    private var iconTopConst = 28
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !showSeparatorState {
            for view in subviews where view != contentView {
                view.removeFromSuperview()
            }
        }
    }
    
    struct InfoList {
        var isSelected: Bool = false
        var title: String
        var icon: IconType
        var subtitle: String? = nil
        var about: String? = nil
        var helperTitle: String? = nil
        var isArrowHidden: Bool = true
    }
   
    func configure(with object: InfoList, topConstraints: Bool = false, bottomConstraints: Bool = true, showSeparator: Bool = false, heightAndWidthIconConst: Int = 24, iconTopIsConstraint: Bool = true) {
        self.obj = object
        bottomConstraintsState = bottomConstraints
        topConstraintsState = topConstraints
        showSeparatorState = showSeparator
        self.heightAndWidthIconConst = heightAndWidthIconConst
        if !iconTopIsConstraint {
            self.iconTopConst = Int((Int(backV.frame.height) / 2) - (heightAndWidthIconConst / 2))
        }
        setupUI()
    }
}

//MARK: - SetupUI
extension InfoListTVC {
    private func setupUI(){
        fillingData()
        
        iconTopConstraint.constant = CGFloat(iconTopConst)
        if bottomConstraintsState {
            backV.layer.cornerRadius = 10
            backV.layer.masksToBounds = true
            bottomConstaint.constant = 12
        } else {
            bottomConstaint.constant = 0
            if topConstraintsState {
                backV.layer.cornerRadius = 10
                backV.layer.masksToBounds = true
                topConstaint.constant = 12
            }
        }
        
        heightIconConstraint.constant = CGFloat(heightAndWidthIconConst)
        widthIconConstraint.constant = CGFloat(heightAndWidthIconConst)
    }
    
    private func fillingData(){
        self.titleLbl.setAttribute(with: obj.title, fontName: .SFProDisplayMedium, size: 18)
        
        if let subtitle = obj.subtitle {
            
            subtitleLbl.text = subtitle
            
            self.subtitleLbl.setAttribute(with: subtitle, fontName: .SFProDisplayRegular, size: 12)
        } else {
            subtitleLbl.isHidden = true
        }
        
        if let about = obj.about {
            self.aboutLbl.setAttribute(with: about, fontName: .SFProDisplayRegular, size: 12)
            aboutLbl.textColor = Colors._858585.value
        } else {
            aboutLbl.isHidden = true
        }
        
        if let helperTitle = obj.helperTitle {
            self.helperTitleLbl.setAttribute(with: helperTitle, fontName: .SFProDisplayRegular, size: 12)
            helperTitleLbl.textColor = Colors._858585.value
        } else {
            helperTitleLbl.isHidden = true
        }
        
        if let iconUrl = obj.icon as? String {
            
            guard let url = ApiSettings.getImageURL(with: iconUrl) else { return }
            iconIv.kf.indicatorType = .activity
            
            if url.absoluteString.contains("svg") {
                iconIv.kf.setImage(with: url, options: [.processor(SVGImgProcessor())])
            } else {
                iconIv.kf.setImage(with: url)
            }
        } else {
            self.iconIv.image = obj.icon as? UIImage
        }
        
        
        self.arrowIcon.isHidden = obj.isArrowHidden
    }
}
