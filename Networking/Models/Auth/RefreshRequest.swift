//
//  RefreshRequest.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

public struct RefreshRequest: Codable {
    public init (_ identifier: String, _ password: String){
        self.identifier = identifier
        self.password = password
    }
    let identifier: String
    let password: String
}
