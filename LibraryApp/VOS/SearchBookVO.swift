//
//  SearchBookVO.swift
//  LibraryApp
//
//  Created by KC on 20/06/2022.
//

import Foundation


// MARK: - SearchBookResponse
struct SearchBookResponse: Codable {
    let kind: String?
    let totalItems: Int?
    let items: [SearchBookResult]?
}

// MARK: - Item
struct SearchBookResult: Codable {
    let kind: Kind?
    let id, etag: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
    let accessInfo: AccessInfo?
    let searchInfo: SearchInfo?
    
    static func dummy()-> SearchBookResult{
        return SearchBookResult(kind: nil, id: "24", etag: "", selfLink: "", volumeInfo: nil, saleInfo: nil, accessInfo: nil, searchInfo: nil)
    }
}

// MARK: - AccessInfo
struct AccessInfo: Codable {
    let country: Country?
    let viewability: Viewability?
    let embeddable, publicDomain: Bool?
    let textToSpeechPermission: TextToSpeechPermission?
    let epub: Epub?
    let pdf: PDF?
    let webReaderLink: String?
    let accessViewStatus: AccessViewStatus?
    let quoteSharingAllowed: Bool?
}

enum AccessViewStatus: String, Codable {
    case fullPublicDomain = "FULL_PUBLIC_DOMAIN"
    case none = "NONE"
    case sample = "SAMPLE"
}

enum Country: String, Codable {
    case mm = "MM"
}

// MARK: - Epub
struct Epub: Codable {
    let isAvailable: Bool?
    let acsTokenLink: String?
    let downloadLink: String?
}

// MARK: - PDF
struct PDF: Codable {
    let isAvailable: Bool?
    let acsTokenLink: String?
}

enum TextToSpeechPermission: String, Codable {
    case allowed = "ALLOWED"
}

enum Viewability: String, Codable {
    case allPages = "ALL_PAGES"
    case noPages = "NO_PAGES"
    case partial = "PARTIAL"
}

enum Kind: String, Codable {
    case booksVolume = "books#volume"
}

// MARK: - SaleInfo
struct SaleInfo: Codable {
    let country: Country?
    let saleability: Saleability?
    let isEbook: Bool?
    let buyLink: String?
}

enum Saleability: String, Codable {
    case free = "FREE"
    case notForSale = "NOT_FOR_SALE"
}

// MARK: - SearchInfo
struct SearchInfo: Codable {
    let textSnippet: String?
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title, subtitle: String?
    let authors: [String]?
    let publisher, publishedDate, volumeInfoDescription: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let readingModes: ReadingModes?
    let pageCount: Int?
    let printType: String?
    let categories: [String]?
    let maturityRating: MaturityRating?
    let allowAnonLogging: Bool?
    let contentVersion: String?
    let panelizationSummary: PanelizationSummary?
    let imageLinks: ImageLinks?
    let language: Language?
    let previewLink: String?
    let infoLink: String?
    let canonicalVolumeLink: String?
    let averageRating, ratingsCount: Int?

    enum CodingKeys: String, CodingKey {
        case title, subtitle, authors, publisher, publishedDate
        case volumeInfoDescription = "description"
        case industryIdentifiers, readingModes, pageCount, printType, categories, maturityRating, allowAnonLogging, contentVersion, panelizationSummary, imageLinks, language, previewLink, infoLink, canonicalVolumeLink, averageRating, ratingsCount
    }
    
    func toBookVO()-> Book{
        var authorsList = ""
        if let authors = authors {
            authorsList = authors.joined(separator: ",")
        }

        return Book(ageGroup: "", amazonProductURL: "", articleChapterLink: canonicalVolumeLink, author: authorsList, bookImage: imageLinks?.smallThumbnail, bookImageWidth: 0, bookImageHeight: 0, bookReviewLink: "", contributor: "", contributorNote: "", createdDate: "", bookDescription: volumeInfoDescription, firstChapterLink: "", price: "", primaryIsbn10:industryIdentifiers?.first?.identifier, primaryIsbn13: "", bookURI: "", publisher: publisher, rank: 0, rankLastWeek: 0, sundayReviewLink: "", title: title, updatedDate: "", weeksOnList: 0, buyLinks: [])
    }
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String?
}

// MARK: - IndustryIdentifier
struct IndustryIdentifier: Codable {
    let type: String?
    let identifier: String?
}

enum TypeEnum: String, Codable {
    case isbn10 = "ISBN_10"
    case isbn13 = "ISBN_13"
    case other = "OTHER"
}

enum Language: String, Codable {
    case en = "en"
}

enum MaturityRating: String, Codable {
    case notMature = "NOT_MATURE"
}

// MARK: - PanelizationSummary
struct PanelizationSummary: Codable {
    let containsEpubBubbles, containsImageBubbles: Bool?
}

enum PrintType: String, Codable {
    case book = "BOOK"
}

// MARK: - ReadingModes
struct ReadingModes: Codable {
    let text, image: Bool?
}
