//
//  FlickrViewModelTests.swift
//  FlickrSearchTests
//
//  Created by Mrudula on 12/6/24.
//

import XCTest
@testable import FlickrSearch
import Combine
import SwiftData

@MainActor
class FlickrViewModelTests: XCTestCase {
    var viewModel : FlickrViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
            super.setUp()
        cancellables = []
        }
    
    func testAppStartsEmpty() throws {
        let photos = viewModel.photos
        XCTAssertEqual(photos.count, 0, "0 Results")
    }
    
    func testClearCache() throws {
        let photos = viewModel.photos
        viewModel.clearCache()
        XCTAssertEqual(photos.count, 0, "0 Results")
    }
    
    func testFetchPhoto() async throws {
        let photos = viewModel.photos
        await viewModel.fetchPhotos()
        XCTAssertEqual(photos.count, photos.count,  "\(photos.count) Results")
        
    }
    
}
