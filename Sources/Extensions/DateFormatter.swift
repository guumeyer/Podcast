//
//  DateFormatter.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

extension DateFormatter {
    private static let rfc822 = "E, d MMM yyyy HH:mm:ss Z"
    
    /// RFC 822 DateFormatter
    @nonobjc static let rfc822Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = rfc822
        return formatter
    }()
    
    /// Short DateFormatter
    @nonobjc static let shortDateAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
