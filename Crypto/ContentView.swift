//
//  ContentView.swift
//  Crypto
//
//  Created by kerubito on 2021/10/06.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var model = ContentModel()
    
    var body: some View {
        
        VStack(spacing: 15) {
            TextField("", text: $model.str)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            Button(action: {
                model.onCrypto()
            }) {
                if model.isEnrypto {
                    Text("復号化")
                        .frame(width: 300, height: 45)
                } else {
                    Text("暗号化")
                        .frame(width: 300, height: 45)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
