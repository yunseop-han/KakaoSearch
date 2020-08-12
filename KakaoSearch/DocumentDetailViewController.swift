//
//  DocumentDetailViewController.swift
//  KakaoSearch
//
//

import UIKit

class DocumentDetailViewController: UIViewController {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    var viewModel: DocumentDetailViewModel! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = viewModel.document.name
        self.titleLabel.text = viewModel.document.title
        self.contentsTextView.text = viewModel.document.contents
        self.thumbnailImageView.loadImage(url: viewModel.document.thumbnail)
        self.dateLabel.text = viewModel.document.lognDate
        self.urlLabel.text = viewModel.document.url
        self.title = viewModel.document.category?.rawValue
        
    }
    
    @IBAction func tapUrl(_ sender: Any) {
        UIApplication.shared.open(URL(string: viewModel.document.url)!)
        viewModel.tabUrl()
    }
    
    @IBAction func tabBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}
