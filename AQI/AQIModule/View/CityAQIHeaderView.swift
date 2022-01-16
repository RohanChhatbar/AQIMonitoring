//
//  CityAQIHeaderView.swift
//  AQI
//
//  Created by Rohan Chhatbar on 15/01/22.
//

import UIKit

class CityAQIHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier: String = String(describing: self)
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
}
