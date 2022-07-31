//
//  BookExtension.swift
//  LibraryApp
//
//  Created by KC on 16/06/2022.
//

import Foundation
import RealmSwift

extension Book {
    static func toBookObject(book: Book) -> BookObject {
        let object = BookObject()
        object.ageGroup = book.ageGroup
        object.amazonProductURL = book.amazonProductURL
        object.articleChapterLink = book.articleChapterLink
        object.author = book.author
        object.bookImage = book.bookImage
        object.bookImageWidth = book.bookImageWidth
        object.bookImageHeight = book.bookImageHeight
        object.bookReviewLink = book.bookReviewLink
        object.contributor = book.contributor
        object.contributorNote = book.contributorNote
        object.createdDate = book.createdDate
        object.bookDescription = book.bookDescription
        object.firstChapterLink = book.firstChapterLink
        object.price = book.price
        object.primaryIsbn10 = book.primaryIsbn10
        object.primaryIsbn13 = book.primaryIsbn13
        object.bookURI = book.bookURI
        object.publisher = book.publisher
        object.rank = book.rank
        object.rankLastWeek = book.rankLastWeek
        object.sundayReviewLink = book.sundayReviewLink
        object.title = book.title
        object.updatedDate = book.updatedDate
        object.weeksOnList = book.weeksOnList
        let buyLinks = List<BuyLinkObject>()
        book.buyLinks?.forEach{
            if let id = book.primaryIsbn13{
                buyLinks.append(BuyLink.toBuyLinkObject(id: id ,buyLink: $0))
            }
        }
        object.buyLinks = buyLinks
        return object
    }
}

extension BuyLink{
    static func toBuyLinkObject(id: String , buyLink: BuyLink) -> BuyLinkObject{
        let object = BuyLinkObject()
        object.id = id
        object.name = buyLink.name
        object.url = buyLink.url
        return object
    }
}
