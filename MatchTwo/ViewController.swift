//
//  ViewController.swift
//  MatchTwo
//
//  Created by Aset Bakirov on 10.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var counter = 0 //одновременно открытые
    var state = [Int](repeating: 0, count: 16)
    // 0 закрыта, 1 открыта, 2 есть совпадение
    var winState = [[]]
    var imagesArray = ["cheeseburger", "cheesewhopper", "crispychicken", "hrustburger", "longchicken", "nuggetsburger", "stakehouse", "whopper", "cheeseburger", "cheesewhopper", "crispychicken", "hrustburger", "longchicken", "nuggetsburger", "stakehouse", "whopper"]
    //названия изображений, 8 уникальный на 16 плиток чтобы было 8 пар
 
    @IBAction func game(_ sender: UIButton) {
        print("this is sender.tag \(sender.tag)")
        print("this is array winState \(winState)")
        
        //if state[sender.tag - 1] != 0 && counter == 2 {
        if state[sender.tag - 1] == 2 || (state[sender.tag - 1] == 1 && counter == 2) {
            return
        }

        counter += 1
        
        print("This is array state \(state)")
        
        var countToReset = 0 //открытые
        var countMatched = 0 //совпадения
        
        state[sender.tag - 1] = 1
        print("This is array state after writing sender.tag into it \(state)")
        
        sender.setBackgroundImage(UIImage(named: imagesArray[sender.tag - 1]), for: .normal)
        
        for i in 0..<16 {
            if state[i] == 1 {
                countToReset += 1 //подсчет открытых карт
            }
        }
        
        for winArray in winState {
            if state[winArray[0] as! Int] == 1 && state[winArray[1] as! Int] == 1 {
                state[winArray[0] as! Int] = 2
                state[winArray[1] as! Int] = 2
            } //если обе карты из пары в массиве winArray открыты то сохраняем статус
        }
        
        if countToReset == 2 {
            Timer.scheduledTimer(withTimeInterval: 0.5 , repeats: false){
                timer in
                self.clean()
            }
        }
        
        let matchedPairsCount = winState.filter { state[$0[0] as! Int] == 2 }.count

        if matchedPairsCount == winState.count {
            let alert = UIAlertController(title: "You win!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{
                UIAlertAction in
                self.cleanBoard()
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func clean() {
        for i in 0..<16 {
            if state[i] == 1 {
                let button = view.viewWithTag(i + 1) as! UIButton
                button.setBackgroundImage(nil, for: .normal)
                state[i] = 0
                counter = 0
            }
        }
    }
    
    func cleanBoard() {
        for i in 0..<16 {
            let button = view.viewWithTag(i + 1) as! UIButton
            button.setBackgroundImage(nil, for: .normal)
            state[i] = 0
        }
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            imagesArray.shuffle()
            winState.removeAll()
            
            //пары для новой игры
            for a in 0..<16 {
                for b in 0..<16 {
                    if imagesArray[a] == imagesArray[b] && a != b {
                        winState.append([a, b])
                    }
                }
            }
        }
}
