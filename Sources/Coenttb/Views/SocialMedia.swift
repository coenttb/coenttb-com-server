//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 04/09/2024.
//

import CoenttbHTML
import Foundation

public var x_com_light_background: some HTML {
    div()
        .height(500.px)
        .width(1500.px)
        .gradient(bottom: .white.withDarkColor(.black), middle: .gradientMidpoint(from: .white.withDarkColor(.black), to: .coenttbAccentColor)!, top: .coenttbAccentColor)

}
