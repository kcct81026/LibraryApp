//
//  BuyLinkObject.swift
//  LibraryApp
//
//  Created by KC on 15/06/2022.
//

import Foundation
import RealmSwift

class BuyLinkObject: Object {
    
    
    @Persisted(primaryKey: true)
    var id: String?
    
    @Persisted
    var name: String?
    
    @Persisted
    var url: String?
    
    func toBuyLink() -> BuyLink{
        return BuyLink(name: name, url: url)
    }
}
