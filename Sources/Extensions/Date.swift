//
//  Date.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

extension Date {
    /// Prints a string representation for the date with the given formatter
    func string(with format: DateFormatter) -> String {
        return format.string(from: self)
    }
    
    /// Creates an `Date` from the given string and formatter. Nil if the string couldn't be parsed
    init?(string: String, formatter: DateFormatter) {
        guard let date = formatter.date(from: string) else { return nil }
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
}
