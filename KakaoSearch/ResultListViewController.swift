//
//  RecentSearchTableController.swift
//  KakaoSearch
//
//

import UIKit



protocol SuggestedSearch: class {
    func didSelectSuggestedSearch(query: String)
}

class RecentSearchTableController: UITableViewController {
    weak var suggestedSearchDelegate: SuggestedSearch?
    
    var vieeModel: SuggestResultViewController! = SuggestResultViewController()
    var list: [String]! = []
    func setup() {
        vieeModel.suggestList.bind {[weak self] string in
            self?.list = string
            self?.tableView.reloadData()
        }
    }
    
    func search(str: String) {
        self.vieeModel.search(str: str)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let query = list[indexPath.row]
        suggestedSearchDelegate?.didSelectSuggestedSearch(query: query)
    }
    
    
}
