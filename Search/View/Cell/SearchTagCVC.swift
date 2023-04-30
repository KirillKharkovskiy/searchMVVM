//
//  SearchTagCVC.swift
//  leonardo
//
//  Created by Кирилл Харьковский on 14.09.2022.
//

import UIKit

class SearchTagCVC: UICollectionViewCell, CollectionViewCellConfigurable, NibReusable  {
    @IBOutlet weak private var titleLabel: UILabel!
    
    func configure(with object: CellObject) {
        guard let obj = object as? SearchViewModel.SearchTagCell else { return }
        titleLabel.text = obj.title
        self.layer.cornerRadius = 16
    }
}
