//
//  LoadingView.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Text("Laddar")
                .font(.largeTitle)
                .foregroundColor(Color.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .opacity(0.7)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
