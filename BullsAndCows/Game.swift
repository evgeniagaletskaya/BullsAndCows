//
//  Game.swift
//  BullsAndCows
//
//  Created by Evgenia Galetskaya on 10/15/18.
//  Copyright © 2018 Evgenia Galetskaya. All rights reserved.
//

import Foundation

class Game {
    
    init() {
        self.randomNumber = getRandomNumber()
    }
    
    var randomNumber = ""
    
    var arrayOfNums = [0, 0, 0, 0]
    
    private func getRandomNumber() -> String {
        
        var temp = 0
        for index in arrayOfNums.indices {
            while arrayOfNums.contains(temp) {
                let num = Int(arc4random_uniform(10))
                temp = num
            }
            arrayOfNums[index] = temp
            temp = 0
        }
        
        for num in arrayOfNums {
            randomNumber += String(num)
        }
        return randomNumber
    } 
}


