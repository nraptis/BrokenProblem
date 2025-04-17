//
//  ContentView.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/16/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .onAppear {
            Runner.run()
            
            /*
            StreakTest.run_sum()
            StreakTest.run_average()
            StreakTest.run_sum_2()
            StreakTest.run_average_2()
            */
            
        }
    }
}

#Preview {
    ContentView()
}
