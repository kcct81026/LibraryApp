//
//  ShelvesListObject.swift
//  LibraryApp
//
//  Created by KC on 25/06/2022.
//

import Foundation
import RealmSwift

class ShelfIdObject : Object {
    
    @Persisted(primaryKey: true)
    var id : UUID
    
    @Persisted
    var bookId: String
    
    @Persisted
    var shelfId : String?
    
//    func toSpendingRecord() -> SpendingRecord{
//        guard let category = category?.toSpendingCategory() else {
//            fatalError("A spending record must have a spening cateory")
//        }
//
//
//        return SpendingRecord(
//            id: id.uuidString,
//            dateTime: dateTime ?? Date(),
//            category: category,
//            createdAt: createdAt,
//            amount: amount,
//            notes: notes
//        )
//    }
    
  
}
