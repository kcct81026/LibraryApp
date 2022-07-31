//
//  LibraryEndPoint.swift
//  LibraryApp
//
//  Created by KC on 15/06/2022.
//

import Foundation
import Alamofire


enum LibraryEndPoint : URLConvertible, URLRequestConvertible{
    case overview
    case morebooks(_ type: String, _ offset: Int)

    
    private var baseURL : String{
        return AppConstants.BASEURL
    }

    func asURL() throws -> URL {
        return url
    }
    
    func asURLRequest() throws -> URLRequest {

        let request = URLRequest(url: try asURL())
        return request
    }

    var url: URL{
        let urlComponents = NSURLComponents(
            string: baseURL.appending(apiPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? apiPath)
        )
        if (urlComponents?.queryItems == nil){
            urlComponents!.queryItems = []
        }
        
        urlComponents!.queryItems!.append(contentsOf: [URLQueryItem(name: "api-key", value: AppConstants.api_key)])
    
        return urlComponents!.url!
    }
    
    private var apiPath : String{
        switch self{
        case .overview :
            return "/lists/overview.json"
        case .morebooks(let type, let offset):
            return "/lists.json?list=\(type)&offset=\(offset)"
        
        }
    }
    
}

