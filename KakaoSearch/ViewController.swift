//
//  ViewController.swift
//  KakaoSearch
//
//  Created by 한윤섭 on 2020/08/10.
//  Copyright © 2020 yunseop. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(url: String) {
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: url),
                let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self!.image = image
                    }
                }
            }
        }
    }
}


class DocumentCellViewModel {
    let document: Box<Document>
    
    init(document: Document) {
        self.document = Box(document)
    }
}

extension Document {
    var shortDate:String {
        let aDayInterval:Double = 86400
        let yesterday = Date(timeIntervalSinceNow: -aDayInterval)
        let beforYesterday = Date(timeInterval: -aDayInterval, since: yesterday)
        if self.datetime.timeIntervalSince1970 > yesterday.timeIntervalSince1970 {
            return "오늘"
        } else if self.datetime.timeIntervalSince1970 > beforYesterday.timeIntervalSince1970 {
            return "어제"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter.string(from: self.datetime)
        }
    }
    
    var lognDate:String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
        return formatter.string(from: self.datetime)
    }
}

class DocumentTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var viewModel: DocumentCellViewModel?
    func setup(viewModel: DocumentCellViewModel) {
        self.viewModel = viewModel
        viewModel.document.bind { document in
            self.categoryLabel.text = document.category?.rawValue
            self.titleLabel.text = document.name
            self.contentsLabel.text = document.contents
            self.dateLabel.text = document.shortDate
            self.thumbnailImageView.loadImage(url: document.thumbnail)
            if document.isVieed ?? false {
                self.backgroundColor = .red
            } else {
                self.backgroundColor = .black
            }
        }
    }
    
}

class DocumentListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var documentsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let viewmodel = DocumentViewModel()
    private var documents: [Document]?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewmodel.search(searchedText: searchText)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        documentsTableView.delegate = self
        documentsTableView.dataSource = self
        searchBar.delegate = self
        viewmodel.documents.bind { [unowned self]documents in
            self.documents = documents
            DispatchQueue.main.async {
                self.documentsTableView.reloadData()
                
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.reloadData()
        documentsTableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let actualPosition = scrollView.contentOffset.y;
         let contentHeight = scrollView.contentSize.height - (1500);
         if (actualPosition >= contentHeight) {
            viewmodel.featch()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath) as! DocumentTableViewCell
        
        let viewmodel = DocumentDetailViewModel(self.viewmodel.getDocument(at: indexPath.row))
        let instant = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        instant.viewModel = viewmodel
        self.navigationController?.pushViewController(instant, animated: false)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let documents = documents else {
            return 0
        }
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath) as! DocumentTableViewCell
        
        let target = viewmodel.getDocument(at: indexPath.row)
        let viewmodel = DocumentCellViewModel(document: target)
        cell.setup(viewModel: viewmodel)
        return cell
    }

}
