//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 20/03/2025.
//

import Foundation
import CoenttbHTML

extension HTMLColor.Defaults {
    package static var coenttb: Self {
        var color: HTMLColor.Defaults = .liveValue
        color.branding.primary = .green550.withDarkColor(.green600)
        color.branding.accent = .green850
        color.text.link = .green550.withDarkColor(.green600)
        color.background.secondary = .offWhite.withDarkColor(.offBlack)
        
        return color
    }
}
