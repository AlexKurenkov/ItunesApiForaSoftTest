//
//  String + DateFormatter.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//

import Foundation


extension String {
    
    func formatted() -> String {
        let responseDateFormatter = DateFormatter()
        responseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let responseDate = responseDateFormatter.date(from: self)
        
        guard let date = responseDate else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        return dateFormatter.string(from: date)
    }
}
