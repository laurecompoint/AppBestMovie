//
//  Movie.swift
//  BestMovie
//
//  Created by Laure Compoint on 12/12/2019.
//  Copyright © 2019 Laure Compoint. All rights reserved.
//

import Foundation

class Movie{
    var title: String
    var poster: Data
    var realeaseDate: String
    var isLiked: Bool?
    var id: String
    var genreIds: String
   
    //obtenir l'année du film dans la realeaseDate
    //var releaseYear: String{
       // return poster.
    //}
    
    init(title: String, poster: Data, realeaseDate: String,  isLiked: Bool?, id: String, genreIds: String){
        self.title = title
        self.poster = poster
        self.realeaseDate = realeaseDate
        self.isLiked = isLiked
        self.id = id
        self.genreIds = genreIds
    }
    
    func setLike(with userChoice: Bool){
        isLiked = userChoice
    }
}
