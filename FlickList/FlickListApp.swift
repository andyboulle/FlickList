//
//  FlickListApp.swift
//  FlickList
//
//  Created by Andy Boulle on 12/29/22.
//

import SwiftUI

@main
struct FlickListApp: App {
    @StateObject var flickListModel: FlickListModel = FlickListModel()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(flickListModel)
        }
    }
}
