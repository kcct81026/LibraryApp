//
//  CategoryBookVO.swift
//  LibraryApp
//
//  Created by KC on 17/06/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchCategoryResponse = try? newJSONDecoder().decode(SearchCategoryResponse.self, from: jsonData)

import Foundation

// MARK: - SearchCategoryResponse
struct CategoryResponse: Codable {
    let status, copyright: String?
    let numResults: Int?
    let lastModified: String?
    let results: [CategoryResult]?

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case lastModified = "last_modified"
        case results
    }
    
    static func empty() -> CategoryResponse{
        return CategoryResponse(status: nil, copyright: nil, numResults: nil , lastModified: nil , results: nil )
    }
}

// MARK: - Result
struct CategoryResult: Codable {
    let listName: String?
    let displayName: String?
    let bestsellersDate, publishedDate: String?
    let rank, rankLastWeek, weeksOnList, asterisk: Int?
    let dagger: Int?
    let amazonProductURL: String?
    let isbns: [Isbn]?
    let bookDetails: [Book]?
    let reviews: [Review]?

    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case bestsellersDate = "bestsellers_date"
        case publishedDate = "published_date"
        case rank
        case rankLastWeek = "rank_last_week"
        case weeksOnList = "weeks_on_list"
        case asterisk, dagger
        case amazonProductURL = "amazon_product_url"
        case isbns
        case bookDetails = "book_details"
        case reviews
    }
}


enum DisplayName: String, Codable {
    case combinedPrintEBookFiction = "Combined Print & E-Book Fiction"
}

// MARK: - Isbn
struct Isbn: Codable {
    let isbn10, isbn13: String?
}

enum ListName: String, Codable {
    case combinedPrintAndEBookFiction = "Combined Print and E-Book Fiction"
}

// MARK: - Review
struct Review: Codable {
    let bookReviewLink, firstChapterLink, sundayReviewLink, articleChapterLink: String?

    enum CodingKeys: String, CodingKey {
        case bookReviewLink = "book_review_link"
        case firstChapterLink = "first_chapter_link"
        case sundayReviewLink = "sunday_review_link"
        case articleChapterLink = "article_chapter_link"
    }
}
