import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class FeedbackViewController: UIViewController
{
    @IBOutlet weak var imgHappyFace1: UIImageView!
    @IBOutlet weak var imgSadFace1: UIImageView!
    @IBOutlet weak var imgHappyFace2: UIImageView!
    @IBOutlet weak var imgSadFace2: UIImageView!
    @IBOutlet weak var imgHappyFace3: UIImageView!
    @IBOutlet weak var imgSadFace3: UIImageView!
    @IBOutlet weak var labelWorkoutType1: UILabel!
    @IBOutlet weak var labelWorkoutType2: UILabel!
    @IBOutlet weak var labelWorkoutType3: UILabel!
    @IBOutlet weak var txtFieldWeight: UITextField!
    @IBOutlet weak var labelErrorMsg: UILabel!
    
    var plan_doc_id = ""
    var hist_doc_id = ""
    var workout_date = ""
    var increment = Double()
    var workout1_status = Bool() //final status
    var workout2_status = Bool()
    var workout3_status = Bool()
    var set1_status = Bool()
    var set2_status = Bool()
    var set3_status = Bool()
    var set4_status = Bool()
    var set5_status = Bool()
    var set6_status = Bool()
    var set7_status = Bool()
    var db: Firestore!
    let uid : String = (Auth.auth().currentUser?.uid)!
    let dateFormatter = DateFormatter()
    
    var workout_type = ""
    var squat = Double()
    var press = Double()
    var deadlift = Double()
    var bench_press = Double()
    var weight = Double()
    var next_date_str = ""
    var new_hist_doc_id = ""
    var new_next_date_str = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        db = Firestore.firestore()
        fetchDataOfCurrentHistory()
        
        //get substring from current hist id and make a new one (by adding 1)
        let start = hist_doc_id.index(hist_doc_id.startIndex, offsetBy: 7) //substring:history
        let range = start..<hist_doc_id.endIndex
        let numOfHist = Int(hist_doc_id[range])!
        new_hist_doc_id = "history\(numOfHist+1)"
        
        //get next next workout date
        dateFormatter.dateFormat = "MMM d, yyyy"
        print(next_date_str)
        let next_date = dateFormatter.date(from: next_date_str)!
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: next_date)
        var new_next_date = Date()
        if (weekday == "Friday" || weekday == "Saturday")
        {
            //jump 3 three days as there is Sunday
            new_next_date = Calendar.current.date(byAdding: .day, value: 3, to: next_date)!
        } else {
            new_next_date = Calendar.current.date(byAdding: .day, value: 2, to: next_date)!
        }
        dateFormatter.dateFormat = "MMM d, yyyy"
        new_next_date_str = dateFormatter.string(from: new_next_date)
        
        let tapGestureRecognizer1_happy = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer1_sad = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer2_happy = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer2_sad = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer3_happy = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer3_sad = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgHappyFace1.isUserInteractionEnabled = true
        imgHappyFace1.addGestureRecognizer(tapGestureRecognizer1_happy)
        imgSadFace1.isUserInteractionEnabled = true
        imgSadFace1.addGestureRecognizer(tapGestureRecognizer1_sad)
        imgHappyFace2.isUserInteractionEnabled = true
        imgHappyFace2.addGestureRecognizer(tapGestureRecognizer2_happy)
        imgSadFace2.isUserInteractionEnabled = true
        imgSadFace2.addGestureRecognizer(tapGestureRecognizer2_sad)
        imgHappyFace3.isUserInteractionEnabled = true
        imgHappyFace3.addGestureRecognizer(tapGestureRecognizer3_happy)
        imgSadFace3.isUserInteractionEnabled = true
        imgSadFace3.addGestureRecognizer(tapGestureRecognizer3_sad)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let tappedImgName = tappedImage.restorationIdentifier
        
        if (tappedImgName == "happy 1")
        {
            imgSadFace1.isHighlighted = tappedImage.isHighlighted
        }
        if (tappedImgName == "sad 1")
        {
            imgHappyFace1.isHighlighted = tappedImage.isHighlighted
        }
        if (tappedImgName == "happy 2")
        {
            imgSadFace2.isHighlighted = tappedImage.isHighlighted
        }
        if (tappedImgName == "sad 2")
        {
            imgHappyFace2.isHighlighted = tappedImage.isHighlighted
        }
        if (tappedImgName == "happy 3")
        {
            imgSadFace3.isHighlighted = tappedImage.isHighlighted
        }
        if (tappedImgName == "sad 3")
        {
            imgHappyFace3.isHighlighted = tappedImage.isHighlighted
        }
        
        tappedImage.isHighlighted = !(tappedImage.isHighlighted)
    }
    
    func checkAllQAnsweredCorrectly() -> Bool
    {
        if ((imgHappyFace1.isHighlighted || imgSadFace1.isHighlighted) &&
            (imgHappyFace2.isHighlighted || imgSadFace2.isHighlighted) &&
            (imgHappyFace3.isHighlighted || imgSadFace3.isHighlighted) &&
            (!txtFieldWeight.text!.isEmpty))
        {
            guard let txtWeight = Double(txtFieldWeight.text!)
            else {
                return false
            }
            //every field is answered and in correct format
            weight = txtWeight
            return true
        } else {
            //some missing data
            return false
        }
    }
    
    @IBAction func SubmitFeedback(_ sender: Any)
    {
        if (!checkAllQAnsweredCorrectly())
        {
            labelErrorMsg.text = "Missing fields or incorrect data format"
            labelErrorMsg.isHidden = false
            return
        }
        
        labelErrorMsg.isHidden = true
        workout1_status = (imgHappyFace1.isHighlighted && set1_status && set2_status && set3_status) //true if user is satisfied with specific workout
        workout2_status = (imgHappyFace2.isHighlighted && set4_status && set5_status && set6_status)
        workout3_status = (imgHappyFace3.isHighlighted && set7_status)
        
        let dbRef = db.collection("Accounts").document("\(uid)").collection("plans").document("\(plan_doc_id)").collection("histories")
        print(type(of: dbRef))
        if (workout_type == "A")
        {
            //update current history
            dbRef.document("\(hist_doc_id)").updateData([
                "squat_status": workout1_status,
                "press_status": workout2_status,
                "deadlift_status": workout3_status,
                "weight": weight,
                "workout_status": "Finished"
            ]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document: history details successfully updated")
                }
            }
            
            //create next workout history
            dbRef.document("\(new_hist_doc_id)").setData([
                "date": next_date_str,
                "workout_type": "B",
                "squat": squat,
                "squat_status": false,
                "press": press,
                "press_status": false,
                "deadlift": deadlift,
                "deadlift_status": false,
                "bench_press": bench_press,
                "bench_press_status": false,
                "weight": weight,
                "workout_status": "Not started",
                "next_date" : new_next_date_str
            ])
            
            //update weight increments
            if workout1_status
            {
                dbRef.document("\(new_hist_doc_id)").updateData([
                    "squat": (squat+increment)
                ]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document: history details successfully updated")
                    }
                }
            }
            if workout2_status
            {
                dbRef.document("\(new_hist_doc_id)").updateData([
                    "press": (press+increment)
                ]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document: history details successfully updated")
                    }
                }
            }
            if workout3_status
            {
                dbRef.document("\(new_hist_doc_id)").updateData([
                    "deadlift": (deadlift+increment)
                ]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document: history details successfully updated")
                    }
                }
            }
            
        } else {
            //update current history
            //workout type: B
            dbRef.document("\(hist_doc_id)").updateData([
                "squat_status": workout1_status,
                "bench_press_status": workout2_status,
                "deadlift_status": workout3_status,
                "weight": weight,
                "workout_status": "Finished"
            ]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document: history details successfully updated")
                }
            }
            
            //create next workout history
            dbRef.document("\(new_hist_doc_id)").setData([
                "date": next_date_str,
                "workout_type": "A",
                "squat": squat,
                "squat_status": false,
                "press": press,
                "press_status": false,
                "deadlift": deadlift,
                "deadlift_status": false,
                "bench_press": bench_press,
                "bench_press_status": false,
                "weight": weight,
                "workout_status": "Not started",
                "next_date" : new_next_date_str
            ])
        }
        
        //update weight increments
        if workout1_status
        {
            dbRef.document("\(new_hist_doc_id)").updateData([
                "squat": (squat+increment)
            ]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document: history details successfully updated")
                }
            }
        }
        if workout2_status
        {
            dbRef.document("\(new_hist_doc_id)").updateData([
                "bench_press": (press+increment)
            ]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document: history details successfully updated")
                }
            }
        }
        if workout3_status
        {
            dbRef.document("\(new_hist_doc_id)").updateData([
                "deadlift": (deadlift+increment)
            ]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document: history details successfully updated")
                }
            }
        }
        
        //pop to root view: home page
        navigationController?.popToRootViewController(animated: true)
    }
    
    func fetchDataOfCurrentHistory()
    {
        db.collection("Accounts").document("\(uid)").collection("plans").document("\(plan_doc_id)").collection("histories").document("\(hist_doc_id)").getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.squat = document.data()?["squat"] as! Double
                self.press = document.data()?["press"] as! Double
                self.deadlift = document.data()?["deadlift"] as! Double
                self.bench_press = document.data()?["bench_press"] as! Double
                self.weight = document.data()?["weight"] as! Double
                self.workout_type = document.data()?["workout_type"] as? String ?? "Anonymous"
            } else {
                print("Document does not exist")
            }
        }
    }
}
