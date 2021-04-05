//
//  CodeView.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 03/04/21.
//

import SwiftUI
import CodeViewer

struct CodeView: View {
    @State private var json = ""
    var body: some View {
        CodeViewer(
            content: $json,
            mode: .json,
            darkTheme: .solarized_dark,
            lightTheme: .solarized_light,
            isReadOnly: true,
            fontSize: 10
        )
        .onAppear {
            json = """
                {
                    "hello": "world"
                }
                """
        }
    }
}

struct CodeView_Previews: PreviewProvider {
    static var previews: some View {
        CodeView()
    }
}
