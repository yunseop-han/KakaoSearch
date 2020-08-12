//
//  DocumentDetailViewModel.swift
//  KakaoSearch
//
//

import Foundation

class DocumentDetailViewModel {
    var document: Document
    
    init(_ document: Document) {
        self.document = document
    }
    
    func tabUrl() {
        if let index = DocumentStorage.shared.documents.firstIndex(where: { $0.id == document.id}) {
            DocumentStorage.shared.view(index: index)
        }
    }
}
