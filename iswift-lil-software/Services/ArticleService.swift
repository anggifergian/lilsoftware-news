//
//  ArticleService.swift
//  iswift-lil-software
//
//  Created by Anggi Fergian on 05/05/23.
//

import Foundation
import Alamofire

class ArticleService {
    static let shared: ArticleService = ArticleService()
    
    let BASE_URL = "https://api.lil.software/news"
    
    private init() { }
    
    func loadArticleList(completion: @escaping (Result<[Article], Error>) -> Void) {
        let endpoint = "\(BASE_URL)"
        
        AF.request(endpoint, method: .get)
            .validate()
            .responseDecodable(of: ArticleResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data.articles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
