//
//  ArticleResponse.swift
//  iswift-lil-software
//
//  Created by Anggi Fergian on 05/05/23.
//

import Foundation

struct ArticleResponse: Decodable {
    let articles: [Article]
    
    enum CodingKeys: String, CodingKey {
        case articles
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.articles = try container.decodeIfPresent([Article].self, forKey: .articles) ?? []
    }
}
