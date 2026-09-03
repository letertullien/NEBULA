//
//  SearchView.swift
//  NEBULA
//
//  Created by Admin on 2026-08-18.
//
 
import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TextField("Rechercher un objet céleste...", text: $viewModel.texteSearch)
                    .textFieldStyle(.roundedBorder)

                if !viewModel.texteSearch.isEmpty || !viewModel.resultats.isEmpty {
                    Button {
                        viewModel.effacer()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundStyle(.secondary)
                }

                Button {
                    Task {
                        await viewModel.rechercher()
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)

            if viewModel.enChargement {
                Spacer()
                ProgressView("Recherche en cours...")
                Spacer()

            } else if let erreur = viewModel.messageErreur {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)
                    Text(erreur)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                Spacer()

            } else if viewModel.rechercheSansResultat {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "sparkle.magnifyingglass")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Aucun résultat pour cette recherche.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                Spacer()

            } else {
                List(viewModel.resultats) { objet in
                    NavigationLink(value: objet) {
                        HStack {
                            AsyncImage(url: URL(string: objet.nomImage)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)
                            .clipped()
                            .cornerRadius(8)

                            Text(objet.titre)
                        }
                    }
                }
            }
        }
        .navigationDestination(for: ObjetCeleste.self) { objet in
            DetailsView(objetSelectionne: objet)
        }
        .navigationTitle("Recherche")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
