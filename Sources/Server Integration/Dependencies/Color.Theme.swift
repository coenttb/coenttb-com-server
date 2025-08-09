//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 20/03/2025.
//

import CoenttbHTML

extension HTMLColor.Theme {
    package static var coenttb: Self {
        var theme: HTMLColor.Theme = .default
        theme.branding.primary = .green550.withDarkColor(.green600)
        theme.branding.accent = .green850
        theme.text.link = .green550.withDarkColor(.green600)
        theme.background.secondary = .offWhite.withDarkColor(.offBlack)
        theme.text.button = theme.text.primary.reverse()
        theme.background.button = theme.branding.primary

        return theme
    }
}

extension HTMLColor.Theme {
    package static var tenThijeBoonkkamp: Self {
        var theme: HTMLColor.Theme = .coenttb
        theme.branding.primary = .purple550.withDarkColor(.purple600)
        theme.branding.accent = .purple850
        theme.text.link = .purple550.withDarkColor(.purple600)
        theme.background.secondary = .offWhite.withDarkColor(.offBlack)
        theme.text.button = theme.text.primary.reverse()
        theme.background.button = theme.branding.primary
        
        return theme
    }
}
