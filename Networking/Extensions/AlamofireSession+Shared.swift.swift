//
//  AlamofireSession+Shared.swift.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

import Foundation
internal import Alamofire

extension Session {
    static let shared: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 70
        configuration.timeoutIntervalForResource = 70

        return Session(configuration: configuration)
    }()
}
