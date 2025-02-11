//
//  String+currentDate.swift
//  Todo_app
//
//  Created by Almaz  on 09.02.2025.
//

import Foundation

extension String {
    public func getCurrentDate(date: Date) -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}
