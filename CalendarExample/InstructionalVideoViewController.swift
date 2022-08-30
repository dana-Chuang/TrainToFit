import Foundation
import UIKit
import YouTubeiOSPlayerHelper

class InstructionalVideoViewController: UIViewController
{
    @IBOutlet var playerView: YTPlayerView!
    
    var workoutType = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //videos are referenced from the Starting Strength channel:
        //https://www.youtube.com/c/AasgaardCoStartingStrength
        if (workoutType == "Squat")
        {
            playerView.load(withVideoId: "nhoikoUEI8U")
        }
        if (workoutType == "Press")
        {
            playerView.load(withVideoId: "8dacy5hjaE8")
        }
        if (workoutType == "Deadlift")
        {
            playerView.load(withVideoId: "p2OPUi4xGrM")
        }
        if (workoutType == "Bench press")
        {
            playerView.load(withVideoId: "rxD321l2svE")
        }
    }
}
