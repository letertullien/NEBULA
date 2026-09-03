//
//  FicheExistanteView.swift
//  NEBULA
//
//  Created by Admin on 2026-08-31.
//

import SwiftUI
import CoreData

struct FicheExistanteView: View {
    @ObservedObject var  entiteObservation: FicheEntity
    @ObservedObject var objetCelesteEntity: ObjetCelesteEntity
    let viewModel: CrudViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var afficherModification = false
    @State private var afficherConfirmationSuppression = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "note.text")
                            .foregroundStyle(.secondary)
                            .frame(width: 20)
                        Text(entiteObservation.notes ?? "")
                    }

                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "cloud.sun")
                            .foregroundStyle(.secondary)
                            .frame(width: 20)
                        Text(entiteObservation.meteo ?? "")
                    }

                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "location")
                            .foregroundStyle(.secondary)
                            .frame(width: 20)
                        Text(entiteObservation.lieu?.isEmpty == false ? entiteObservation.lieu! : "Non précisé")
                    }

                    if let date = entiteObservation.dateCreation {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "calendar")
                                .foregroundStyle(.secondary)
                                .frame(width: 20)
                            Text(date.formatted(date: .abbreviated, time: .shortened))
                        }
                    }
                }
                .font(.body)

                Spacer()

                Button("Supprimer cette fiche", role: .destructive) {
                    afficherConfirmationSuppression = true
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .navigationTitle("Observation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Modifier") { afficherModification = true }
                }
            }
            .sheet(isPresented: $afficherModification) {
                FicheNewEditView(
                    fiche: FicheObservation(depuisEntity: entiteObservation),
                    objetCelesteEntity: objetCelesteEntity,
                    viewModel: viewModel
                )
            }
            .alert("Supprimer cette observation ?", isPresented: $afficherConfirmationSuppression) {
                Button("Annuler", role: .cancel) {}
                Button("Supprimer", role: .destructive) {
                    viewModel.supprimer(entiteObservation)
                    dismiss()
                }
            } message: {
                Text("Seule cette fiche est supprimée — l'objet céleste reste enregistré.")
            }
        }
    }
}
