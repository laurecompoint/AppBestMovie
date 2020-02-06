//
//  Choice.swift
//  BestMovie
//
//  Created by Laure Compoint on 09/01/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import Foundation
class Choice {
    private var discoversMovies = [Movie]()
    private var currentIndex = 0
    private var likedMovies = [Movie]()
    enum State{
        case ongoing, over
    }
    var state: State = .ongoing
    var currentMovie: Movie {
        return discoversMovies[currentIndex]
    }
    func start(){
        likedMovies = [Movie]()
        currentIndex = 0
        state = .over
        
        MovieService.shared.getPopulaireMovies { (error, movies) in
            if let error = error {
                var notification : Notification
                if error == MovieService.MovieError.connection{
                    notification = Notification(name : .errorConnection)
                }else{
                     notification = Notification(name:  .errorUndefined)
                }
                NotificationCenter.default.post(notification)
            }
            //informer que nous avons les films a
            guard let movies = movies else{
                let notification = Notification(name: .errorUndefined)
                NotificationCenter.default.post(notification)
                return
            }
           // movies.forEach {(movie) in
              //  print(movie.title)
            //}
            self.discoversMovies = Array(movies.shuffled().prefix(10))
           
           
            self.state = .ongoing
            
            let notification = Notification(name: .discoverMoviesLoaded)
            NotificationCenter.default.post(notification)
        }
    }
    func finish(){
        state = .over
        
        
       

    }
    private func goToNextMovie(){
        currentIndex < discoversMovies.count  - 1 ? currentIndex += 1 : finish()
    }
    func setLikeOfCurrentMovie(with userChoise: Bool){
    currentMovie.setLike(with: userChoise)
    goToNextMovie()
    }
}
extension Notification.Name{
    static let discoverMoviesLoaded = Notification.Name("discoverMoviesLoaded")
    static let errorUndefined = Notification.Name("errorUndefined")
    static let errorConnection = Notification.Name("errorConnection")
}

