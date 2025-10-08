//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 04/09/2024.
//

import CoenttbHTML
import Foundation

package var x_com_light_background: some HTML {
    div {}
        .height(.px(500))
        .width(.px(1500))
        .gradient(bottom: .background.primary, middle: .gradientMidpoint(from: .background.primary, to: .branding.accent)!, top: .branding.accent)
}
