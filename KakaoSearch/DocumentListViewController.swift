//
//  DocumentListViewController.swift
//  KakaoSearch
//
//

import UIKit

class DocumentListViewController: UIViewController {
    
    @IBOutlet weak var documentsTableView: UITableView!
    
    private let viewmodel = DocumentListViewModel(searchAPI: KaKaoSearchAPI.init())
    private var documents: [Document]?
    
    var resultSearchBarController: UISearchController!
    var suggestedTableController: RecentSearchTableController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        suggestedTableController = RecentSearchTableController()
        suggestedTableController.setup()
        suggestedTableController.suggestedSearchDelegate = self
        
        resultSearchBarController = UISearchController(searchResultsController: suggestedTableController)
        resultSearchBarController.searchResultsUpdater = self
        resultSearchBarController.hidesNavigationBarDuringPresentation = false
        resultSearchBarController.searchBar.returnKeyType = .search
        resultSearchBarController.searchBar.delegate = self
        navigationItem.titleView = resultSearchBarController.searchBar
        documentsTableView.delegate = self
        documentsTableView.dataSource = self
        bind()
        definesPresentationContext = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (actualPosition > contentHeight - scrollView.frame.height) {
            viewmodel.fetch()
        }
    }
    
    // MARK: - bind view model
    func bind() {
        viewmodel.documents.bind { [unowned self]documents in
            self.documents = documents
            DispatchQueue.main.async {
                self.documentsTableView.reloadData()
            }
        }
    }
    
}

// MARK: - Button Action
extension DocumentListViewController {
    @IBAction func filterTab(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "All", style: .default, handler: { _ in
            self.viewmodel.setFileterType(where: .all)
        }))
        alert.addAction(UIAlertAction(title: "Blog", style: .default, handler: { _ in
            self.viewmodel.setFileterType(where: .blog)
        }))
        alert.addAction(UIAlertAction(title: "Cafe", style: .default, handler: { _ in
            self.viewmodel.setFileterType(where: .cafe)
        }))
        self.present(alert, animated: false, completion: nil)
    }
    
    @IBAction func sortTab(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Title", style: .default, handler: { _ in
            self.viewmodel.setSortType(by: .title)
        }))
        alert.addAction(UIAlertAction(title: "Date", style: .default, handler: { _ in
            self.viewmodel.setSortType(by: .date)
        }))
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
}

// MARK: - table view delegate
extension DocumentListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        let viewmodel = DocumentDetailViewModel(self.viewmodel.getDocument(at: indexPath.row))
        let instant = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DocumentDetailViewController
        instant.viewModel = viewmodel
        self.navigationController?.pushViewController(instant, animated: false)
    }
}

// MARK: - data source
extension DocumentListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewmodel.documents.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath) as! DocumentCell
        
        let target = viewmodel.getDocument(at: indexPath.row)
        let viewmodel = DocumentCellViewModel(document: target)
        cell.setup(viewModel: viewmodel)
        return cell
    }
    
}
// MARK: - SearchBar
extension DocumentListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
}

extension DocumentListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        suggestedTableController.search(str: searchBar.text!)
        viewmodel.search(query: searchBar.text!)
        resultSearchBarController.dismiss(animated: false, completion: nil)
    }
}


extension DocumentListViewController: SuggestedSearch {
    func didSelectSuggestedSearch(query: String) {
        resultSearchBarController.searchBar.text = query
        viewmodel.search(query: query)
        resultSearchBarController.dismiss(animated: false, completion: nil)
    }
}
