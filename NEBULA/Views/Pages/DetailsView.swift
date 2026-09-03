//
//  DetailsView.swift
//  NEBULA
//
//  Created by Admin on 2026-08-18.
//


import SwiftUI
import CoreData

struct DetailsView: View {
    let objetSelectionne: ObjetCeleste
    @Environment(\.managedObjectContext) private var context
    @State private var afficherFormulaire = false // .sheet
    @State private var ficheSelectionnee: FicheObservation? // Ouvre ou non .sheet de la fiche selectionnée

    @State private var entiteCelesteVivante: ObjetCelesteEntity? // DONNÉES CELESTE ACTIVE EN CAS DE BESOIN DE SAUVEGARDE

    @FetchRequest private var fichesEnBase: FetchedResults<FicheEntity>

    init(objetSelectionne: ObjetCeleste) {
        self.objetSelectionne = objetSelectionne
        _fichesEnBase = FetchRequest(
            sortDescriptors: [SortDescriptor(\.dateCreation, order: .reverse)],
            predicate: NSPredicate(format: "objetCeleste.id == %@", objetSelectionne.id)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    AsyncImage(url: URL(string: objetSelectionne.nomImage)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image("generic")
                            .resizable()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 280)
                    .clipped()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.purple.opacity(0.3), lineWidth: 2)
                    )
                    .padding(.horizontal, 4)

                    Text(objetSelectionne.titre)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)

                    Text(objetSelectionne.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    HStack(spacing: 6) {
                        Image(systemName: "binoculars")
                        Text("Centre d'observation : \(objetSelectionne.centreObservation)")
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                    if !fichesEnBase.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mes Fiches d'observations")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(fichesEnBase, id: \.objectID) { entiteFiche in
                                Button {
                                    ficheSelectionnee = FicheObservation(depuisEntity: entiteFiche)
                                } label: {
                                    FicheCarteView(entiteFiche: entiteFiche)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.top)
                .padding(.bottom, 16)
            }

            Button("Ajouter une observation") {
                afficherFormulaire = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(entiteCelesteVivante == nil)
            .padding()
        }
        .navigationTitle("Détail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)

      
        .task {
            if entiteCelesteVivante == nil {
                entiteCelesteVivante = CrudViewModel(context: context).sauvegarderObjetCeleste(objetSelectionne)
            }
        }

        .sheet(isPresented: $afficherFormulaire) {
            if let entiteCelesteVivante {
                FicheNewEditView(objetCelesteEntity: entiteCelesteVivante, viewModel: CrudViewModel(context: context))
            }
        }

        .sheet(item: $ficheSelectionnee) { fiche in
            if let entiteObservationVivante = fichesEnBase.first(where: { $0.id == fiche.id }),
               let entiteCelesteVivante {
                FicheExistanteView(entiteObservation: entiteObservationVivante, objetCelesteEntity: entiteCelesteVivante, viewModel: CrudViewModel(context: context))
            }

        }
    }
}

private struct FicheCarteView: View {
    @ObservedObject var entiteFiche: FicheEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "note.text")
                    .foregroundStyle(.secondary)
                    .frame(width: 18)
                Text(entiteFiche.notes ?? "")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "cloud.sun")
                    .foregroundStyle(.secondary)
                    .frame(width: 18)
                Text(entiteFiche.meteo ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let lieu = entiteFiche.lieu, !lieu.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "location")
                        .foregroundStyle(.secondary)
                        .frame(width: 18)
                    Text(lieu)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
