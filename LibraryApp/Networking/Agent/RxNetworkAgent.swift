//
//  RxNetworkAgent.swift
//  LibraryApp
//
//  Created by KC on 15/06/2022.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

protocol RxNetworkAgentProtocol  {
   
    func getOverViewList() -> Observable<BookListResponse>
    func getMoreBookList(type: String, offset: Int) -> Observable<CategoryResponse>
    func getSearchBookResult(query: String, page: Int) -> Observable<SearchBookResponse>
}


class RxNetworkAgent : BaseNetworkAgent, RxNetworkAgentProtocol{
    
    static let shared = RxNetworkAgent()
    
    private override init(){
        
    }
    
    func getOverViewList() -> Observable<BookListResponse> {
        RxAlamofire.requestDecodable(LibraryEndPoint.overview)
            .flatMap{ item -> Observable<BookListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getMoreBookList(type: String, offset: Int) -> Observable<CategoryResponse> {
        RxAlamofire.requestDecodable(LibraryEndPoint.morebooks(type, offset))
            .flatMap{ item -> Observable<CategoryResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getSearchBookResult(query: String, page: Int) -> Observable<SearchBookResponse> {
        let realURL = URL( string: "https://www.googleapis.com/books/v1/volumes?q=\(query)&page=\(page)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        
        let url: Alamofire.URLConvertible = realURL ?? ""

        return Observable.create { (observer) -> Disposable in

            AF.request(url)
                .responseDecodable(of: SearchBookResponse.self){ response in
                    switch response.result{
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                }
            }

            return Disposables.create()
        }
    }
    
    
    //https://www.googleapis.com/books/v1/volumes?q=flutter&page=2
    
  
}
