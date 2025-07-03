//
//  Author.swift
//  Mobile_lab2
//
//  Created by dark type on 19.03.2025.
//

import Networking
import SwiftUI

public struct Author: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let avatarURL: String
    
    public init(id: String = UUID().uuidString, name: String, avatarURL: String = "") {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
    }
}

