//
//  FlickListModel.swift
//  FlickList
//
//  Created by Andy Boulle on 1/5/22.
//

import Foundation

//
// STRUCTS
//

struct Movie: Codable, Equatable {
    var title: String
    var rating: Double = 0
    //var dateAdded: String = Date().convertedToDate() <-- COMMENTING MUST MATCH "MovieRowView.swift" LINE 25
    var watched: Bool = false
    
    // Movie equals method
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.title == rhs.title
    }
}

struct MovieList: Codable {
    var list: [Movie] = []
    var length: Int = 0
    
    var totalRating: Double? = nil
    var averageRating: Double? = nil
    
    enum RatingsOperations {
        case add
        case remove
        case edit
    }
    
    //Adds a movie to list of movies and increases list length by 1
    mutating func addMovie(movie: Movie) {
        list.append(movie)
        length = length + 1
        
        if movie.watched {
            updateRatingStats(movie: movie, operation: RatingsOperations.add)
        }
    }
    
    mutating func removeMovie(movie: Movie) {
        if let index = list.firstIndex(where: {$0.title == movie.title}) {
            list.remove(at: index)
            length = length - 1
            if movie.watched {
                updateRatingStats(movie: movie, operation: RatingsOperations.remove)
            }
        }
    }
    
    mutating func editMovie(oldMovie: Movie, newMovie: Movie) {
        if let index = list.firstIndex(where: {$0.title == oldMovie.title}) {
            list[index].title = newMovie.title
            if oldMovie.watched {
                updateRatingStats(movie: oldMovie, operation: RatingsOperations.edit, editMovie: newMovie)
                list[index].rating = newMovie.rating
            }
        }
    }
    
    mutating func updateRatingStats(movie: Movie, operation: RatingsOperations, editMovie: Movie? = nil){
        var total = totalRating ?? 0
        var average = averageRating ?? 0
        
        switch operation {
        case RatingsOperations.add:
            total += movie.rating
        case RatingsOperations.remove:
            total -= movie.rating
        case RatingsOperations.edit:
            total -= movie.rating
            total += editMovie!.rating
        }
        
        if length > 0 { // Prevents divide by 0 error
            average = total / Double(length)
            totalRating = round(total * 100) / 100.0
            averageRating = round(average * 100) / 100.0
        } else {
            totalRating = nil
            averageRating = 0
        }
    }
}


//
// CLASS
//
class FlickListModel: ObservableObject {
    @Published var watchedList: MovieList = UserDefaults.standard.watchedList ?? MovieList()
    @Published var wantToWatchList: MovieList = UserDefaults.standard.wantToWatchList ?? MovieList()
    
    //Getter function for watched movie list
    func getWatchedMovies() -> MovieList {
        return watchedList
    }
    
    //Getter function for want to watch movie list
    func getWantToWatchMovies() -> MovieList {
        return wantToWatchList
    }
}


//
// EXTENSIONS
//
extension UserDefaults {
    private enum UserDefaultKeys: String {
        case watchedList
        case wantToWatchList
    }
    
    var watchedList: MovieList? {
        get {
            if let data = object(forKey: UserDefaultKeys.watchedList.rawValue) as? Data {
                let watched = try? JSONDecoder().decode(MovieList.self, from: data)
                return watched
            }
            
            return nil
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(data, forKey: UserDefaultKeys.watchedList.rawValue)
        }
    }
    
    var wantToWatchList: MovieList? {
        get {
            if let data = object(forKey: UserDefaultKeys.wantToWatchList.rawValue) as? Data {
                let watched = try? JSONDecoder().decode(MovieList.self, from: data)
                return watched
            }
            
            return nil
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(data, forKey: UserDefaultKeys.wantToWatchList.rawValue)
        }
    }
}

extension Date {
    func convertedToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: self)
    }
}
