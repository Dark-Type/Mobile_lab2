//
//  Author.swift
//  Mobile_lab2
//
//  Created by dark type on 19.03.2025.
//

import SwiftUI

struct Author: Identifiable {
    let name: String
    let image: Image
    let id: String = UUID().uuidString
    init(_ name: String,_ image: Image) {
        self.name = name
        self.image = image
    }
}
