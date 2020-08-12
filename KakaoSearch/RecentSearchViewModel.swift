//
//  RecentSearchViewModel.swift
//  KakaoSearch
//
//

import Foundation

class RecentSearchViewModel {
    var suggestList: Box<[String]> = Box([])
    func search(str: String) {
        suggestList.value.append(str)
    }
}
