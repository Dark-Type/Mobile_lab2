//
//  Progress.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

public struct Progress: Codable {
    public let id: Int
    public let documentId: String
    public let value: Int
    public  let createdAt: String
    public let updatedAt: String
    public let publishedAt: String
    public let chapterId: Int
}
