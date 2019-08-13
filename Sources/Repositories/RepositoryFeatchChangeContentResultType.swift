//
//  RepositoryFeatchChangeContentResultType.swift
//  Podcast
//
//  Created by Gustavo on 2019-08-13.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import Foundation

typealias RepositoryFeatchChangeContentResultType = (_ insertItems: [IndexPath]?,
    _ deleteItems: [IndexPath]?,
    _ reloadItems: [IndexPath]?) -> Void
