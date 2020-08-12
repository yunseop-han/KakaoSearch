//
//  KakaoSearchTests.swift
//  KakaoSearchTests
//
//  Created by 한윤섭 on 2020/08/10.
//  Copyright © 2020 yunseop. All rights reserved.
//

import XCTest
@testable import KakaoSearch

extension XCTestCase {
    func timeout(_ timeout: TimeInterval, completion: (XCTestExpectation) -> Void) {
        let exp = expectation(description: "Timeout: \(timeout) seconds")
        
        completion(exp)
        
        waitForExpectations(timeout: timeout) { error in
            guard let error = error else { return }
            XCTFail("Timeout error: \(error)")
        }
    }
    
    func wait(_ timeout: TimeInterval, completion: (XCTestExpectation) -> Void) {
        let exp = expectation(description: "Timeout: \(timeout) seconds")
        
        completion(exp)
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
}

let dummy = "{\"documents\":[{\"blogname\":\"dummy1\",\"contents\":\"dummy contents\",\"datetime\":\"2020-02-28T21:39:00.000+09:00\",\"thumbnail\":\"\",\"title\":\"dummy title\",\"url\":\"http://etnluv.tistory.com/232\"},{\"blogname\":\"dummy2\",\"contents\":\"dummy2 contents\",\"datetime\":\"2009-02-24T16:27:00.000+09:00\",\"thumbnail\":\"\",\"title\":\"dumm2 title\",\"url\":\"http://blog.naver.com/PostView.nhn?blogId=hwajung5089\\u0026logNo=130043261300\"}],\"meta\":{\"is_end\":true,\"pageable_count\":2,\"total_count\":2}}\n"

struct MockAPI: SearchType {
    func featch(_ request: APIRequest, completion: @escaping (FetchDataResult) -> Void) {
        if (request.url?.absoluteString.contains("cafe"))! {
            completion(.failure(SessionError.invalidURL))
            return
        }
        let data = dummy.data(using: .utf8)!
        completion(.success(data))
    }
}


struct MockData {
    let dummyResponse: KakaoSearchResponse
    init() {
        do{
            dummyResponse = try JSONDecoder().decode(KakaoSearchResponse.self, from: dummy.data(using: .utf8)!)
        }catch{
            fatalError()
        }
    }
}

class KakaoSearchTests: XCTestCase {
    
    func test_필터_변경() {
        let mockAPI = MockAPI()
        
        let viewmodel = DocumentListViewModel.init(searchAPI: mockAPI)
        XCTAssertEqual(viewmodel.filter, .all)
        viewmodel.setFileterType(where: .blog)
        XCTAssertEqual(viewmodel.filter, .blog)
    }
    
    func test_필터가_변경되면_문서리스트도_변경되어야한다() {
        let mockAPI = MockAPI()
        
        let viewmodel = DocumentListViewModel.init(searchAPI: mockAPI)
        viewmodel.setFileterType(where: .cafe)
        viewmodel.fetch()
        wait(2) { (expectation) in
            viewmodel.documents.bind { (documents) in
                expectation.fulfill()
                XCTAssertEqual([], documents)
            }
        }
    }
    
    func test_정렬_방식_변경() {
        let mockAPI = MockAPI()
        
        let viewmodel = DocumentListViewModel.init(searchAPI: mockAPI)
        XCTAssertEqual(viewmodel.sorted, .title)
        
        viewmodel.setSortType(by: .date)
        XCTAssertEqual(viewmodel.sorted, .date)
    }
    
    func test_데이터_fetch() {
        let mockAPI = MockAPI()
        
        let viewmodel = DocumentListViewModel.init(searchAPI: mockAPI)
        viewmodel.fetch()
        timeout(2) { expectation in
            viewmodel.documents.bind { document in
                if !document.isEmpty {
                    expectation.fulfill()
                }
            }
        }
        
        for i in MockData.init().dummyResponse.documents.indices{
            XCTAssertTrue(MockData.init().dummyResponse.documents.contains(viewmodel.getDocument(at: i)))
        }
    }
    
}
