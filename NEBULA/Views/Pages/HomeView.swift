//
//  Home.swift
//  NEBULA
//
//  Created by Admin on 2026-08-18.
//

import SwiftUI

struct Etoile: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let taille: CGFloat
    let opacite: Double
}

struct HomeView: View {
    @State private var etoiles: [Etoile] = (0..<40).map { _ in
        Etoile(
            x: .random(in: 0...400),
            y: .random(in: 0...850),
            taille: .random(in: 1...3),
            opacite: .random(in: 0.2...0.8)
        )
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.05, blue: 0.15), Color(red: 0.15, green: 0.05, blue: 0.25)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            ForEach(etoiles) { etoile in
                Circle()
                    .fill(.white.opacity(etoile.opacite))
                    .frame(width: etoile.taille)
                    .position(x: etoile.x, y: etoile.y)
            }

            
             
            VStack(spacing: 16) {
                Spacer()

                Image(systemName: "sparkles")
                    .font(.system(size: 72))
                    .foregroundStyle(.purple.gradient)

                Text("NEBULA")
                    .font(.largeTitle)
                    .bold()
                    .kerning(3)
                    .foregroundStyle(.white)

                Text("Explore l'univers, une étoile à la fois")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()
                Spacer()
            }
            
            
        }
    }
}








#Preview {
    NavigationStack {
        HomeView()
    }
}


