//
//  HeaderView.swift
//  FlickList
//
//  Created by Andy Boulle on 7/1/23.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    
    var header: String
    
    var body: some View {
        VStack {
            Text(header).foregroundColor(AppStyles.secondaryColor).font(.custom("Fjalla One", size: 32)).fontWeight(.heavy)
        }.background(AppStyles.primaryColor).font(.custom("Fjalla One", size: 20))
    }
}
