//
//  BottomSheetDelegate.swift
//  LibraryApp
//
//  Created by KC on 15/06/2022.
//

import Foundation
import UIKit

protocol BottomSheetDelegate : AnyObject{
    func onTapBottomSheet(id: String)
}

protocol OnTapMoreDelegate : AnyObject{
    func onTapMore(type: String, name: String)
}

protocol OnTapSearchDelegate : AnyObject {
    func onTapSearch()
}

protocol onTapDetailDelegate : AnyObject{
    func onTapDetail(id: String)
}

protocol OnSetCommentCount : AnyObject{
    func onSetCommentCount(count: Int)
}

protocol OnTapSortAndGird : AnyObject{
    func onTapSortAndGrid(sorting: Bool)
}

protocol OnTapBookShelfItem : AnyObject {
    func onTapBookShelfItem(id: String, name: String)
}

