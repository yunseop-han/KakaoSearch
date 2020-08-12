//
//  SearchService.swift
//  KakaoSearch
//
//

import Foundation

protocol APIRequest {
    var url: URL? { get set }
}

struct KARequest: APIRequest {
    var url: URL?
    let scheme = "https"
    let host = "dapi.kakao.com"
    init(query: String, page: Int, path: String) {
        var builder = URLComponents()
        builder.scheme = scheme
        builder.host = host
        builder.path = path
        builder.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "25")]
        url = builder.url
    }
}

protocol SearchType {
    typealias GetDataResponse = Data?
    typealias FetchDataResult = Result<GetDataResponse, Error>
    
    func featch(_ request: APIRequest, completion: @escaping (FetchDataResult) -> Void)
}

enum SessionError: Error {
    case invalidURL
    case unknownError
}

struct KaKaoSearchAPI: SearchType {
    private let apiKey = APIKey
    func featch(_ request: APIRequest, completion: @escaping (FetchDataResult) -> Void) {
        guard let url = request.url else {
            return completion(.failure(SessionError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    return completion(.failure(error))
                }
                
                guard let response = response as? HTTPURLResponse else {
                    return completion(.failure(SessionError.unknownError))
                }
                switch response.statusCode {
                case 200 ..< 300:
                    completion(.success(data))
                default:
                    completion(.failure(SessionError.unknownError))
                }
            }
        }.resume()
    }
}

