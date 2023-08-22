//
//  SCPalletes.swift
//  
//
//  Created by Otávio Zabaleta on 24/09/2022.
//

import SwiftUI

struct SCPalletes {
    struct Graph {
        let colors: [Color]
        
        static var donut: Graph { Graph(colors: donutColors) }
    }
}

private extension SCPalletes.Graph {
    private static var donutColors = [Color(hex: "4770b3"), Color(hex: "e4b031"), Color(hex:"26727b"), Color(hex:"50aed3"), Color(hex:"04cc82"), Color(hex:"9e9ea2")]
}
