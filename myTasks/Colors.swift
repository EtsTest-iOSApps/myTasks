//
//  Colors.swift
//  myTasks
//
//  Created by Максим Хлесткин on 29.10.2021.
//

import Foundation
import UIKit

class Colors {
    
    static func installCheckmarks(_ task: TaskModel, image: UIImageView) {
        
        let doneConfig = UIImage.SymbolConfiguration(paletteColors: [.systemMint , .systemOrange, .systemGreen])
        let undoneConfig = UIImage.SymbolConfiguration(hierarchicalColor: .systemOrange)
        if task.completion == true {
            image.image = UIImage(systemName: "checkmark.circle", withConfiguration: doneConfig)
        } else {
            image.image = UIImage(systemName: "circle", withConfiguration: undoneConfig)
        }
    }
}
