//
//  DocumentListViewModel.swift
//  KakaoSearch
//
//

import Foundation
import UIKit


enum FileterType: String {
    case all, blog, cafe
}
enum SortedType: String {
    case date, title
}

public class DocumentListViewModel {
    typealias MetaResponse = (index: Int, isEnd: Bool, isFetching: Bool)
    
    var documents: Box<[Document]>
    var searchAPI: SearchType
    var query: String = ""
    var blogSearchResult: MetaResponse = (1, false, false)
    var cafeSearchResult: MetaResponse = (1, false, false)
    var filter: FileterType = .all
    var sorted: SortedType = .title
    
    init(searchAPI: SearchType) {
        self.searchAPI = searchAPI
        documents = Box([])
    }
    
    func getDocument(at index: Int) -> Document {
        return FilterdDocuments()[index]
    }
    
    func search(query: String) {
        DocumentStorage.shared.removeAll()
        documents.value = DocumentStorage.shared.documents
        blogSearchResult = (1, false, false)
        cafeSearchResult = (1, false, false)
        self.query = query
        self.fetch()
    }
    
    
    
    func setFileterType(where filter: FileterType) {
        self.filter = filter
        reloadData()
    }
    
    func setSortType(by: SortedType) {
        self.sorted = by
        reloadData()
    }
    
    private func FilterdDocuments() -> [Document]{
        return DocumentStorage.shared.documents.filter {
            if filter == FileterType.all {
                return true
            }
            return $0.category?.rawValue == filter.rawValue
        }.sorted {
            switch self.sorted {
            case .title:
                return $0.title > $1.title
            case .date:
                return $0.datetime > $1.datetime
            }
        }
    }
    
    func reloadData() {
        documents.value = FilterdDocuments()
    }
    
}
// MARK: - fetch
extension DocumentListViewModel {
    
    func fetch() {
        guard self.blogSearchResult.isFetching == false && self.cafeSearchResult.isFetching == false else {
            return
        }
        fetchBlog()
        fetchCafe()
    }
    
    private func fetch(_ request: KARequest, completion: @escaping (KakaoSearchResponse.Meta)->Void) {
        searchAPI.featch(request) { result in
            do {
                if let data = try result.get() {
                    let response = try JSONDecoder().decode(KakaoSearchResponse.self, from: data)
                    DocumentStorage.shared.append(contentOf: response.documents)
                    completion(response.meta)
                }
            }catch {
            }
        }
    }
    
    private func fetchBlog() {
        guard self.blogSearchResult.isEnd == false else {
            return
        }
        blogSearchResult.isFetching = true
        let request = KARequest(query: self.query, page: blogSearchResult.index, path: "/v2/search/blog")
        fetch(request) { meta in
            self.blogSearchResult.index += 1
            self.blogSearchResult.isEnd = meta.isEnd
            self.blogSearchResult.isFetching = false
            self.reloadData()
        }
    }
    private func fetchCafe() {
        guard self.cafeSearchResult.isEnd == false else {
            return
        }
        cafeSearchResult.isFetching = true
        let request = KARequest(query: self.query, page: cafeSearchResult.index, path: "/v2/search/cafe")
        fetch(request) { meta in
            self.cafeSearchResult.index += 1
            self.cafeSearchResult.isEnd = meta.isEnd
            self.cafeSearchResult.isFetching = false
            self.reloadData()
        }
    }
}
