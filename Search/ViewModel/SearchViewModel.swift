//
//  SearchViewModel.swift
//  leonardo
//
//  Created by Кирилл Харьковский on 13.09.2022.
//

import Foundation
import UIKit

class SearchViewModel {
    //MARK: - Properties
    private var searchResponse: SearchResponse?
    enum Output {
        case push(UIViewController)
        case response
        case reloadData
        case scrollToRow
        case presentError(String)
        case animating(Bool)
    }
    
    var output: ((Output) -> Void)?
    
    public var numberOfSections: Int {
        get {
            return objects.count
        }
    }
    private var searchText: String = ""
    public var objects: [Section] = []
    public var currentPageNumber = 1
    
    //MARK: - LifyCicle
    public func viewDidLoad() {
        createTableViewObjects()
    }
    
    public func fetchNextSearchCatalog() {
        fetchNextPageSearchCatalog()
    }
}

// MARK: Search
extension SearchViewModel {
    func search(with text: String) {
        self.searchText = text
        if text.count > 2 {
            self.fetchSearchCatalog()
        } else {
            objects.removeAll()
            output?(.reloadData)
        }
    }
}

//MARK: - Create Object
extension SearchViewModel {
    
    private func createTagsCell() -> [CellObject] {
        var cells: [CellObject] = []
        var tags = [SearchTagCell]()
        searchResponse?.data.tags.forEach {
            tags.append(SearchTagCell(isSelected: false, title: $0.title, url: $0.url))
        }
        cells.append(SearchTagsCell(isSelected: false, titles: tags, output: output))
        return cells
    }
    
    private func createCatalogCell() -> [CellObject] {
        var cells: [CellObject] = []
        
        searchResponse?.data.items.forEach{
            cells.append((SeachCatalogCell(isSelected: false, url: $0.url, currency: CountryLocalService.shared.currency, price: $0.price, title: $0.name, icon: $0.img)))
        }
        return cells
    }
}

//MARK: - Create tables object
extension SearchViewModel {
    private func createTableViewObjects() {
        let tagsSection = Section(type: .tags, items: createTagsCell())
        let catalogSection = Section(type: .catalog, items: createCatalogCell())
        objects = [tagsSection, catalogSection]
        output?(.reloadData)
        output?(.scrollToRow)
    }
    
    private func addingPaginationData() {
        var cells: [CellObject] = []
        objects.forEach { item in
            switch item.type {
            case .catalog:
                cells = item.items
            default: break
            }
        }
        let tagsSection = Section(type: .tags, items: createTagsCell())
        let catalogSection = Section(type: .catalog, items: cells + createCatalogCell() )
        objects = [tagsSection, catalogSection]
        output?(.reloadData)
    }
}


//MARK: - Network
extension SearchViewModel {
    private func fetchSearchCatalog() {
        output?(.animating(true))
        SearchService.shared.fetchSearchCatalog(searchTetx: searchText) {  [weak self]  (result, strError ) in
            switch result {
            case .success(let response):
                self?.searchResponse = response
                self?.createTableViewObjects()
                self?.output?(.animating(false))
                self?.output?(.scrollToRow)
                self?.output?(.scrollToRow)
            case .failure(let error):
                self?.output?(.animating(false))
                self?.objects.removeAll()
                self?.output?(.reloadData)
                if strError != nil {
                    self?.output?(.presentError(strError ?? ""))
                } else {
                    self?.output?(.presentError(error.localizedDescription))
                }
            }
        }
    }
    
    private func fetchNextPageSearchCatalog() {
        output?(.animating(true))
        currentPageNumber += 1
        SearchService.shared.fetchSearchCatalog(enablePagination: true, pageNumber: currentPageNumber, searchTetx: searchText) {  [weak self]  (result, _ ) in
            switch result {
            case .success(let response):
                self?.searchResponse = response
                self?.addingPaginationData()
                self?.output?(.animating(false))
            case .failure(_):
                self?.output?(.animating(false))
            }
        }
    }
}
