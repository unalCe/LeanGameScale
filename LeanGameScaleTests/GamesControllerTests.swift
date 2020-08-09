//
//  GamesControllerTests.swift
//  LeanGameScaleTests
//
//  Created by Unal Celik on 9.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import XCTest
@testable import LeanGameScale

class GamesControllerTests: XCTestCase {

    var gamesViewModel: GamesViewModel!
    var gamesController: MockGameViewController!
    var service: MockServiceManager!
    
    override func setUp() {
        service = MockServiceManager()
        gamesViewModel = GamesViewModel(service: service)
        gamesController = MockGameViewController()
        gamesViewModel.delegate = gamesController
    }

    func testFetchGames() throws {
        /// Given
        let allGames = try MockDataLoader.loadGamesResult()
        service.gamesResult = allGames
        
        /// When
        gamesViewModel.fetchAllGames()
        
        /// Then
        XCTAssertEqual(allGames.results.count, gamesViewModel.games.count, "Fetched game count should be equal for the first fetch")
        
        var states = gamesController.states
        XCTAssertEqual(states.removeFirst(), .isLoadingData(true))
        XCTAssertEqual(states.removeFirst(), .isLoadingData(false))
        XCTAssertEqual(states.removeFirst(), .dataReady)
        
        XCTAssertTrue(states.isEmpty, "There should be no more state / Errors")
    }
    
    func testSearchGames() throws {
        /// Given
        let searchedGames = try MockDataLoader.loadGamesResult()
        service.gamesResult = searchedGames
        
        let searchKeyword = "GTAV"
        
        /// When
        gamesViewModel.searchGames(with: searchKeyword)
        
        /// Then
        XCTAssertEqual(searchedGames.results.count, gamesViewModel.games.count, "Fetched game count should be equal search results")
        
        var states = gamesController.states
        XCTAssertEqual(states.removeFirst(), .isLoadingData(true))
        XCTAssertEqual(states.removeFirst(), .isLoadingData(false))
        XCTAssertEqual(states.removeFirst(), .dataReady)
        
        XCTAssertTrue(states.isEmpty, "There should be no more state / Errors")
        
        XCTAssertEqual(gamesViewModel.lastSearchedKeyword, searchKeyword)
        XCTAssertTrue(gamesViewModel.isSearching)
    }
    
    func testPagination() throws {
        /// Given
        let fetchedGames = try MockDataLoader.loadGamesResult()
        service.gamesResult = fetchedGames
        
        let fetchMoreCount = 3
        
        /// When
        gamesViewModel.fetchAllGames()  // ViewController starts with calling this method
        let initialFetchedGameCount = gamesViewModel.games.count
        
        for _ in 1...fetchMoreCount {
            gamesViewModel.fetchMoreForNewPage()
        }
        
        /// Then
        XCTAssertEqual(gamesController.states.first, .isLoadingData(true))
        XCTAssertEqual(gamesController.states.last, .dataReady)
        
        XCTAssertEqual(gamesViewModel.games.count, (fetchedGames.results.count) * fetchMoreCount + initialFetchedGameCount,
                       "View model should hold all games that is fetched for new page")
        
        /// Then When -- Started searching
        let notSearchingGameCountBeforeSearchStarts = fetchedGames.results.count * fetchMoreCount + initialFetchedGameCount
        gamesViewModel.searchGames(with: "keyword")
        
        /// Then
        var states = gamesController.states
        XCTAssertEqual(states.popLast(), .dataReady)    // These should be last three states in reversed order.
        XCTAssertEqual(states.popLast(), .isLoadingData(false))
        XCTAssertEqual(states.popLast(), .isLoadingData(true))
        
        XCTAssertTrue(gamesViewModel.isSearching)
        XCTAssertEqual(gamesViewModel.games.count, fetchedGames.results.count)
        
        /// Then When -- Fetch more page when searching
        gamesViewModel.fetchMoreForNewPage()
        
        /// Then
        XCTAssertTrue(gamesViewModel.isSearching, "GamesViewModel still should be searching.")
        XCTAssertEqual(gamesViewModel.games.count, fetchedGames.results.count * 2) // One search and one more pagination
        
        
        /// Then When - User stops searching
        gamesViewModel.fetchAllGames()
        
        /// Then
        XCTAssertFalse(gamesViewModel.isSearching, "GamesViewModel should not be searching anymore.")
        XCTAssertEqual(gamesViewModel.games.count, notSearchingGameCountBeforeSearchStarts + fetchedGames.results.count) // One more fetch made
        
    }
}
