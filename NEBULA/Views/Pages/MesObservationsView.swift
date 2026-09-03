//
//  MesObservationsView.swift
//  NEBULA
//
//  Created by Admin on 2026-08-18.
//

import SwiftUI
import CoreData

struct MesObservationsView: View {
   
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.titre, order: .forward)],
        predicate: NSPredicate(format: "lesFiches.@count > 0")
    )
    private var objetsAvecFiche: FetchedResults<ObjetCelesteEntity>

    var body: some View {
        List(objetsAvecFiche, id: \.objectID) { entity in
            let objet = ObjetCeleste(depuisEntity: entity)
            NavigationLink(value: objet) {
                HStack {
                    AsyncImage(url: URL(string: objet.nomImage)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image("generic")
                            .resizable()
                    }
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(8)

                    Text(objet.titre)
                        .font(.headline)
                }
            }
        }
        .navigationDestination(for: ObjetCeleste.self) { objet in
            DetailsView(objetSelectionne: objet)
        }
        .navigationTitle("Observations")
    }
}
