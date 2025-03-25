//
//  AccessibilityIdentifiers.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import Foundation

public enum AccessibilityIdentifiers: String {
    // MARK: Login Screen identifiers

    case emailTextField = "login_email_text_field"
    case passwordTextField = "login_password_text_field"
    case loginButton = "login_button"
    case carouselView = "login_carousel_view"
    case mainView = "main_view_identifier"
    case carouselImage = "carousel_image_"
    case titleFirstLine = "login_title_first_line"
    case titleSecondLine = "login_title_second_line"
    case emailLabel = "login_email_label"
    case passwordLabel = "login_password_label"

    // MARK: Library Screen identifiers

    case libraryScreenView = "library_screen_view"
    case libraryTitle = "library_title"
    case newBooksTitle = "new_books_title"
    case popularBooksTitle = "popular_books_title"
    case booksCarousel = "books_carousel"
    case carouselItem = "carousel_item_"
    case booksGrid = "books_grid"
    case bookCard = "book_card_"
    case emptyCarouselMessage = "empty_carousel_message"
    case emptyGridMessage = "empty_grid_message"

    // MARK: Reading Screen identifiers

    case readingScreen = "reading_screen"
    case bookTitle = "book_title"
    case backButton = "back_button"
    case favoriteButton = "favorite_button"
    case bookPoster = "book_poster"
    case readButton = "read_button"
    case authorName = "author_name"
    case bookDescription = "book_description"
    case readingProgress = "reading_progress"
    case progressBar = "progress_bar"
    case contentsTitle = "contents_title"
    case chapterListItem = "chapter_list_item_"

    // MARK: Chapter Reading Screen identifiers

    case chapterReadingView = "chapter_reading_view"
    case chapterBackButton = "chapter_back_button"
    case chapterTitle = "chapter_title"
    case chapterPreviousButton = "chapter_previous_button"
    case chapterNextButton = "chapter_next_button"
    case chapterContentsButton = "chapter_contents_button"
    case chapterSettingsButton = "chapter_settings_button"
    case chapterPlayButton = "chapter_play_button"

    case paragraphText = "paragraph_text_"

    case settingsOverlay = "settings_overlay"
    case settingsCloseButton = "settings_close_button"
    case settingsTitle = "settings_title"
    case fontSizeLabel = "font_size_label"
    case fontSizeValue = "font_size_value"
    case fontSizeDecreaseButton = "font_size_decrease_button"
    case fontSizeIncreaseButton = "font_size_increase_button"
    case lineSpacingLabel = "line_spacing_label"
    case lineSpacingValue = "line_spacing_value"
    case lineSpacingDecreaseButton = "line_spacing_decrease_button"
    case lineSpacingIncreaseButton = "line_spacing_increase_button"

    case chaptersOverlay = "chapters_overlay"
    case chaptersCloseButton = "chapters_close_button"
    case chaptersDragIndicator = "chapters_drag_indicator"
    case chaptersListView = "chapters_list_view"
    case chaptersTitle = "chapters_title"

    case quoteOverlay = "quote_overlay"
    case quoteTextEditor = "quote_text_editor"
    case quoteDragIndicator = "quote_drag_indicator"
    case quoteScrollView = "quote_scroll_view"
    case quoteRestoreButton = "quote_restore_button"
    case quoteCancelButton = "quote_cancel_button"
    case quoteAddButton = "quote_add_button"

    // MARK: SearchScreen identifiers

    case searchBar = "search_bar"
    case searchTextField = "search_text_field"
    case searchClearButton = "search_clear_button"
    case recentSearchesTitle = "recent_searches_title"
    case recentSearchesList = "recent_searches_list"
    case recentSearchItem = "recent_search_item"
    case genresSectionTitle = "genres_section_title"
    case genresGrid = "genres_grid"
    case genreCard = "genre_card"
    case authorsSectionTitle = "authors_section_title"
    case authorsList = "authors_list"
    case authorCard = "author_card"
    case searchResultsList = "search_results_list"
    case searchResultItem = "search_result_item"
    case emptySearchResultsView = "empty_search_results_view"
    case emptyRecentSearchesView = "empty_recent_searches_view"
    case emptyGenresView = "empty_genres_view"
    case emptyAuthorsView = "empty_authors_view"
    case clearRecentSearchesButton = "clear_recent_searches_button"

    // MARK: Bookmarks Screen

    case bookmarksTitle = "bookmarks_title"
    case currentReadingSection = "current_reading_section"
    case currentReadingSectionTitle = "current_reading_section_title"
    case currentReadingBookItem = "current_reading_book_item"
    case continueReadingButton = "continue_reading_button"
    case favoriteBooksSection = "favorite_books_section"
    case favoriteBooksSectionTitle = "favorite_books_section_title"
    case favoriteBookItem = "favorite_book_item"
    case quotesSection = "quotes_section"
    case quotesSectionTitle = "quotes_section_title"
    case quoteItem = "quote_item"
    case emptyCurrentReadingView = "empty_current_reading_view"
    case emptyFavoriteBooksView = "empty_favorite_books_view"
    case emptyQuotesView = "empty_quotes_view"

    // MARK: Tabbar identifiers

    case libraryTabButton = "library_tab_button"
    case searchTabButton = "search_tab_button"
    case bookmarksTabButton = "bookmarks_tab_button"
}
