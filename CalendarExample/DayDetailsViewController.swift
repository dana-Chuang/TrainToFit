import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class DayDetailsViewController: UIViewController
{
    @IBOutlet weak var labelSelectedDay: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelWorkoutName1: UILabel!
    @IBOutlet weak var labelWeight1: UILabel!
    @IBOutlet weak var statusImg1: UIImageView!
    
    @IBOutlet weak var labelWorkoutName2: UILabel!
    @IBOutlet weak var labelWeight2: UILabel!
    @IBOutlet weak var statusImg2: UIImageView!
    @IBOutlet weak var labelWorkoutName3: UILabel!
    @IBOutlet weak var labelWeight3: UILabel!
    @IBOutlet weak var statusImg3: UIImageView!
    @IBOutlet weak var startWorkoutBtn: UIButton!
    @IBOutlet weak var haveWorkoutView: UIView!
    @IBOutlet weak var noWorkoutView: UIView!
    
    var selectedDay = ""
    var ongoingPlanDocID = ""
    var selectedHistDocID = ""
    var nextWorkoutDate = ""
    var increment = Double()
    
    var db: Firestore!
    let uid : String = (Auth.auth().currentUser?.uid)!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        db = Firestore.firestore()
        labelSelectedDay.text = selectedDay
        
        //locate the plan with status: Ongoing
        db.collection("Accounts").document("\(uid)").collection("Plans").whereField("status", isEqualTo: "Ongoing").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.ongoingPlanDocID = document.documentID
                    self.increment = document.data()["increment"] as! Double
                    //only one document
                    self.db.collection("Accounts").document("\(self.uid)").collection("Plans").document("\(self.ongoingPlanDocID)").collection("Histories").whereField("date", isEqualTo: "\(self.selectedDay)").getDocuments() {(querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            if querySnapshot!.documents.isEmpty
                            {
                                //default view: noWorkoutView
                                self.haveWorkoutView.isHidden = true
                                self.noWorkoutView.isHidden = false
                            } else {
                                //switch the view
                                self.haveWorkoutView.isHidden = false
                                self.noWorkoutView.isHidden = true
                                for d_document in querySnapshot!.documents
                                {
                                    self.selectedHistDocID = d_document.documentID
                                    self.nextWorkoutDate = d_document.data()["next_date"] as? String ?? "Anonymous"
                                    self.labelStatus.text = d_document.data()["workout_status"] as? String ?? "Anonymous"
                                    self.labelType.text = d_document.data()["workout_type"] as? String ?? "Anonymous"
                                    if (self.labelType.text == "A")
                                    {
                                        //workout A: squat, press, deadlift
                                        self.labelWorkoutName1.text = "Squat"
                                        self.labelWorkoutName2.text = "Press"
                                        self.labelWorkoutName3.text = "Deadlift"
                                        self.labelWeight1.text = "\(d_document.data()["squat"] ?? "Anonymous")"
                                        self.labelWeight2.text = "\(d_document.data()["press"] ?? "Anonymous")"
                                        self.labelWeight3.text = "\(d_document.data()["deadlift"] ?? "Anonymous")"
                                        //check if the workout is finished
                                        if (self.labelStatus.text == "Finished")
                                        {
                                            //the workout is finished
                                            self.switchToFinishedMode(
                                                status1: (d_document.data()["squat_status"] as! Bool),
                                                status2: (d_document.data()["press_status"] as! Bool),
                                                status3: (d_document.data()["deadlift_status"] as! Bool))
                                        }
                                    } else {
                                        //workout B: squat, bench press, deadlift
                                        self.labelWorkoutName1.text = "Squat"
                                        self.labelWorkoutName2.text = "Bench press"
                                        self.labelWorkoutName3.text = "Deadlift"
                                        self.labelWeight1.text = "\(d_document.data()["squat"] ?? "Anonymous")"
                                        self.labelWeight2.text = "\(d_document.data()["bench_press"] ?? "Anonymous")"
                                        self.labelWeight3.text = "\(d_document.data()["deadlift"] ?? "Anonymous")"
                                        //check if the workout is finished
                                        if (self.labelStatus.text == "Finished")
                                        {
                                            //the workout is finished
                                            self.switchToFinishedMode(
                                                status1: (d_document.data()["squat_status"] != nil),
                                                status2: (d_document.data()["bench_press_status"] != nil),
                                                status3: (d_document.data()["deadlift_status"] != nil))
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func switchToFinishedMode(status1: Bool, status2: Bool, status3: Bool)
    {
        self.labelStatus.textColor = .systemGreen
        if status1
        {
            //user has completed the first workout type
            self.statusImg1.image = UIImage(systemName: "checkmark.seal.fill")
            self.statusImg1.tintColor = .systemYellow
        }
        if status2
        {
            //user has completed the second workout type
            self.statusImg2.image = UIImage(systemName: "checkmark.seal.fill")
            self.statusImg2.tintColor = .systemYellow
        }
        if status3
        {
            //user has completed the third workout type
            self.statusImg3.image = UIImage(systemName: "checkmark.seal.fill")
            self.statusImg3.tintColor = .systemYellow
        }
        //since the workout is finished, cannot start the workout
        self.startWorkoutBtn.isEnabled = false
    }
    
    @IBAction func startWorkout(_ sender: Any)
    {
        if let viewController = storyboard?.instantiateViewController(identifier: "workout_ing") as? WorkoutViewController {
            viewController.planDocID = ongoingPlanDocID
            viewController.histDocID = selectedHistDocID
            viewController.workoutDate = selectedDay
            viewController.nextWorkoutDate = nextWorkoutDate
            viewController.workoutIncre = increment
            viewController.workout1 = self.labelWorkoutName1.text!
            viewController.workout2 = self.labelWorkoutName2.text!
            viewController.workout3 = self.labelWorkoutName3.text!
            viewController.weight1 = self.labelWeight1.text!
            viewController.weight2 = self.labelWeight2.text!
            viewController.weight3 = self.labelWeight3.text!
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
