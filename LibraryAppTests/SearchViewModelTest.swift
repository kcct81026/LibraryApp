//
//  SearchViewModelTest.swift
//  LibraryAppTests
//
//  Created by KC on 04/07/2022.
//

import XCTest
@testable import LibraryApp
import Combine
import RxSwift


class SearchViewModelTest: XCTestCase {
    
    var viewModel : SearchViewModel!
    var networkAgent : MockRxNetworkAgent!
    var disposeBag : DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkAgent = MockRxNetworkAgent()
        viewModel = SearchViewModel(networkAgent: networkAgent)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkAgent = nil
        viewModel = nil
        disposeBag = nil
    }
    
    func test_viewModelInitState_withInitailzation_returnsCorrectData() throws{
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.itemSpacing, 10)
        XCTAssertEqual(viewModel.numberOfItemsPerRow, 1)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.totalPage, 1)
    }
    
    func test_handlePagination_withIndexPathAndSearchBook_currentPageShouldIncrement() throws{
        let indexPath = IndexPath(row: 0, section: 0)
        
        // Prepare Data
        
        viewModel.searchResultItems.onNext([SearchBookResult.dummy()])
        viewModel.currentPage = 1
        viewModel.totalPage = 2
        
        // Trigger target method
        viewModel.handlePaganation(index: indexPath, searchText: "abc")
        
        //Assertion
        XCTAssertEqual(viewModel.currentPage, 2)
    }
    
    
    func test_handleSearchInputText_withTextEmpty_dataShouldReset() throws{
        viewModel.handleSearchInputText(text: "")
        
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.totalPage, 1)
        
        let waitExpectation = expectation(description: "wait for response")
        viewModel.searchResultItems
            .subscribe(onNext: { (data) in
                XCTAssertEqual(data.count, 0)
                waitExpectation.fulfill()
            }).disposed(by: disposeBag)
        wait(for: [waitExpectation], timeout: 5)
    }
    
    func test_searchMovies_withSimpleData_shouldItems() throws{
        viewModel.handleSearchInputText(text: "test")
       
        
        let waitExpectation = expectation(description: "wait for response")
        viewModel.searchResultItems
            .subscribe(onNext: { [weak self](data) in
                guard let self = self else { return }
                XCTAssertEqual(self.viewModel.totalPage, 547)
                XCTAssertGreaterThan(data.count, 0)
                waitExpectation.fulfill()
            }).disposed(by: disposeBag)
        wait(for: [waitExpectation], timeout: 5)
    }


   

}


