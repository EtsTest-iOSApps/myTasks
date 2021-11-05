//
//  Worker.swift
//  myTasks
//
//  Created by Максим Хлесткин on 05.11.2021.
//

import Foundation
import UIKit

class Checkmarks {
    
    static func install(_ task: TaskModel, image: UIImageView) {
        let doneConfig = UIImage.SymbolConfiguration(paletteColors: [.systemMint , .systemBlue, .systemBlue])
        let undoneConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .small)
        if task.completion == true {
            image.image = UIImage(systemName: "checkmark.circle", withConfiguration: doneConfig)
        } else {
            image.image = UIImage(systemName: "staroflife", withConfiguration: undoneConfig)
        }
    }
    
}
