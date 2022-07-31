//
//  LibraryMockData.swift
//  LibraryAppTests
//
//  Created by KC on 04/07/2022.
//

import Foundation
import UIKit
@testable import LibraryApp


public final class LibraryMockData {
    
    class SearchBooksResult {
        public static let searchResultJSONUrl: URL = Bundle(for: LibraryMockData.self).url(forResource: "search-book", withExtension: "json")!
    }
    
    class BookCategoryResult{
        public static let bookCategoryResultJSONUrl : URL = Bundle(for: LibraryMockData.self).url(forResource: "book-list", withExtension: "json")!
    }
    
    static func getDummy(authors: [String]) -> VolumeInfo{
        return VolumeInfo(title: "The Plant Information Network", subtitle: "", authors: authors , publisher: "", publishedDate: "", volumeInfoDescription: "", industryIdentifiers: nil, readingModes: nil, pageCount: 124, printType: "", categories: nil, maturityRating: nil, allowAnonLogging: false, contentVersion: "", panelizationSummary: nil, imageLinks: nil, language: nil, previewLink: "", infoLink: "", canonicalVolumeLink: "", averageRating: 2, ratingsCount: 4)
    }
    

    
}
