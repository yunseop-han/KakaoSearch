//
//  DocumentCell.swift
//  KakaoSearch
//
//

import UIKit


class DocumentCell: UITableViewCell  {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var viewModel: DocumentCellViewModel! = nil
    
    func setup(viewModel: DocumentCellViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    func bind() {
        viewModel.document.bind { document in
            self.categoryLabel.text = document.category?.rawValue
            self.titleLabel.text = document.name
            self.contentsLabel.text = document.contents
            self.dateLabel.text = document.shortDate
            self.thumbnailImageView.loadImage(url: document.thumbnail)
            if document.isView ?? false {
                self.backgroundColor = .darkGray
            } else {
                self.backgroundColor = .none
            }
        }
    }
    
}
