//
//  Enums.swift
//  LibraryApp
//
//  Created by KC on 23/06/2022.
//

import Foundation

enum SortingLibrary: String {
    case recent = "insertedAt"
    case title = "title"
    case author = "author"
}

enum ViewGrid: String {
    case list = "List"
    case large = "Large grid"
    case small = "Small grid"
}

enum TapBooksAndShelves : String {
    case book = "book"
    case shelf = "shelf"
}

enum LibraryVCSectionType{
    case SearchBook
    case TabTableView
    case SortingAndGrid
    case WishListBookList
    case ShelvesList
}


enum HomeViewControllerSectionType{
    case SearchBook
    case BookListSlider
    case TabTableView
    case CategoryList
}

  
