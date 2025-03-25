//
//  VisibilityDetector.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import SwiftUI

struct VisibilityDetector: View {
    let onVisible: () -> Void
    var body: some View {
        Color.clear
            .onAppear(perform: onVisible)
    }
}
