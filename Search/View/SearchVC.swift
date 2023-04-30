//
//  SearchVC.swift
//  leonardo
//
//  Created by Кирилл Харьковский on 13.09.2022.
//

import UIKit

class SearchVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet private weak var searchBar: SearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noDataLabel: UILabel!
    var viewModel: SearchViewModel!
    
    //MARK: - LifyCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel()
        configureViewModelBinding()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - Setup
    private func setup() {
        setupSearch()
        setupTableView()
    }
    private func setupSearch(){
        searchBar.configure( showCancelButton: true, withObject: SearchBar.Search(placeholder: "Поиск по назанию", search: { [weak self] text in
            self?.viewModel.search(with: text)
        }))
    }
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func setupUI(){
        tableView.isHidden = viewModel.numberOfSections == 0 ? true : false
        noDataLabel.isHidden = viewModel.numberOfSections == 0 ? false : true
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.objects[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionObject = viewModel.objects[indexPath.section]
        
        let cellObject = sectionObject.items[indexPath.row]
        
        var cell: TableViewCellConfigurable!
        
        switch sectionObject.type {
        case .tags:
            cell = tableView.cell(forClass: SearchTagBlockTVC.self)
        case .catalog:
            let infoCell = tableView.cell(forClass: InfoListTVC.self)
            guard let cellObject = cellObject as? SearchViewModel.SeachCatalogCell else {
                return UITableViewCell()
            }
          
            let infoListModel = InfoListTVC.InfoList( title: cellObject.price, icon: cellObject.icon,  about: cellObject.title, helperTitle: cellObject.currency, isArrowHidden: false)
            infoCell.configure(with: infoListModel, bottomConstraints: false, showSeparator: true, heightAndWidthIconConst: 38)
            infoCell.configure(with: infoListModel, bottomConstraints: false, showSeparator: true, heightAndWidthIconConst: 38, iconTopIsConstraint: false)
            return infoCell
        }
        cell.configure(with: cellObject)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectionObject = viewModel.objects[indexPath.section]
        if indexPath.section == 1 && indexPath.row == sectionObject.items.count - 1 {
            viewModel.fetchNextSearchCatalog()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionObject = viewModel.objects[indexPath.section]
        let cellObject = sectionObject.items[indexPath.row] as? SearchViewModel.SeachCatalogCell
        guard let vc = Routing.shared.getViewControllerForPush(storyboard: .ProductCard) as? ProductCardVC else { return }
        guard let url = cellObject?.url else { return }
        vc.viewModel = ProductCardViewModel(input: .init(url: url))
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - ViewModelChangeConfigure
extension SearchVC: ViewModelChangeConfigure {
    func configureViewModelBinding() {
        viewModel.output = { [weak self] output in
            switch output {
            case .push(let vc):
                self?.navigationController?.pushViewController(vc, animated: true)
            case .response:
                self?.tableView.reloadData()
            case .reloadData:
                self?.setupUI()
                self?.tableView.reloadData()
            case .scrollToRow:
                self?.tableView.beginUpdates()
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                self?.tableView.endUpdates()
                
            case .presentError(let error):
                self?.presentError(with: error, message: nil)
            case .animating(let animated):
                animated ? self?.startLoader() : self?.stopLoader()
            }
        }
    }
}
