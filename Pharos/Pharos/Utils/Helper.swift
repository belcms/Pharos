//
//  Helper.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 20/02/26.
//

import SwiftUI

extension Duration {
    var asTimeInterval : TimeInterval {
        TimeInterval(self.components.seconds)
    }
}

extension TimeInterval {
    var asDuration : Duration {
        .seconds(self)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
