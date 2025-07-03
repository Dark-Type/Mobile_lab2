//
//  Pagination.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

public struct Pagination: Codable {
    public let page: Int
    public let pageSize: Int
    public let pageCount: Int
    public  let total: Int
}
