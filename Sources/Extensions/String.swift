//
//  String.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/16/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

extension String {
    /// Localizes the content based on the Device locale
    ///
    /// - Parameter withComment: The comment for more detail
    /// - Returns: A localized string or the content in case the term not present in the Localizeble.string
    func localized(withComment: String? = nil) -> String {
        return NSLocalizedString(self,
                                 tableName: nil,
                                 comment: withComment ?? "")
    }
}
