//
//  BookVO.swift
//  LibraryApp
//
//  Created by KC on 15/06/2022.
//

import Foundation

// MARK: - BookListResponse
struct BookListResponse: Codable {
    let status, copyright: String?
    let numResults: Int?
    let results: BookListResult?

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}

// MARK: - Results
struct BookListResult: Codable {
    let bestsellersDate, publishedDate, publishedDateDescription, previousPublishedDate: String?
    let nextPublishedDate: String?
    let lists: [BookList]?

    enum CodingKeys: String, CodingKey {
        case bestsellersDate = "bestsellers_date"
        case publishedDate = "published_date"
        case publishedDateDescription = "published_date_description"
        case previousPublishedDate = "previous_published_date"
        case nextPublishedDate = "next_published_date"
        case lists
    }
}

// MARK: - List
struct BookList: Codable {
    let listID: Int?
    let listName, listNameEncoded, displayName: String?
    let updated: String?
    let listImage, listImageWidth, listImageHeight: JSONNull?
    let books: [Book]?

    enum CodingKeys: String, CodingKey {
        case listID = "list_id"
        case listName = "list_name"
        case listNameEncoded = "list_name_encoded"
        case displayName = "display_name"
        case updated
        case listImage = "list_image"
        case listImageWidth = "list_image_width"
        case listImageHeight = "list_image_height"
        case books
    }
}

// MARK: - Book
struct Book: Codable {
    let ageGroup: String?
    let amazonProductURL: String?
    let articleChapterLink, author: String?
    let bookImage: String?
    let bookImageWidth, bookImageHeight: Int?
    let bookReviewLink: String?
    let contributor: String?
    let contributorNote: String?
    let createdDate, bookDescription, firstChapterLink, price: String?
    let primaryIsbn10, primaryIsbn13, bookURI, publisher: String?
    let rank, rankLastWeek: Int?
    let sundayReviewLink: String?
    let title, updatedDate: String?
    let weeksOnList: Int?
    let buyLinks: [BuyLink]?

    enum CodingKeys: String, CodingKey {
        case ageGroup = "age_group"
        case amazonProductURL = "amazon_product_url"
        case articleChapterLink = "article_chapter_link"
        case author
        case bookImage = "book_image"
        case bookImageWidth = "book_image_width"
        case bookImageHeight = "book_image_height"
        case bookReviewLink = "book_review_link"
        case contributor
        case contributorNote = "contributor_note"
        case createdDate = "created_date"
        case bookDescription = "description"
        case firstChapterLink = "first_chapter_link"
        case price
        case primaryIsbn10 = "primary_isbn10"
        case primaryIsbn13 = "primary_isbn13"
        case bookURI = "book_uri"
        case publisher, rank
        case rankLastWeek = "rank_last_week"
        case sundayReviewLink = "sunday_review_link"
        case title
        case updatedDate = "updated_date"
        case weeksOnList = "weeks_on_list"
        case buyLinks = "buy_links"
    }
    
    static func empty()->Book{
        return Book(ageGroup: nil, amazonProductURL: nil, articleChapterLink: nil, author: nil, bookImage: nil, bookImageWidth: nil, bookImageHeight: nil, bookReviewLink: nil, contributor: nil, contributorNote: nil, createdDate: nil, bookDescription: nil, firstChapterLink: nil, price: nil, primaryIsbn10: nil, primaryIsbn13: nil, bookURI: nil, publisher: nil, rank: nil, rankLastWeek: nil, sundayReviewLink: nil, title: nil, updatedDate: nil, weeksOnList: nil, buyLinks: nil)
    }
    
    static func dummy()->Book{
        return Book(ageGroup: "", amazonProductURL: "https://www.amazon.com/Where-Crawdads-Sing-Delia-Owens/dp/0735219095?tag=NYTBSREV-20", articleChapterLink: "", author: "Delia Owens", bookImage: "https://storage.googleapis.com/du-prd/books/images/9780735219090.jpg", bookImageWidth:   0, bookImageHeight: 0, bookReviewLink: nil, contributor: "by Delia Owens", contributorNote: nil, createdDate: nil, bookDescription: nil, firstChapterLink: nil, price: nil, primaryIsbn10: "0735219109", primaryIsbn13: nil, bookURI: nil, publisher: nil, rank: nil, rankLastWeek: nil, sundayReviewLink: nil, title: "WHERE THE CRAWDADS SING", updatedDate: nil, weeksOnList: nil, buyLinks: nil)
    }
}

// MARK: - BuyLink
struct BuyLink: Codable {
    let name: String?
    let url: String?
}

enum Name: String, Codable {
    case amazon = "Amazon"
    case appleBooks = "Apple Books"
    case barnesAndNoble = "Barnes and Noble"
    case booksAMillion = "Books-A-Million"
    case bookshop = "Bookshop"
    case indieBound = "IndieBound"
}

enum ContributorNote: String, Codable {
    case empty = ""
    case illustratedByNatalieRussell = "Illustrated by Natalie Russell"
    case illustratedByPatriciaCastelao = "Illustrated by Patricia Castelao"
    case illustratedBySydneyHanson = "Illustrated by Sydney Hanson"
    case illustratedByTomLichtenheld = "Illustrated by Tom Lichtenheld"
    case writtenAndIllustratedByJeffKinney = "written and illustrated by Jeff Kinney"
}

enum Updated: String, Codable {
    case monthly = "MONTHLY"
    case weekly = "WEEKLY"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

