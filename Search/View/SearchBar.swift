//
//  SearchB.swift
//  leonardo
//
//  Created by Rotach Roman on 17.08.2022.
//

import UIKit

class SearchBar: UISearchBar {
    
    var search: ((String) -> ())!
    var tapSearchBar = false
    var vc = UIViewController()
    var cancelButton = false
 
    
    struct Search {
        var title: String? = nil
        var placeholder: String
        var search: ((String) -> ())?
    }
    
    init(){
        super.init(frame: .null)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
    }
    
    func configure(showCancelButton: Bool = false, withObject object: Search){
        self.text = object.title
        self.placeholder = object.placeholder
        self.search = object.search
        self.cancelButton = showCancelButton
    }
    
    func configure(vc: UIViewController, placeholder: String){
        self.placeholder = placeholder
        tapSearchBar = true
        self.vc = vc
    }
}

extension SearchBar: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if tapSearchBar {
            let searchVC = Routing.shared.getViewControllerForPush(storyboard: .Search)
            vc.navigationController?.pushViewController(searchVC, animated: true)
            return false
        }
        if cancelButton {
            searchBar.setValue("Отмена", forKey: "cancelButtonText")
            showsCancelButton = true
            
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            smSearch(text: searchText, action: #selector(delaySearch(with:)), afterDelay: 0.5)
    }
    
    @objc func delaySearch(with: String) {
        search(with)
        }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        text = ""
        guard let text = text else {
            return
        }
        search(text)
        showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = text else {
            return
        }
        search(text)
    }
}
