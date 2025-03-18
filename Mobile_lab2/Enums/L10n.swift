//
//  L10n.swift
//  Mobile_lab2
//
//  Created by dark type on 18.03.2025.
//

import Foundation

enum L10n {
    /// Login screen localization strings
    enum Login {
        enum Title {
            /// "открой для себя"
            static var first: String {
                return NSLocalizedString("login.title.first", comment: "First part of login title")
            }
            
            /// "книжный"
            static var second: String {
                return NSLocalizedString("login.title.second", comment: "Second part of login title")
            }
            ///  "мир"
            static var third: String {
                return NSLocalizedString("login.title.third", comment: "Third part of login title")
            }
        }
        
        /// "Пароль"
        static var password: String {
            return NSLocalizedString("login.password", comment: "Password field label")
        }
        
        ///  "Почта"
        static var email: String {
            return NSLocalizedString("login.email", comment: "Email field label")
        }
        
        /// "Неверный пароль или почта"
        static var invalidCredentials: String {
            return NSLocalizedString("invalid_credentials", comment: "Invalid credentials error message")
        }
        
        /// "Войти"
        static var button: String {
            return NSLocalizedString("login.button", comment: "Login button text")
        }
    }
    
    /// Library screen localization strings
    enum Library {
        /// "Библиотека"
        static var title: String {
            return NSLocalizedString("library.title", comment: "Library screen title")
        }
        
        /// "Новинки"
        static var new: String {
            return NSLocalizedString("library.new", comment: "New releases section title")
        }
        
        /// "Популярные книги"
        static var popular: String {
            return NSLocalizedString("library.popular", comment: "Popular books section title")
        }
    }
    
    /// Search screen localization strings
    enum Search {
        /// "Поиск по книгам"
        static var searchViewText: String {
            return NSLocalizedString("search.searchview.text", comment: "Search field placeholder")
        }
        
        /// "Недавние запросы" i
        static var recent: String {
            return NSLocalizedString("search.recent", comment: "Recent searches section title")
        }
        
        /// "Жанры"
        static var genres: String {
            return NSLocalizedString("search.genres", comment: "Genres section title")
        }
        
        /// "Авторы"
        static var authors: String {
            return NSLocalizedString("search.authors", comment: "Authors section title")
        }
    }
    
    /// Bookmarks screen localization strings
    enum Bookmarks {
        /// "Закладки"
        static var title: String {
            return NSLocalizedString("bookmarks.title", comment: "Bookmarks screen title")
        }
        
        /// "Читаете сейчас"
        static var current: String {
            return NSLocalizedString("bookmarks.current", comment: "Currently reading section title")
        }
        
        /// "Избранные книги"
        static var favorite: String {
            return NSLocalizedString("bookmarks.favorite", comment: "Favorite books section title")
        }
        
        /// "Цитаты"
        static var quotes: String {
            return NSLocalizedString("bookmarks.quotes", comment: "Quotes section title")
        }
    }
    
    /// Book detail screen localization strings
    enum Book {
        ///  "Читать"
        static var read: String {
            return NSLocalizedString("book.read", comment: "Read button text")
        }
        
        /// "В избранное"
        static var favorites: String {
            return NSLocalizedString("book.favorites", comment: "Add to favorites button text")
        }
        /// "Прочитано"
        static var readBook: String {
            return NSLocalizedString("book.progress", comment: "Title for progress")
        }
        
        
        /// "Оглавление"
        static var contents: String {
            return NSLocalizedString("book.contents", comment: "Contents section title")
        }
        
        ///  "Назад"
        static var goBack: String {
            return NSLocalizedString("book.go.back", comment: "Back button text")
        }
        
        /// Book settings related strings
        enum Settings {
            /// "Настройки"
            static var title: String {
                return NSLocalizedString("book.settings.title", comment: "Settings title")
            }
            
            /// "Размер шрифта"
            static var font: String {
                return NSLocalizedString("book.settings.font", comment: "Font size setting label")
            }
            
            /// "пт"
            static var measure: String {
                return NSLocalizedString("book.settings.measure", comment: "Font size measurement unit")
            }
            
            /// "Расстояние между строками"
            static var padding: String {
                return NSLocalizedString("book.settings.padding", comment: "Line spacing setting label")
            }
        }
    }
}
