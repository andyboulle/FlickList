//
//  AddMovieView.swift
//  FlickList
//
//  Created by Andy Boulle on 12/31/22.
//

import Foundation
import SwiftUI

struct AddMovieView: View {

    @EnvironmentObject var flickListModel: FlickListModel
    
    @State var titleToBeAdded: String = String()
    @State var rating: String = ""
    @State var addStatusString: String = ""
    
    @State var invalidTitleAlertShowing: Bool = false
    @State var enterRatingAlertShowing: Bool = false
    @State var invalidRatingAlertShowing: Bool = false
    @State var duplicateMovieAlertShowing: Bool = false
    
    var header: String
    var dateFormatter = DateFormatter()
    
    var body : some View {
        VStack {
            VStack {
                Text(header).foregroundColor(AppStyles.secondaryColor).font(.custom("Fjalla One", size: 32)).fontWeight(.heavy)
            }.background(AppStyles.primaryColor).font(.custom("Fjalla One", size: 20))
            VStack {
                Spacer(minLength: 0.5)
                HStack {
                    Text("Movie Title: ")
                    TextField("Title", text: $titleToBeAdded)
                        .onTapGesture { // Clear text field on tap
                            titleToBeAdded = ""
                        }
                }
                Spacer()
                HStack {
                    Button(action: showEnterRatingAlert) {
                        Text("Add to Watched")
                    }
                    Button(action: addToWantToWatch) {
                        Text("Add to Want to Watch")
                    }
                }
                Text(addStatusString)
                Spacer()
            }
            Spacer()
        }
        
        // Alert that pops up when title is left empty
        .alert(isPresented: $invalidTitleAlertShowing) {
            Alert(
                title: Text("Invalid Title"),
                message: Text("Movie title cannot be left empty."),
                dismissButton: .default(Text("OK"))
            )
        }
        
        // Alert that pops up when you need to enter a rating for a watched movie
        .alert("Enter Rating", isPresented: $enterRatingAlertShowing, actions: {
            TextField("Rating", text: $rating)
            Button("Add", action: {addToWatched()})
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text("Give a rating for \(titleToBeAdded).")
        })
        
        // Alert that pops up when the rating you entered was invalid, prompt again
        .alert("Invalid Rating", isPresented: $invalidRatingAlertShowing, actions: {
            TextField("Rating", text: $rating)
            Button("Add", action: {addToWatched()})
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text("The rating must be a number. \n Please enter a new rating for \(titleToBeAdded).")
        })
        
        // Alert that pops up when a duplicate movie is being added
        .alert(isPresented: $duplicateMovieAlertShowing) {
            Alert(
                title: Text("Duplicate Movie"),
                message: Text("That movie already exists."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func showEnterRatingAlert() {
        if titleToBeAdded == "" {
            invalidTitleAlertShowing = true
        // Check to make sure movie doesn't already exist in watched list
        } else if flickListModel.watchedList.list.contains(Movie(title: titleToBeAdded, rating: 0, watched: true)){
            duplicateMovieAlertShowing = true
        } else {
            enterRatingAlertShowing = true;
        }
    }
    
    func addToWantToWatch() {
        if titleToBeAdded == "" {
            invalidTitleAlertShowing = true
        // Check to make sure movie doesn't already exist in want to watch list
        } else if flickListModel.wantToWatchList.list.contains(Movie(title: titleToBeAdded, rating: 0, watched: false)){
            duplicateMovieAlertShowing = true
        } else {
            let mov = Movie(title: titleToBeAdded, watched: false)
            flickListModel.wantToWatchList.addMovie(movie: mov)
            UserDefaults.standard.wantToWatchList = flickListModel.wantToWatchList
            addStatusString = "Added \"\(mov.title)\" to your Want to Watch list"
        }
        titleToBeAdded = "" // Clear text field after movie is added
    }
    
    func addToWatched() {
        if titleToBeAdded == "" {
            invalidTitleAlertShowing = true
        } else {
            enterRatingAlertShowing = false;
            
            // If rating given is a valid decimal, add to watched list, show alert if not
            if let intRating = Double(rating.trimmingCharacters(in: .whitespaces)) {
                let mov = Movie(title: titleToBeAdded, rating: intRating, watched: true)
                flickListModel.watchedList.addMovie(movie: mov)
                UserDefaults.standard.watchedList = flickListModel.watchedList
                addStatusString = "Added \"\(mov.title)\" to your Watched list"
                titleToBeAdded = "" // Clear text field after movie is added
            } else {
                invalidRatingAlertShowing = true;
            }
        }
        rating = "" // Reset rating
    }
}
