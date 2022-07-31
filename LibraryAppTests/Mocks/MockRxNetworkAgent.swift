//
//  MockRxNetworkAgent.swift
//  LibraryAppTests
//
//  Created by KC on 04/07/2022.
//

import Foundation
@testable import LibraryApp
import RxSwift

class MockRxNetworkAgent : RxNetworkAgentProtocol {
    func getOverViewList() -> Observable<BookListResponse> {
        return Observable.empty()
    }
    
    func getMoreBookList(type: String, offset: Int) -> Observable<CategoryResponse> {
       return Observable.empty()
    }
    
    func getSearchBookResult(query: String, page: Int) -> Observable<SearchBookResponse> {
        let mockedDataFromJSON = try! Data(contentsOf: LibraryMockData.SearchBooksResult.searchResultJSONUrl)
        let responseData = try! JSONDecoder().decode(SearchBookResponse.self, from: mockedDataFromJSON)
        return Observable.just(responseData)
    }
    
    
}


