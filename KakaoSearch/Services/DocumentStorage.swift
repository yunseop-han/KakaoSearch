//
//  DocumentStorage.swift
//  KakaoSearch
//
//

import Foundation


class DocumentStorage {
    static var shared = DocumentStorage()
    private var documentList: [Document] = []
    private var currentSearchList: [String] = []
    var documents: [Document] {
        return documentList
    }
    
    func removeAll() {
        documentList.removeAll()
    }
    
    func append(contentOf documents: [Document]) {
        documentList.append(contentsOf: documents)
    }
    
    func view(index documentIndex: Int) {
        documentList[documentIndex].view()
    }
    
}
