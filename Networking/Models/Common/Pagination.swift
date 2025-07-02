//
//  Pagination.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

struct Pagination: Codable {
    let page: Int
    let pageSize: Int
    let pageCount: Int
    let total: Int
}
