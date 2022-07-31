//
//  BookObject.swift
//  LibraryApp
//
//  Created by KC on 16/06/2022.
//

import Foundation
import RealmSwift

class BookObject : Object {
    @Persisted
    var ageGroup: String?
    @Persisted
    var amazonProductURL: String?
    @Persisted
    var articleChapterLink: String?
    @Persisted
    var author: String?
    @Persisted
    var bookImage: String?
    @Persisted
    var bookImageWidth: Int?
    @Persisted
    var bookImageHeight: Int?
    @Persisted
    var bookReviewLink: String?
    @Persisted
    var contributor: String?
    @Persisted
    var contributorNote: String?
    @Persisted
    var createdDate: String?
    @Persisted
    var bookDescription: String?
    @Persisted
    var firstChapterLink: String?
    @Persisted
    var price: String?
    @Persisted(primaryKey: true)
    var primaryIsbn10: String?
    @Persisted
    var primaryIsbn13: String?
    @Persisted
    var bookURI: String?
    @Persisted
    var publisher: String?
    @Persisted
    var rankLastWeek: Int?
    @Persisted
    var rank: Int?
    @Persisted
    var sundayReviewLink: String?
    @Persisted
    var title: String?
    @Persisted
    var updatedDate: String?
    @Persisted
    var weeksOnList: Int?
    @Persisted
    var buyLinks: List<BuyLinkObject>
    
  
    func toBook()-> Book  {
        let buyLinkList: [BuyLink] = buyLinks.map{
            $0.toBuyLink()
        }
        
        
        return Book(ageGroup: ageGroup, amazonProductURL: amazonProductURL, articleChapterLink: articleChapterLink, author: author, bookImage: bookImage, bookImageWidth: bookImageWidth, bookImageHeight: bookImageHeight, bookReviewLink: bookReviewLink, contributor: contributor, contributorNote: contributorNote, createdDate: createdDate, bookDescription: bookDescription, firstChapterLink: firstChapterLink, price: price, primaryIsbn10: primaryIsbn10, primaryIsbn13: primaryIsbn13, bookURI: bookURI, publisher: publisher, rank: rank, rankLastWeek: rankLastWeek, sundayReviewLink: sundayReviewLink, title: title, updatedDate: updatedDate, weeksOnList: weeksOnList, buyLinks: buyLinkList)
    }
}
