//
//  Utilities.swift
//  KakaoSearch
//
//  Created by 한윤섭 on 2020/08/11.
//  Copyright © 2020 yunseop. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Observable
final class Box<T> {
    //1
    typealias Listener = (T) -> Void
    var listener: Listener?
    //2
    var value: T {
        didSet {
            listener?(value)
        }
    }
    //3
    init(_ value: T) {
        self.value = value
    }
    //4
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}

// MARK: - HTML Tag remove
extension String {
    func removeHTML() -> String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

// MARK: - image load from url
extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func loadImage(url: String) {
        if let url = URL(string: url) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else {
                    self.image = nil
                    return
                }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = UIImage(data: data)
                }
            }
        } else {
            self.image = nil
        }
    }
}


