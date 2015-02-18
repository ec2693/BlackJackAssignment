//
//  ViewController.swift
//  BlackJack
//
//  Created by Era on 2/15/15.
//  Copyright (c) 2015 Era Chaudhary. All rights reserved.
//

//Discussed with my team members for logic implementations as i dont have much hands on experience,I told you in class. 

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var playerHand: UITextField!

    @IBOutlet weak var playerSum: UITextField!

    @IBOutlet weak var dealerHand: UITextField!
    
    @IBOutlet weak var dealerSum: UITextField!
    
    @IBOutlet weak var bet: UITextField!
    
    @IBOutlet weak var playerTotalBalance: UITextField!

    @IBOutlet weak var gameStatus: UILabel!
    
    var cardsInDealerHand = Array<Int>()
    
    var cardsInPlayerHand = Array<Int>()
    
    let maxPlayerCash = 100
    
    var playerBet = 0
    
    var playerBalance = 100
    
    var playerCardsSum = 0
    
    var dealerCardsSum = 0
    
    var mixCards = Array<String>()
    
    var standFlag  = false
    
    var isPlayerWon = false
    
    @IBAction func play() {
        if bet.text == nil || bet.text == "" {
            println("Player has to bet ")
            return
        }
        
        if isGreater( bet.text.toInt()! ) == false
        {
            println("You cant play")
            return
        }
        
        initializeDeck()
    
        if  mixCards.count == 0 {
            println("No more cards in Deck ")
            return
        }
        cardsInPlayerHand.append(distributeCards())
        cardsInPlayerHand.append(distributeCards())
        cardsInDealerHand.append(distributeCards())
        cardsInDealerHand.append(distributeCards())
        println("playerHand - \(cardsInPlayerHand)")
        println("dealerHand - \(cardsInDealerHand)")
        displayPlayerHands()
        displayDealerHandsWithFlip()
        displayPlayerTotalBalance()
        playerBet = bet.text.toInt()!
        
        if isBlackJack(cardsInPlayerHand) == true
        {
            playerBalanceChange(true)
            displayPlayerTotalBalance()
            resetFields()
            gameStatus.text = "Player Won"
            println("Player Won")
            return
        }
        if isBusted(cardsInPlayerHand) == true
        {
            playerBalanceChange(false)
            displayPlayerTotalBalance()
            resetFields()
            gameStatus.text = "Player lost"
            println("Player lost")
            return
        }

    }
        
    
    
    
    @IBAction func hit() {
        if standFlag == false {
            
           cardsInPlayerHand.append(distributeCards())
            println("playerCards - \(cardsInPlayerHand)")
            println("dealerCards - \(cardsInDealerHand)")
            displayPlayerHands()
            displayDealerHandWithFlip()
            if isBlackJack(cardsInPlayerHand) == true
            {
                playerWon()
                return
            }
            
            if isBusted(cardsInPlayerHand) == true
            {
                playerLost()
                return
            }
        }else{
            println("Cant hit , STAND is on")
            return
        }

    }
    
    @IBAction func stand() {
        standFlag = true
        //dealer cards we have to populate .
        dealerCardsSum = getSumOfCards(cardsInDealerHand)
        while(dealerCardsSum<16){
            var currentCardForDealer = distributeCards()
            cardsInDealerHand.append(currentCardForDealer)
            dealerCardsSum += currentCardForDealer
        }
        println("dealer Card sum after stand \(dealerCardsSum)")
        println("dealer Cards \(cardsInDealerHand)")
        if(dealerCardsSum>21){
            gameStatus.text = "Player Won"
            println("player won !! while dealter is trying to get above 16")
            playerWon()
            return
        }
        if(dealerCardsSum > playerCardsSum){
            println("dealer sum \(dealerCardsSum) > player sum \(playerCardsSum)")
            playerLost()
        }else if dealerCardsSum < playerCardsSum{
            println("dealer sum \(dealerCardsSum) < player sum \(playerCardsSum)")
            playerWon()
        }else{
            println("dealer sum \(dealerCardsSum) == player sum \(playerCardsSum)")
            resetFields()
        }

    }

  
    @IBAction func double() {
    }
    
    func initializeDeck() {
        var Suit = ["S","H","D","C"]
        var Card = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]
        var deck : [String] = []
        for suit in Suit{
            for card in Card {
                deck.append("\(card)+\(suit)")
            }
        }
        mixCards = deck.mixCards()
    }
  
    func isBlackJack(cardsInHand : Array<Int>) -> Bool {
        var Count = 0
        for eachCard in cardsInHand {
            Count += eachCard
        }
        if Count == 21 {
            return true
        }
        playerCardsSum = Count
        return false
    }
    
    func isBusted(cardsInHand :Array<Int>) -> Bool {
        var Count = 0
        for eachCard in cardsInHand {
            Count += eachCard
        }
        if Count > 21 {
            return true
        }
        return false
        
    }
    
    func getSumOfCards(cardsInHand : Array<Int>) -> Int{
        var Count = 0
        for card in cardsInHand {
            Count += card
        }
        return Count
    }
    
    
    func isGreater(bet: Int) -> Bool {
        if bet > 1 && bet < playerBalance{
            return true
        }
        return false
    }
    
    func distributeCards()-> Int
    {
        if(mixCards.count>0){
            var currentCardValue :Int = getCardValueInInt("\(mixCards[0])").0
            mixCards.removeAtIndex(0)
            return currentCardValue
        }
        return 0
    }
    
    func playerWon(){
        playerBalanceChange(true)
        displayPlayerTotalBalance()
        resetFields()
        gameStatus.text = "Player Won"
        println("Player Won")
    }
    
    func playerLost(){
        playerBalanceChange(false)
        displayPlayerTotalBalance()
        resetFields()
        gameStatus.text = "Player lost"
        println("Player lost")
    }
    
    func resetFields(){
        playerHand.text = ""
        playerSum.text = ""
        dealerHand.text = ""
        dealerSum.text = ""
        bet.text = ""
        playerCardsSum = 0
        cardsInPlayerHand = []
        cardsInDealerHand = []
        standFlag = false
    }
    
    func playerBalanceChange(playerStatus : Bool ) {
        if playerStatus {
            playerBalance = playerBalance + playerBet
        }else{
            playerBalance = playerBalance - playerBet
        }
    }
    
    
    func displayPlayerHands() {
        playerHand.text = ""
        playerTotalBalance.text = ""
        playerSum.text = ""
        var Total = 0
        for card in cardsInPlayerHand {
            Total += card
            
            playerHand.text = playerHand.text! + "\(card)" + " | "
        }
        playerSum.text = playerSum.text! + "\(Total)"
    }
    
    func displayDealerHandWithFlip() {
        dealerHand.text = ""
        var isFlip = true
        for dc in cardsInDealerHand {
            if isFlip {
                dealerHand.text = dealerHand.text! + "X" + " | "
                isFlip = false
            }else{
                dealerHand.text = dealerHand.text! + "\(dc)" + " | "
            }
        }
    }
    
    func displayPlayerTotalBalance() {
        playerTotalBalance.text = ""
        playerTotalBalance.text = playerTotalBalance.text! + "\(playerBalance)"
    }

func displayDealerHandsWithFlip() {
   dealerHand.text = ""
    var firstCard = true
    for dc in  cardsInDealerHand{
        if firstCard {
            dealerHand.text = dealerHand.text! + " X " + " | "
            firstCard = false
        }else{
            dealerHand.text = dealerHand.text! + "\(dc)" + " | "
        }
    }
}



    func getCardValueInInt(card : String) -> Int  {
        var card_value = split( card, {$0 == "+"})
        switch card_value[0]
        {
        case "2":
            return 2
        case "3":
            return 3
        case "4":
            return 4
        case "5":
            return 5
        case "6":
            return 6
        case "7":
            return 7
        case "8":
            return 8
        case "9":
            return 9
        case "10":
            return 10
        case "J":
            return 10
        case "Q":
            return 10
        case "K":
            return 10
        case "A":
            return 11
        default :
            return 0
        }
        
    }


   }


//reference from google
extension Array {
    func mixCards() -> [T] {
        var list = self
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
}

