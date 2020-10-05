//
//  Moive.swift
//  MvcFullPro
//
//  Created by Ghassan  albakuaa  on 10/4/20.
//

import Foundation

// PageResult
struct PageResult: Codable {
    
    var page: Int
    var totalResults: Int
    var totalPages: Int
    var results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

// Movie
struct Movie: Codable {
    
    var id: Int
    var posterImage: String
    var title: String
    var releaseDate: String
    var overview: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterImage = "poster_path"
        case releaseDate = "release_date"
    }
}
