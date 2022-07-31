//
//  ViewExtensions.swift
//  LibraryApp
//
//  Created by KC on 13/06/2022.
//

import Foundation
import UIKit

//MARK: UICollectionViewCell Extension
extension UICollectionViewCell{
    static var identifier: String{
        String(describing: self)
    }
}

extension UICollectionView{
    func registerForCell(identifier:String){
        register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueCell<T:UICollectionViewCell>(identifier:String, indexPath: IndexPath)->T{
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else{
            return UICollectionViewCell() as! T
        }
        return cell
    }
}


//MARK: - UITableViewCell Extension
extension UITableViewCell{
    static var identifier: String{
        String(describing: self)
    }
}

extension UITableView{
    func registerForCell(identifier:String){
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeueCell<T:UITableViewCell>(identifier:String, indexPath:IndexPath)->T{
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else{
            return UITableViewCell() as! T
        }
        return cell
    }
}

extension UITextField {

    func underlined() {

         let border = CALayer()
         let width = CGFloat(3.0)
         border.borderColor = UIColor.red.cgColor
         border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: width)
         border.borderWidth = width
         self.layer.addSublayer(border)
         self.layer.masksToBounds = true

    }
}


extension UIView{
    func addBorderColor(radius:CGFloat, color: CGColor, borderWidth: CGFloat ){
        self.layer.cornerRadius = radius
        self.layer.borderColor = color
        self.layer.borderWidth = borderWidth
    }
}

extension String {
    func trimingLeadingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
            return self
        }

        return String(self[index...])
    }
}

extension UIViewController{
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: false)
    }
    
    func backOne() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: false)
    }
    
   
    
}
