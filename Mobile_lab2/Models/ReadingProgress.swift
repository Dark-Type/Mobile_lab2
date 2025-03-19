//
//  ReadingProgress.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//


import Foundation

struct ReadingProgress {
    let bookId: UUID
    var currentChapter: Int
    var currentPosition: Double 
    var overallProgress: Double
    var lastReadDate: Date
}
