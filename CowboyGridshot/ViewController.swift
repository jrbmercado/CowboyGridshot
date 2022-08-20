//
//  ViewController.swift
//  CowboyGridshot
//
//  Created by Justin Mercado on 8/19/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreNumber: UILabel! // Displays the current running total of the game in progress
    @IBOutlet weak var playAgainButton: UIButton! // Button that restarts the game, only displayed once the timer runs out
    @IBOutlet weak var highScoreNumber: UILabel! // Displays the current high score throughout all sessions
    @IBOutlet weak var timerText: UILabel! // Displays a countdown timer that begins when a player hits the first target
    @IBOutlet weak var plus1Button: UIButton! // Button that increments the user's score by one
    
    var loadedHighScore = 0 // Default high score value is 0 if player has never set a high score before
    var gameLengthInSeconds = 30 // Total amount of time a player has until the game is over
    lazy var secondsRemaining = gameLengthInSeconds // Keeps track of time remaining on timer once the game has begun
    var countingTimer : Timer? // Counts down the time every second
    
    override func viewDidLoad() {
        playAgainButton.isHidden = true // Initially hide the replay button on first opening the app
        relocateButton() // Move plus one target to a valid playing area for device's screen
        
        // Load high score and display it
        loadedHighScore = UserDefaults.standard.integer(forKey: "highScore") // Returns nil if player has never set a high score, so high score will default to 0
        highScoreNumber.text = "\(loadedHighScore)" // Update high score display text
        
        super.viewDidLoad()
    }
    
    // Moves the plus 1 button randomly to a new location
    func relocateButton(){
        // Randomly generate new x and y coordinates
        let randomX:CGFloat? = CGFloat(Float.random(in: 0...305))
        let randomY:CGFloat? = CGFloat(Float.random(in: 200...760))
        // Then move the button to the new corrdinates
        plus1Button.frame = CGRectMake(randomX!, randomY!, plus1Button.frame.width, plus1Button.frame.height)
    }
    
    // Begins game timer and also increments score by 1 everytime player presses button
    @IBAction func addOneButtonPressed(_ sender: UIButton) {
        
        // Checks to see if there is an already active timer
        if(countingTimer == nil){ // If there is no timer active, begin a timer. Otherwise, do not start another timer.
            countingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        // Increase player score by one
        let count = (Int(scoreNumber.text!) ?? 0) + 1 // Get the current score and add one to it
        scoreNumber.text = "\(count)" // Update the player's total score counter label
        
        relocateButton() // Change the plus one button location
    }
    
    // Updates the game timer label by calculating remaining time in minutes and seconds
    @objc func updateTimer(){
        if secondsRemaining > 0{ // If there is still time left on the timer
            secondsRemaining -= 1 // Subtract 1 second from timer
            let time = secondsToMinutesSeconds(seconds: secondsRemaining) // Convert seconds to minutes AND seconds, time.0 is minutes, time.1 is seconds once returned.
            let timeString = makeTimeString(minutes: time.0, seconds: time.1) // Format the time string, inserting a : in between the numbers
            timerText.text = timeString // Update the timerText label
        }
        else{ // If there is no time left on timer
            plus1Button.isHidden = true // Disable the plus one target
            
            countingTimer?.invalidate() // Stop the timer
            countingTimer = nil // Delete the active timer
            
            saveHighScore(); // Save the high score if beaten
        }
    }
    
    // Converts seconds to minutes and seconds, returning two values
    func secondsToMinutesSeconds(seconds: Int)->(Int, Int){
        return (((seconds%3600)/60),((seconds%3600)%60))
    }
    
    // Constructs a string with formatting of mm:ss that can be used to update timerText label
    func makeTimeString(minutes: Int, seconds:Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    // Checks to see if high score has been broken, and if so stores it for future games
    func saveHighScore(){
        // Check if the current score is higher than the high score, if so update high score and remember it
        if(Int(scoreNumber.text!)!>Int(highScoreNumber.text!)!){
            highScoreNumber.text = scoreNumber.text // Update high score text display
            UserDefaults.standard.set(Int(highScoreNumber.text!), forKey: "highScore") // Store high score for loading later if session ends
        }
        playAgainButton.isHidden = false // Unhide the play again button
    }
    
    // Resets game settings and gets a new game ready for the player
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        secondsRemaining = gameLengthInSeconds // Reset time remaining to be ready for next game
        scoreNumber.text = "0" // Reset score count
        
        // Recalculate seconds remaining and convert to minutes and seconds for display on timerText
        let time = secondsToMinutesSeconds(seconds: secondsRemaining)
        let timeString = makeTimeString(minutes: time.0, seconds: time.1)
        timerText.text = timeString // Update timer text with new time string
        
        plus1Button.isHidden = false // Unhide the plus 1 button so player can begin new game
        playAgainButton.isHidden = true // Hide the play again button
        
    }


}

