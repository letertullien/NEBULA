//
//  NEBULAApp.swift
//  NEBULA
//
//  Created by Admin on 2026-08-18.
//

import SwiftUI
import CoreData

@main
struct NEBULAApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
         WindowGroup {
             TabView {
                        NavigationStack { HomeView() }
                        .tabItem { Label("Home", systemImage: "star.fill") }
                 
                        NavigationStack { SearchView() }
                        .tabItem { Label("Recherche", systemImage: "magnifyingglass") }
                 
                         NavigationStack { MesObservationsView() }
                         .tabItem { Label("Mes observations", systemImage: "star.fill") }
                      }
             
             
       
          }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
       
    }
}
