//
//  VolumeInfoTests.swift
//  LibraryAppTests
//
//  Created by KC on 09/07/2022.
//

import XCTest
@testable import LibraryApp

class VolumeInfoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   
    
    func test_toBookVO_hasTwoAuthors_returnAuthorListString() throws{
        let authors =  [
            "Kimery C. Vories",
           "Phillip L. Sims"
        ]
        let volumeInfo : VolumeInfo = LibraryMockData.getDummy(authors: authors)
        let book : Book = volumeInfo.toBookVO()
        XCTAssertEqual(book.author,"Kimery C. Vories,Phillip L. Sims")
    }
  
    func test_toBookVO_authorsIsEmpty_returnAuthorListEmptyString() throws{
       
        let volumeInfo : VolumeInfo = LibraryMockData.getDummy(authors: [])
        let book : Book = volumeInfo.toBookVO()
        XCTAssertEqual(book.author,"")
    }
  

}

