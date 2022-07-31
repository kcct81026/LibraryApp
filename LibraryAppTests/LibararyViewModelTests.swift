//
//  LibararyViewModelTests.swift
//  LibraryAppTests
//
//  Created by KC on 06/07/2022.
//

import XCTest
@testable import LibraryApp
import RxSwift
import Combine



class LibararyViewModelTests: XCTestCase {
    private var cancelables: Set<AnyCancellable> = Set()
    var libraryModel : MockLibraryModel!
    var viewModel : LibraryViewModel!
    var disposeBag : DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        libraryModel = MockLibraryModel()
        viewModel = LibraryViewModel(libraryModel: libraryModel)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        libraryModel = nil
        viewModel = nil
        disposeBag = nil
        
    }
    
    func test_viewModelInitState_withInitailzation_returnsCorrectData() throws{
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.bookSortingList.count, 0)
    }
    
    

    
    func test_getWishListBookList_ReturnsSavedWishList_CountTotalTwo() throws{
        let waitExpectation = expectation(description: "wait for response")
        viewModel.viewState
            .sink{ resultState in
                if case .sendBookData = resultState{
                    XCTAssertEqual(self.viewModel.bookSortingList.count, 2)
                    waitExpectation.fulfill()
                }
            }.store(in: &cancelables)

        viewModel.getWishListBooks()

        wait(for: [waitExpectation], timeout: 1)

    }
    
    func test_getWishListBookList_ReturnsNoWishListBooks() throws{
        let waitExpectation = expectation(description: "wait for response")
        viewModel.viewState
            .sink{ resultState in
                if case .sendBookData = resultState{
                    XCTAssertEqual(self.viewModel.bookSortingList.count, 0)
                    waitExpectation.fulfill()
                }
            }.store(in: &cancelables)

        libraryModel.noWishlistBook = true
        viewModel.getWishListBooks()

        wait(for: [waitExpectation], timeout: 1)

    }
    
    func test_getShelvesList_ReturnsNoShelvesList() throws{
        let waitExpectation = expectation(description: "wait for response")
        viewModel.viewState
            .sink{ resultState in
                if case .sendShelvesData = resultState{
                    XCTAssertEqual(self.viewModel.shelvesList.count, 0)
                    waitExpectation.fulfill()
                }
            }.store(in: &cancelables)

        libraryModel.noShlefList = true
        viewModel.getShelvesList()

        wait(for: [waitExpectation], timeout: 1)

    }
    
    func test_getShlevesList_ReturnsSavedShelves_CountTotalTwo() throws{
        let waitExpectation = expectation(description: "wait for response")
        viewModel.viewState
            .sink{ resultState in
                if case .sendShelvesData = resultState{
                    XCTAssertEqual(self.viewModel.shelvesList.count, 2)
                    waitExpectation.fulfill()
                }
            }.store(in: &cancelables)

        viewModel.getShelvesList()

        wait(for: [waitExpectation], timeout: 1)

    }
    
    
}
