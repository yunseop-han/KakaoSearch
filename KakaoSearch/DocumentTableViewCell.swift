//
//  DocumentTableViewCell.swift
//  KakaoSearch
//
//  Created by 한윤섭 on 2020/08/11.
//  Copyright © 2020 yunseop. All rights reserved.
//

import UIKit

class DocumentCell: UITableViewCell {
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
