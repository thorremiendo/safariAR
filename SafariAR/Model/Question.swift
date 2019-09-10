//
//  Question.swift
//  SafariAR
//
//  Created by Thor Remiendo on 06/09/2019.
//  Copyright © 2019 ZET. All rights reserved.
//

import Foundation

class Question {
    
    let questionText : String
    let answer : Bool
    
    init(text: String, correctAnswer: Bool){
        questionText = text
        answer = correctAnswer
    }
}
