//
//  AppIcon.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//


import SwiftUI

enum AppIcons: String {
    case arrowLeft = "ArrowLeft"
    case bookmarks = "Bookmarks"
    case close = "Close"
    case contents = "Contents"
    case eyeOff = "EyeOff"
    case eyeOn = "EyeOn"
    case history = "History"
    case library = "Library"
    case logout = "Logout"
    case next = "Next"
    case pause = "Pause"
    case play = "Play"
    case previous = "Previous"
    case read = "Read"
    case readingNow = "ReadingNow"
    case search = "Search"
    case settings = "Settings"
    
    var image: Image {
        Image(self.rawValue)
    }
}
enum MockBooks: String {
    case book1 = "Book_1"
    case book2 = "Book_2"
    case book3 = "Book_3"
    var image: Image {
        Image(self.rawValue)
    }
}
enum MockPosters: String {
    case poster1 = "Poster_1"
    case poster4 = "Poster_4"
    var image : Image {
        Image(self.rawValue)
    }
}
