//
//  Chapter.swift
//  Mobile_lab2
//
//  Created by dark type on 02.07.2025.
//

public struct ChapterDTO: Codable {
    public  let id: Int
    public let documentId: String
    public let text: String
    public  let title: String
    public  let order: Int
    public  let createdAt: String
    public  let updatedAt: String
    public  let publishedAt: String
}
