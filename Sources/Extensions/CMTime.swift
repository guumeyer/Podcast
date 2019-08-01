//
//  CMTime.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/18/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import AVKit

extension CMTime {
    func formartDisplay() -> String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds % 3600 / 60
        let hour = totalSeconds / 60 / 60

        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, minutes, seconds)
        }

        return String(format: "%02d:%02d", minutes, seconds)
    }

}
