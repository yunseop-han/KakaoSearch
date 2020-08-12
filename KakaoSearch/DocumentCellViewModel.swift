//
//  DocumentCellViewModel.swift
//  KakaoSearch
//
//

import Foundation

class DocumentCellViewModel {
    let document: Box<Document>
    
    init(document: Document) {
        self.document = Box(document)
    }
}
