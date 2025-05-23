#Pizza Girls: Bluey-Themed SpriteKit Game!

![image](https://github.com/user-attachments/assets/0431ebff-9d25-4708-ae56-e8b3bd7acca3)

Pizza Girls is an iOS game built in Swift using the SpriteKit framework. In this game, you control Bluey and her younger sister Bingo as they catch falling pizzas in a limited sequence of drops. Your goal is to collect as many pizzas as possible without missing more than five. The game features timed pizza drops, score tracking, background music, and a restart mechanism.

This game was inspired by the Bluey episode "Pizza Girls." An icon is currently missing but will be added as soon as possible.

![image](https://github.com/user-attachments/assets/563a8de9-a914-4fd1-b28b-5ebaa1223a89)

* **Objective**: Catch falling pizzas to earn points and avoid missing too many.  
* **Pizza Drops**: A total of 25 pizzas descend at one-second intervals from random horizontal positions.  
* **Scoring**: Each pizza caught awards 10 points.  
* **Miss Limit**: Missing six pizzas ends the game immediately.  
* **End Conditions**:  
  * After all 25 pizzas drop, the game concludes if there are no more incoming pizzas.  
  * Exceeding the miss limit ends the game even before all drops complete.  
* **Restart**: After a game over, tap the on-screen restart label to reset the score, miss count, and begin a new round.![][image2]

## **Requirements**

* **Xcode 12** or later  
* **Swift 5.3** or later  
* **iOS 14.0** or later (simulator or device)  
* **macOS 11.0 (Big Sur)** or later for development  
* No external libraries or package managers; all functionality uses Apple’s native frameworks.

## **Installation and Setup**

**Clone the repository**  
git clone https://github.com/your-username/pizza-dodger.git

1. cd pizza-dodger  
2. **Open in Xcode**  
   * Double-click `Lab5.xcodeproj` or use **File → Open** within Xcode.  
3. **Select Target**  
   * Choose a simulator or connected iOS device from the toolbar.  
4. **Build and Run**  
   * Press **Command \+ R** or click the Run ▶️ button to launch the game.

## **Controls and User Interface**

* **Move Bluey**: Tap on the left half of the screen to move left; tap on the right half to move right.  
* **Score Display**: The current score appears in the top-right corner of the screen.  
* **Game Over & Restart**: Once the game ends, a “Tap to Restart” label appears. Tap it to begin a new game.

## **Customization and Extension**

* **Adjust Drop Count**: In `GameScene.swift`, modify the repeat count in the pizza spawn action to change how many pizzas appear.  
* **Change Drop Interval**: Update the wait duration in the spawn sequence to speed up or slow down pizza drops.  
* **Swap Sprites**: Replace the `pizza.png` or `bluey.png` assets with custom images; ensure filenames match the code references.  
* **Miss Limit**: Modify the `maxAllowedMisses` constant in `GameScene.swift` to set a new threshold for game over.

## **Troubleshooting and Known Issues**

* **Overlapping Drops**: Pizzas may spawn at identical positions. Consider adding a small position offset check to avoid immediate overlaps.  
* **Audio Playback**: If the theme music does not start, verify that `BlueyTheme.mp3` is included in the target and that the filename matches exactly.  
* **Physics Performance**: On older devices, physics calculations may lag if many nodes occupy the scene. Limit the total active nodes or reduce physics body complexity.
