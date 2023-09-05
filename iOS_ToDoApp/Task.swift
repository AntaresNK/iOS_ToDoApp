//
//  Task.swift
//  iOS_ToDoApp
//
//  Created by Nazym Sayakhmet on 04.09.2023.
//

import Foundation

struct Task: Codable {
    
    var title: String
    var description: String
    var isComplete: Bool = false
    
}
