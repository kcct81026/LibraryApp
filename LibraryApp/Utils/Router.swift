//
//  Router.swift
//  LibraryApp
//
//  Created by KC on 17/06/2022.
//
import Foundation
import UIKit

enum StoryBoardName: String{
    case Main = "Main"
    case LaunchScreen = "LaunchScreen"
}

extension UIStoryboard{
    static func mainStoryBoard()-> UIStoryboard{
        UIStoryboard(name: StoryBoardName.Main.rawValue, bundle: nil)
    }
}

extension UIViewController{
    
    
    func navigateToMoreBookController(type: String, name: String){
        let vc = MoreBooksViewController(type:type,categoryName: name)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateHomeToBottomSheetController(id: String){
        let vc = SelectLayoutSheetViewController(id: id)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.hidesBottomBarWhenPushed = true
        //self.present(vc, animated: true)
        self.tabBarController?.present(vc, animated: true)


    }
    
    func navigateToDeailController(id: String){
        let vc = BookDetailViewController(id: id)
        vc.hidesBottomBarWhenPushed = true
        if let currentNavController = self.navigationController {
            currentNavController.pushViewController(vc, animated: true)
        }
        else if let parentNavController = self.presentingViewController as? UINavigationController {
            parentNavController.pushViewController(vc, animated: true)
        }
        else if let bottomNavController = self.presentingViewController as? UITabBarController,
                let parentNavController = bottomNavController.selectedViewController as? UINavigationController {
                parentNavController.pushViewController(vc, animated: true)
        }
        else{
            self.present(vc, animated: true)

        }
    }
    
    func navigateSortingAndGridController(sorting: Bool, onViewOptionUpdated : ((Bool) -> Void)? ){
        let vc = SortingBottomViewController(sorting: sorting)
        vc.onViewOptionUpdated = onViewOptionUpdated
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.hidesBottomBarWhenPushed = true
        self.present(vc, animated: true)
        
        

    }
    
    
    func navigateShelfBottomViewController(id: String){
        let vc = ShlefBottomDialogController(id: id)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.hidesBottomBarWhenPushed = true
        vc.onShelfDeleted = {
            self.navigationController?.viewControllers = self.navigationController?.viewControllers.filter{!($0 is ShelfItemViewController)} ?? [UIViewController]()
        }
        vc.onShelfEdited = {
            self.navigationController?.viewControllers = self.navigationController?.viewControllers.filter{!($0 is ShelfItemViewController)} ?? [UIViewController]()
        }
        self.present(vc, animated: true)

    }
    
    func navigateToShelfItemViewController(id: String, name: String){
        let vc = ShelfItemViewController(id: id, name: name)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    
    func navigateCreateShelfController(id:String="", shelfName: String = ""){
        let vc = CreateShelfViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.id = id
        vc.shelfName = shelfName
       // self.navigationController?.pushViewController(vc, animated: false)
        if let currentNavController = self.navigationController {
            currentNavController.pushViewController(vc, animated: true)
        }
        else if let parentNavController = self.presentingViewController as? UINavigationController {
            parentNavController.pushViewController(vc, animated: true)
        }
        else if let bottomNavController = self.presentingViewController as? UITabBarController,
                let parentNavController = bottomNavController.selectedViewController as? UINavigationController {
                parentNavController.pushViewController(vc, animated: true)
        }

        else{
            self.present(vc, animated: true)

        }

    }
    
    
    
    
    func navigateShelfListViewController(id: String){
        let vc = ShelfListController()
        vc.id = id
        vc.hidesBottomBarWhenPushed = true
        if let currentNavController = self.navigationController {
            currentNavController.pushViewController(vc, animated: true)
        }
        else if let parentNavController = self.presentingViewController as? UINavigationController {
            parentNavController.pushViewController(vc, animated: true)
        }
        else if let bottomNavController = self.presentingViewController as? UITabBarController,
                let parentNavController = bottomNavController.selectedViewController as? UINavigationController {
                parentNavController.pushViewController(vc, animated: true)
        }

        else{
            self.present(vc, animated: true)

        }
    }
    
    
    
    func navigateToSearchBooks(){
        let vc = SearchBookViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    

    func navigateToRatingController(id: String){
        let vc = ReviewsViewController()
        vc.id = id
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToBookDescriptionController(book: Book){
        let vc = BookDescriptionViewController()
        vc.book = book
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
   
}

