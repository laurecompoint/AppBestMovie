//
//  ChoiceTestCase.swift
//  BestMovieTests
//
//  Created by Laure Compoint on 09/02/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import XCTest
@testable import BestMovie
class ChoiceTestCase: XCTestCase {
    var movie: Movie!
    override func setUp() {
        super.setUp()
        movie = Movie(title: "Spartacus", poster: Data(), realeaseDate: "(1952)", isLiked: nil, id: "dfghjdfg", genreIds: "dfghjklm")
    }
    func testGivenIsLikedIsNil_WhenUserChoiceIsTrue_ThenIsLikedShouldBeTrue() {
        
        movie.setLike(with: true)
        XCTAssert(movie.isLiked == true)
    }
    func testGivenIsLikedIsNil_WhenUserChoiceIsTrue_ThenIsLikedShouldBeFalse() {
        
        movie.setLike(with: false)
        XCTAssert(movie.isLiked == false)
    }
   

  

}
