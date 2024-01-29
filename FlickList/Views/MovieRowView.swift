//
//  WatchedMovieRowView.swift
//  FlickList
//
//  Created by Andy Boulle on 12/30/22.
//

import Foundation
import SwiftUI

struct MovieRowView: View {
    
    @EnvironmentObject var flickListModel: FlickListModel
    
    @State var deleteConfirmationAlertShowing = false
    @State var editMovieAlertShowing = false
    @State var invalidRatingAlertShowing = false
    @State var invalidTitleAlertShowing = false
    @State var duplicateTitleAlertShowing = false
    
    var movie: Movie
    
    @State var editedTitle: String = ""
    @State var editedRating: String = ""
    
    var body: some View {
        HStack {
            Text(movie.title)
            Spacer()
            if movie.watched {
                Text("\(movie.rating)")
            }
            //Text(movie.dateAdded)
            Button(action: showEditMovieAlert) {
                Image(systemName: "square.and.pencil")
            }.buttonStyle(BorderlessButtonStyle())
            Button(action: showDeleteConfirmationAlert) {
                Image(systemName: "trash")
            }.buttonStyle(BorderlessButtonStyle())
            
            // Alert that pops up to ask if you're sure you want to delete a movie
            .alert("Delete Movie", isPresented: $deleteConfirmationAlertShowing, actions: {
                Button("Delete", action: {removeMovie()})
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Are you sure you want to delete \(movie.title)?")
            })
            
            // Alert that pops up for you to edit your movie
            .alert("Edit Movie", isPresented: $editMovieAlertShowing, actions: {
                TextField("Title", text: $editedTitle)
                if movie.watched {
                    TextField("Rating", text: $editedRating)
                }
                Button("Confirm", action: {editMovie()})
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                if movie.watched {
                    Text("Edit either title, rating, or both. Leave either field blank if you do not want to edit it.")
                } else {
                    Text("Edit the title of the movie")
                }
            })
            
            // Alert that pops up when the rating you entered was invalid, prompt again
            .alert("Invalid Rating", isPresented: $invalidRatingAlertShowing, actions: {
                TextField("Title", text: $editedTitle)
                TextField("Rating", text: $editedRating)
                Button("Confirm", action: {editMovie()})
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("The rating must either be a number or left blank.")
            })
            
            // Alert that pops up when the title you entered was empty, prompt again
            .alert("Invalid Title", isPresented: $invalidTitleAlertShowing, actions: {
                TextField("Title", text: $editedTitle)
                if movie.watched {
                    TextField("Rating", text: $editedRating)
                }
                Button("Confirm", action: {editMovie()})
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Title cannot be left empty.")
            })
            
            // Alert that pops up when the title you entered was a duplicate, prompt again
            .alert("Invalid Title", isPresented: $duplicateTitleAlertShowing, actions: {
                TextField("Title", text: $editedTitle)
                if movie.watched {
                    TextField("Rating", text: $editedRating)
                }
                Button("Confirm", action: {editMovie()})
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("That title already exists in the list.")
            })
        }
    }
    
    func showDeleteConfirmationAlert() {
        deleteConfirmationAlertShowing = true
    }
    
    func showEditMovieAlert() {
        editedTitle = movie.title
        editedRating = "\(movie.rating)"
        editMovieAlertShowing = true
    }
    
    func showInvalidTitleAlert() {
        editedTitle = movie.title
        invalidTitleAlertShowing = true
    }
    
    func showDuplicateTitleAlert() {
        editedTitle = movie.title
        duplicateTitleAlertShowing = true
    }
    
    func showInvalidRatingAlert() {
        editedRating = String(movie.rating)
        invalidRatingAlertShowing = true
    }
    
    func removeMovie() {
        if movie.watched {
            flickListModel.watchedList.removeMovie(movie: movie)
            UserDefaults.standard.watchedList = flickListModel.watchedList
        } else {
            flickListModel.wantToWatchList.removeMovie(movie: movie)
            UserDefaults.standard.wantToWatchList = flickListModel.wantToWatchList
        }
    }
    
    func editMovie() {
        var ratingValid: Bool = true
        var titleValid:Bool = true
        var newRating:Double = movie.rating
        
        // Check to make sure title is valid
        // Title cannot be left empty or already exist in the list
        if editedTitle == "" {
            titleValid = false
            showInvalidTitleAlert()
        } /*else if movie.watched == false {
            if flickListModel.wantToWatchList.list.contains(Movie(title: editedTitle, rating: 0, watched: false)) {
                showDuplicateTitleAlert()
            }
        } else {
            if flickListModel.watchedList.list.contains(Movie(title: editedTitle, rating: 0, watched: true)) {
                showDuplicateTitleAlert()
            }
        }*/
        
        // Check to make sure the rating is valid
        // Rating must be a decimal or whole number
        if let intRating = Double(editedRating.trimmingCharacters(in: .whitespaces)) {
            newRating = intRating
        } else {
            ratingValid = false
            showInvalidRatingAlert()
        }
        
        if ratingValid && titleValid {
            if movie.watched {
                flickListModel.watchedList.editMovie(oldMovie: movie, newMovie: Movie(title: editedTitle, rating: newRating, watched: true))
                UserDefaults.standard.watchedList = flickListModel.watchedList
            } else {
                flickListModel.wantToWatchList.editMovie(oldMovie: movie, newMovie: Movie(title: editedTitle, rating: newRating, watched: false))
                UserDefaults.standard.wantToWatchList = flickListModel.wantToWatchList
            }
        }
    }
    
}
