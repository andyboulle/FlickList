//
//  MovieListView.swift
//  FlickList
//
//  Created by Andy Boulle on 12/30/22.
//

import Foundation
import SwiftUI

struct MovieListView: View {
    
    var header: String
    var movieList: MovieList
    
    var body: some View {
        VStack {
            HeaderView(header: header)
            VStack {
                Text("Total: \(movieList.length)").foregroundColor(AppStyles.secondaryColor)
                if movieList.totalRating != nil {
                    Text("Average: \(String(movieList.averageRating ?? 0))").foregroundColor(AppStyles.secondaryColor)
                }
            }
            List(movieList.list.startIndex ..< movieList.length, id: \.self) {
                i in let mov = movieList.list[i]
                MovieRowView(movie: mov)
            }
        }.background(AppStyles.primaryColor).font(.custom("Fjalla One", size: 20))
    }
    
}
