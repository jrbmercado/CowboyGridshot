
# Cowboy Gridshot

A quick game to see who is the fastest duelist in the room. Keep those fingers tappin' on the targets, and earn the high score!

## Demo

![playGame](https://user-images.githubusercontent.com/60119119/186048723-19ba3eda-ebba-4842-93d5-625eadc060cd.gif)


## Features

- High Score Tracking Across Multiple Sessions
- Play Again Button
- Multiplatform Compatability Across all iOS Devices in Portrait Orientation


## Installation

Currently not on the App Store and only on Github for educational and demonstration purposes only. This app has no affiliation with Apple, Inc.
## Lessons Learned

In this project I focused on learning how to use Main.storyboard and the different resources within UIKit to create a single screen application. 
## Breakthough Discovery: Saving Data Across Sessions

```javascript
func saveHighScore(){
        // Check if the current score is higher than the high score, if so update high score and remember it
        if(Int(scoreNumber.text!)!>Int(highScoreNumber.text!)!){
            highScoreNumber.text = scoreNumber.text // Update high score text display
            UserDefaults.standard.set(Int(highScoreNumber.text!), forKey: "highScore") // Store high score for loading later if session ends
        }
        playAgainButton.isHidden = false // Unhide the play again button
    }
```

This snippet of code was a breakthrough moment for me to learn how to retain information such as the high score count across multiple sessions. Even if the user exits and closes the app, the app will still be able to look in UserDefaults for a Int value stored with the "highScore" key to load the high score next time the user plays.
