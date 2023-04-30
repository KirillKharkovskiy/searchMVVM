//
//  SearchViewModel + Objects.swift
//  leonardo
//
//  Created by Кирилл Харьковский on 13.09.2022.
//

import UIKit

extension SearchViewModel {
    
    enum SectionType {
        case tags
        case catalog
    }
    
    struct Section: SectionObject {
        var type: SectionType
        var items: [CellObject]
    }
    
    struct SearchTagsCell: CellObject {
        var isSelected: Bool = false
        var titles = [CellObject]()
        var output: ((Output) -> Void)?
    }
    
    struct SearchTagCell: CellObject {
        var isSelected: Bool = false
        var title = ""
        var url = ""
    }
    
    struct SeachCatalogCell: CellObject {
        var isSelected: Bool = false
        var url = ""
        var currency = ""
        var price = ""
        var title = ""
        var isArrowHidden = false
        var icon = ""
    }

}
