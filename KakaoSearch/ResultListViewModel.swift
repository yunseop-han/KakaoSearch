//
//  SuggestResultViewController.swift
//  KakaoSearch
//
//  Created by 한윤섭 on 2020/08/12.
//  Copyright © 2020 yunseop. All rights reserved.
//

import Foundation

class SuggestResultViewController {
    var suggestList: Box<[String]> = Box([])
    func search(str: String) {
        suggestList.value.append(str)
    }
}
