//
//  UIImage + ApplicationImage.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//

import UIKit

// MARK: - All images used in project
extension UIImage {
    
    public enum ApplicationImages: String {
        case errorImage = "errorImage"
        case magnifyingglass = "magnifyingglass"
    }

    public convenience init?(_ image: ApplicationImages) {
        self.init(named: image.rawValue)
    }

}
