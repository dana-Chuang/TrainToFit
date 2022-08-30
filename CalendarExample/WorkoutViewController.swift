import Foundation
import UIKit

class WorkoutViewController: UIViewController
{
    @IBOutlet weak var labelWorkoutName1: UILabel!
    @IBOutlet weak var labelWorkoutName2: UILabel!
    @IBOutlet weak var labelWorkoutName3: UILabel!
    @IBOutlet weak var labelWeight1: UILabel!
    @IBOutlet weak var labelWeight2: UILabel!
    @IBOutlet weak var labelWeight3: UILabel!
    
    @IBOutlet weak var labelTimeRemaining1: UILabel!
    @IBOutlet weak var labelTimeRemaining2: UILabel!
    @IBOutlet weak var imgCircle1: UIImageView!
    @IBOutlet weak var imgCircle2: UIImageView!
    @IBOutlet weak var imgCircle3: UIImageView!
    @IBOutlet weak var imgCircle4: UIImageView!
    @IBOutlet weak var imgCircle5: UIImageView!
    @IBOutlet weak var imgCircle6: UIImageView!
    @IBOutlet weak var imgCircle7: UIImageView!
    
    var planDocID = ""
    var histDocID = ""
    var workoutDate = ""
    var nextWorkoutDate = ""
    var workoutIncre = Double()
    var workout1 = ""
    var workout2 = ""
    var workout3 = ""
    var weight1 = ""
    var weight2 = ""
    var weight3 = ""
    var timeRemaining1 : Int = 60
    var timeRemaining2 : Int = 60
    var timer1: Timer!
    var timer2: Timer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        labelWorkoutName1.text = workout1
        labelWorkoutName2.text = workout2
        labelWorkoutName3.text = workout3
        labelWeight1.text = weight1
        labelWeight2.text = weight2
        labelWeight3.text = weight3
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer7 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imgCircle1.isUserInteractionEnabled = true
        imgCircle1.addGestureRecognizer(tapGestureRecognizer1)
        imgCircle2.isUserInteractionEnabled = true
        imgCircle2.addGestureRecognizer(tapGestureRecognizer2)
        imgCircle3.isUserInteractionEnabled = true
        imgCircle3.addGestureRecognizer(tapGestureRecognizer3)
        imgCircle4.isUserInteractionEnabled = true
        imgCircle4.addGestureRecognizer(tapGestureRecognizer4)
        imgCircle5.isUserInteractionEnabled = true
        imgCircle5.addGestureRecognizer(tapGestureRecognizer5)
        imgCircle6.isUserInteractionEnabled = true
        imgCircle6.addGestureRecognizer(tapGestureRecognizer6)
        imgCircle7.isUserInteractionEnabled = true
        imgCircle7.addGestureRecognizer(tapGestureRecognizer7)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.isHighlighted = true
    }
    
    @IBAction func ShowInstructionalVideo1(_ sender: Any)
    {
        if let viewController = storyboard?.instantiateViewController(identifier: "instructional_video") as? InstructionalVideoViewController {
            viewController.workoutType = labelWorkoutName1.text!
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    @IBAction func ShowInstructionalVideo2(_ sender: Any)
    {
        if let viewController = storyboard?.instantiateViewController(identifier: "instructional_video") as? InstructionalVideoViewController {
            viewController.workoutType = labelWorkoutName2.text!
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func ShowInstructionalVideo3(_ sender: Any)
    {
        if let viewController = storyboard?.instantiateViewController(identifier: "instructional_video") as? InstructionalVideoViewController {
            viewController.workoutType = labelWorkoutName3.text!
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    @IBAction func timerCountdown1(_ sender: Any)
    {
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step1), userInfo: nil, repeats: true)
    }
    
    @objc func step1()
    {
        if (timeRemaining1 > 0)
        {
            timeRemaining1 -= 1
        } else {
            timer1.invalidate()
            timeRemaining1 = 60
        }
        labelTimeRemaining1.text = "\(timeRemaining1)"
    }
    
    @IBAction func timerCountdown2(_ sender: Any)
    {
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step2), userInfo: nil, repeats: true)
    }
    
    @objc func step2()
    {
        if (timeRemaining2 > 0)
        {
            timeRemaining2 -= 1
        } else {
            timer2.invalidate()
            timeRemaining2 = 60
        }
        labelTimeRemaining2.text = "\(timeRemaining2)"
    }
    
    @IBAction func CompleteWorkout(_ sender: Any)
    {
        if let viewController = storyboard?.instantiateViewController(identifier: "feedback") as? FeedbackViewController {
            viewController.plan_doc_id = planDocID
            viewController.hist_doc_id = histDocID
            viewController.workout_date = workoutDate
            viewController.next_date_str = nextWorkoutDate
            viewController.increment = workoutIncre
            viewController.workout1 = labelWorkoutName1.text!
            viewController.workout2 = labelWorkoutName2.text!
            viewController.workout3 = labelWorkoutName3.text!
            viewController.set1_status = imgCircle1.isHighlighted
            viewController.set2_status = imgCircle2.isHighlighted
            viewController.set3_status = imgCircle3.isHighlighted
            viewController.set4_status = imgCircle4.isHighlighted
            viewController.set5_status = imgCircle5.isHighlighted
            viewController.set6_status = imgCircle6.isHighlighted
            viewController.set7_status = imgCircle7.isHighlighted
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
