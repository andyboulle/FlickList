//
//  ContentView.swift
//  FlickList
//
//  Created by Andy Boulle on 12/29/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var flickListModel: FlickListModel
    
    var body: some View {
        VStack {
            Text("FlickList").foregroundColor(AppStyles.secondaryColor).font(.custom("Fjalla One", size: 60))
            TabView {
                //Watched tab
                MovieListView(header: "Watched", movieList: flickListModel.watchedList).environmentObject(flickListModel).tabItem {
                    Label("Watched", systemImage: "list.bullet.circle")
                }
                //Add movie view
                AddMovieView(header: "Add Movie").environmentObject(flickListModel).tabItem {
                    Label("Add Movie", systemImage: "plus.circle")
                }
                //Want to Watch tab
                MovieListView(header: "Want to Watch", movieList: flickListModel.wantToWatchList).environmentObject(flickListModel).tabItem {
                    Label("Want to Watch", systemImage: "list.bullet.circle")
                }
            }
        }.background(AppStyles.primaryColor).font(.custom("Fjalla One", size: 20))
    }
    
    init() {
        for familyName in UIFont.familyNames {
            print(familyName)
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    @EnvironmentObject private var flickListModel: FlickListModel
    
    static var previews: some View {
        ContentView().environmentObject(FlickListModel())
    }
}
