//
//  SearchTagBlockTVC.swift
//  leonardo
//
//  Created by Кирилл Харьковский on 14.09.2022.
//

import UIKit

class SearchTagBlockTVC: UITableViewCell, TableViewCellConfigurable{
    
    //MARK: - Properties
    @IBOutlet weak private var collectionView: DynamicHeightCollectionView!
    private var objects: [CellObject] = []
     var output: ((SearchViewModel.Output) -> Void)?

    //MARK: - LifyCicle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews where view != contentView {
            view.removeFromSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func configure(with object: CellObject) {
        guard let obj = object as? SearchViewModel.SearchTagsCell else { return }
        self.objects = obj.titles
        output = obj.output
        collectionView.reloadData()
    }
    
    
    private func setupCollectionView() {
        collectionView.register(cellType: SearchTagCVC.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
}


extension SearchTagBlockTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchTagCVC.self)
        let object = objects[indexPath.row]
        cell.configure(with: object)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellObject = objects[indexPath.row] as? SearchViewModel.SearchTagCell
        
        guard let vc = Routing.shared.getViewControllerForPresent(storyboard: .CatalogProducts) as? CatalogProductsVC else { return }
        guard let url = cellObject?.url, let title = cellObject?.title else { return }
        vc.viewModel = CatalogProductsViewModel(input: CatalogProductsViewModel.Input(url: url, name: title, type: CatalogProductsViewModel.Input.TypeOpen.catalog))
        output?(.push(vc))
        
    }
}
