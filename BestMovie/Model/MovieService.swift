//
//  MovieService.swift
//  BestMovie
//
//  Created by Laure Compoint on 12/12/2019.
//  Copyright © 2019 Laure Compoint. All rights reserved.
//

import Foundation
import SwiftyJSON

class MovieService {
    private let movieApi = "https://api.themoviedb.org/3"
    private  let picture = "https://image.tmdb.org/t/p/w200"
    private  let apiKey = "f4ad4557948fa7ac39c092190497d035"
    private let genre = 1
    private  var discoverUrl : URL {
        return URL(string: "\(movieApi)/discover/movie?api_key=\(apiKey)&region=FR")!
    }

    
    static let shared = MovieService()
    private init(){
        
    }
    
    enum MovieError {
        case connection
        case undefined
        case response
        case statusCode
        case pictures
         case data
    }
   
    func getPopulaireMovies(completion: @escaping (MovieError?, [Movie]?) -> Void) {
        let task = URLSession.shared.dataTask(with: discoverUrl) { (data, response, error) in
            //traiter error
            if let error = error as? URLError{
                if error.code == URLError.Code.notConnectedToInternet{
                    print("ERROR BECAUSE NOT CONNECTED TO INTERNET")
                    completion(MovieError.connection, nil)
                    return
                }else{
                    print("UNDEFINED ERROR")
                   completion(MovieError.undefined, nil)
                    return
                }
            }
            //traiter reponse
            guard let response = response as? HTTPURLResponse else{
                print("ERROR WITH THE RESPONSE")
                 completion(MovieError.response, nil)
                return
            }
            guard response.statusCode == 200 else {
                print("ERROR WITH THE STATUS CODE", response.statusCode)
                 completion(MovieError.statusCode, nil)
                return
            }
            //traiter data
            guard let data = data else {
                print("ERROR WITH THE DATA")
                 completion(MovieError.data, nil)
                return
            }
            // recuperer la propriété "result" du json
            let results = JSON(data)["results"]
            // creer un tableau vide
            var movies = [(title: String, posterPath: String, realeaseDate: String, id: String, genreIds: String)]()
            //remplir le tableau
            // verifier si aucune nest egale a null dans le json
            for movie in results.arrayValue{
                
                    let title = movie["title"].stringValue
                    let posterPath = movie["poster_path"].stringValue
                   let realeaseDate = movie["realse_date"].stringValue
                  let id = movie["id"].stringValue
                let genreIds = movie["genreIds"].stringValue
                
                movies.append((title: title, posterPath: posterPath, realeaseDate: realeaseDate, id: id, genreIds: genreIds))
            }
            //print(movies)
            // pour chaque film de movies, recuperer le poster puis cree une instance de movie
            // cela se fera dans une boucle for movie in movies {...}
            var discoverMovies = [Movie]()
            // cree un groupe de taches
            let group = DispatchGroup()
            
            for movie in movies {
                
                group.enter()
                
                //obtenir un poster
                self.getPoster(movie.posterPath) { (poster) in
                    guard let poster = poster else{
                        print("error in get posters loop")
                          completion(MovieError.pictures, nil)
                        group.leave()
                        return
                    }
                     // cree une instance movie appelee discovermovie avec le poster, title, etc
                    let discoverMovie = Movie(title: movie.title, poster: poster, realeaseDate: movie.realeaseDate, isLiked: nil, id: movie.id, genreIds: movie.genreIds)
                    //ajouter ce movie à un tableau
                    discoverMovies.append(discoverMovie)
                      group.leave()
                    
                }
            }
            group.notify(queue: DispatchQueue.main, execute: {
                    completion(nil, discoverMovies)
                
            })
        
            
        }
        task.resume()
    }
    
    private func getPoster(_ posterPath: String, pictureCompletionHandler: @escaping(Data?) -> Void ){
        let posterUrl = URL(string: "\(picture)\(posterPath)")!
       
        let task = URLSession.shared.dataTask(with: posterUrl) { (data, response, error) in
            if let error = error as? URLError {
                if error.code == URLError.Code.notConnectedToInternet{
                    print("ERROR BECAUSE NOT CONNECTED TO INTERNET")
                     pictureCompletionHandler(nil)
                    return
                }else{
                    print("UNDEFINED ERROR")
                     pictureCompletionHandler(nil)
                    return
                }
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("PICTURE ERROR WITH RESPONSE")
                pictureCompletionHandler(nil)
                return
            }
            guard response.statusCode == 200 else{
                print("picture error with the status code :", response.statusCode)
                pictureCompletionHandler(nil)
                return
            }
            guard let poster = data else{
                print("PICTURE ERROR WITH data")
                 pictureCompletionHandler(nil)
                return
            }
            pictureCompletionHandler(poster)
            
            
        }
        task.resume()
    }
}
