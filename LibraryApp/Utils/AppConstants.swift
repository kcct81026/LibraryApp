//
//  AppConstants.swift
//  LibraryApp
//
//  Created by KC on 13/06/2022.
//

import Foundation

struct AppConstants{
    static let api_key = "5A0pIhT5rLU1FUoUNaSBYjZqTlp6WQqO"
    static let BASEURL = "https://api.nytimes.com/svc/books/v3"
    
    // recently open list carousel
    // categort selection cell
    // horizontal books list cell
    
    
    // best seller
    //https://api.nytimes.com/svc/books/v3/lists/best-sellers/history.json
    
    //https://api.nytimes.com/svc/books/v3/lists/{date}/{list}.json
    
    //full over view
    //https://api.nytimes.com/svc/books/v3/lists/full-overview.json
    
    //https://api.nytimes.com/svc/books/v3/lists/names.json
    
    //overivew
    //https://api.nytimes.com/svc/books/v3/lists/overview.json
    
    //review
    //https://api.nytimes.com/svc/books/v3/reviews.json
    
    // "isbn10": "0399178570",
    //"isbn13": "9780399178573"
}

extension String {

    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
