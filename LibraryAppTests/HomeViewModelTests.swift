//
//  HomeViewModelTests.swift
//  LibraryAppTests
//
//  Created by KC on 04/07/2022.
//

import XCTest
@testable import LibraryApp
import RxSwift
import Combine



class HomeViewModelTests: XCTestCase {
    
    var bookModel : MockBookModel!
    var viewModel : HomeViewModel!
    var disposeBag : DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        bookModel = MockBookModel()
        viewModel = HomeViewModel(bookModel: bookModel)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        bookModel = nil
        viewModel = nil
        disposeBag = nil
        
    }
    
    func test_viewModelInitState_withInitailzation_returnsCorrectData() throws{
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.bookList.count, 0)
    }
    
   
    
    func test_fetchAllBookCategoryItemList_allDataExist_returnsTotalElevenCategory() throws{
        let waitExpectation = expectation(description: "wait for response")
        viewModel.viewState
            .sink{ resultState in
                if case .sendBookList = resultState{
                    waitExpectation.fulfill()
                }
            }.store(in: &cancelables)
            
        viewModel.getEbookList()
       
        wait(for: [waitExpectation], timeout: 1)
        
        
    }
    
    private var cancelables: Set<AnyCancellable> = Set()

    func test_fectAllAudioList_allDataExist_returnAudioList() throws{
        
        let waitExpectation = expectation(description: "wait for response")
        viewModel.viewState
            .sink{ resultState in
                if case .sendAudioBookList = resultState{
                    waitExpectation.fulfill()
                }
            }.store(in: &cancelables)
        
        viewModel.getAudioList()


        wait(for: [waitExpectation], timeout: 1)
            
    }
    
   

   

}
