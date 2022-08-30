import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreatePlanViewController: UIViewController
{
    @IBOutlet weak var txtFieldPlanName: UITextField!
    @IBOutlet weak var segmentGender: UISegmentedControl!
    @IBOutlet weak var txtFieldWeight: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtFieldSquat: UITextField!
    @IBOutlet weak var txtFieldPress: UITextField!
    @IBOutlet weak var txtFieldDeadlift: UITextField!
    @IBOutlet weak var txtFieldBenchPress: UITextField!
    @IBOutlet weak var txtFieldIncrement: UITextField!
    @IBOutlet weak var stepperSquat: UIStepper!
    @IBOutlet weak var stepperPress: UIStepper!
    @IBOutlet weak var stepperDeadlift: UIStepper!
    @IBOutlet weak var stepperBenchPress: UIStepper!
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var labelPlanNameErrMsg: UILabel!
    @IBOutlet weak var labelWeightErrMsg: UILabel!
    @IBOutlet weak var labelDateErrMsg: UILabel!
    @IBOutlet weak var labelTypeErrMsg: UILabel!
    @IBOutlet weak var labelIncreErrMsg: UILabel!
    @IBOutlet weak var labelErrMsg: UILabel!
    
    var db: Firestore!
    var numOfPlan = Int()
    var gender = "male" //default gender: male, same as the UI gender segment
    var currentDate = ""
    var startDate = ""
    var startWeekday = ""
    let uid : String = (Auth.auth().currentUser?.uid)!
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        //setup the info pop up view box
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        
        //set default string startDate as current date
        let currentDateTime = Date()
        dateFormatter.dateFormat = "MMM d, yyyy" //set date format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // set timezone
        currentDate = dateFormatter.string(from: currentDateTime)
        startDate = dateFormatter.string(from: currentDateTime)
        
        //set the start date can only be chosen as today onwards
        datePicker.minimumDate = currentDateTime
    }
    
    
    @IBAction func txtFieldNameChecked(_ sender: Any)
    {
        if (txtFieldPlanName.text!.contains("/"))
        {
            labelPlanNameErrMsg.text = "Plan name cannot include '/'"
            labelPlanNameErrMsg.isHidden = false
            return
        } else {
            labelPlanNameErrMsg.isHidden = true
        }
        if (txtFieldPlanName.text!.isEmpty)
        {
            labelPlanNameErrMsg.text = "Plan name cannot be empty"
            labelPlanNameErrMsg.isHidden = false
            return
        } else {
            labelPlanNameErrMsg.isHidden = true
        }
    }
    
    
    @IBAction func txtFieldWeightChecked(_ sender: Any)
    {
        guard let weight  = Double(txtFieldWeight.text!)
        else {
            labelWeightErrMsg.text = "Not a valid number: \(String(txtFieldWeight.text!))"
            labelWeightErrMsg.isHidden = false
            return
        }
        if (weight < 10.0)
        {
            labelWeightErrMsg.text = "Weight too low!"
            labelWeightErrMsg.isHidden = false
            return
        } else {
            labelWeightErrMsg.isHidden = true
        }
    }
    
    @IBAction func TypeSquatChanged(_ sender: Any)
    {
        if let weight = Double(txtFieldSquat.text!) {
            stepperSquat.value = weight
            labelTypeErrMsg.isHidden = true
        } else{
            labelTypeErrMsg.text = "Not a valid number: \(String(txtFieldSquat.text!))"
            labelTypeErrMsg.isHidden = false
        }
    }
    
    @IBAction func TypePressChanged(_ sender: Any)
    {
        if let weight = Double(txtFieldPress.text!) {
            stepperPress.value = weight
            labelTypeErrMsg.isHidden = true
        } else{
            labelTypeErrMsg.text = "Not a valid number: \(String(txtFieldPress.text!))"
            labelTypeErrMsg.isHidden = false
        }
    }
    
    @IBAction func TypeDeadliftChanged(_ sender: Any)
    {
        if let weight = Double(txtFieldDeadlift.text!) {
            stepperDeadlift.value = weight
            labelTypeErrMsg.isHidden = true
        } else{
            labelTypeErrMsg.text = "Not a valid number: \(String(txtFieldDeadlift.text!))"
            labelTypeErrMsg.isHidden = false
        }
    }
    
    @IBAction func TypeBenchPressChanged(_ sender: Any)
    {
        if let weight = Double(txtFieldBenchPress.text!) {
            stepperBenchPress.value = weight
            labelTypeErrMsg.isHidden = true
        } else{
            labelTypeErrMsg.text = "Not a valid number: \(String(txtFieldBenchPress.text!))"
            labelTypeErrMsg.isHidden = false
        }
    }
    
    @IBAction func StepperSquatChanged(_ sender: Any)
    {
        txtFieldSquat.text = "\(stepperSquat.value)"
    }
    
    @IBAction func StepperPressChanged(_ sender: Any)
    {
        txtFieldPress.text = "\(stepperPress.value)"
    }
    
    @IBAction func StepperDeadliftChanged(_ sender: Any)
    {
        txtFieldDeadlift.text = "\(stepperDeadlift.value)"
    }
    
    @IBAction func StepperBenchPressChanged(_ sender: Any)
    {
        txtFieldBenchPress.text = "\(stepperBenchPress.value)"
    }
    
    @IBAction func txtFieldIncrementsChecked(_ sender: Any)
    {
        guard let incre  = Double(txtFieldIncrement.text!)
        else {
            labelIncreErrMsg.text = "Not a valid number: \(String(txtFieldIncrement.text!))"
            labelIncreErrMsg.isHidden = false
            return
        }
        if (incre < 0.1)
        {
            labelIncreErrMsg.text = "Increment too low!"
            labelIncreErrMsg.isHidden = false
            return
        } else {
            labelIncreErrMsg.isHidden = true
        }
    }
    
    @IBAction func GenderSegChanged(_ sender: Any)
    {
        if (segmentGender.selectedSegmentIndex == 0)
        {
            gender = "male"
            stepperSquat.value = 206
            stepperPress.value = 99
            stepperDeadlift.value = 246
            stepperBenchPress.value = 154
            txtFieldSquat.text = "\(stepperSquat.value)"
            txtFieldPress.text = "\(stepperPress.value)"
            txtFieldDeadlift.text = "\(stepperDeadlift.value)"
            txtFieldBenchPress.text = "\(stepperBenchPress.value)"
            
        } else {
            gender = "female"
            stepperSquat.value = 107
            stepperPress.value = 48
            stepperDeadlift.value = 132
            stepperBenchPress.value = 69
            txtFieldSquat.text = "\(stepperSquat.value)"
            txtFieldPress.text = "\(stepperPress.value)"
            txtFieldDeadlift.text = "\(stepperDeadlift.value)"
            txtFieldBenchPress.text = "\(stepperBenchPress.value)"
        }
    }
    
    @IBAction func DatePickerChanged(_ sender: Any)
    {
        if checkPickedDateIsSun()
        {
            labelDateErrMsg.text = "Cannot choose Sunday as workout day. Please pick another date"
            labelDateErrMsg.isHidden = false
        } else {
            labelDateErrMsg.isHidden = true
        }
    }
    
    func checkPickedDateIsSun() -> Bool
    {
        dateFormatter.dateFormat = "MMM d, yyyy"
        startDate = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "EEEE"
        startWeekday = dateFormatter.string(from: datePicker.date)
        print("date picked: \(startWeekday)")
        return (startWeekday == "Sunday")
    }
    
    @IBAction func infoAction(_ sender: Any)
    {
        animatIn(desiredView: popUpView)
    }
    
    @IBAction func AlertGotItAction(_ sender: Any)
    {
        animateOut(desiredView: popUpView)
    }
    
    func animatIn(desiredView: UIView)
    {
        let backgroundView = self.view!
        //attach the desired view to the screen
        backgroundView.addSubview(desiredView)
        //set the view's scaling to be 120%
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        //animate the effect
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
    }
    
    func animateOut(desiredView: UIView)
    {
        UIView.animate(withDuration: 0.3,animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
            
        })
    }
    
    @IBAction func CreatePlan(_ sender: Any)
    {
        guard let plan_name = txtFieldPlanName.text, !plan_name.isEmpty, !(plan_name.contains("/")),
              let weight = Double(txtFieldWeight.text!), !weight.isNaN,
              let squat = Double(txtFieldSquat.text!), !squat.isNaN,
              let press = Double(txtFieldPress.text!), !press.isNaN,
              let deadlift = Double(txtFieldDeadlift.text!), !deadlift.isNaN,
              let bench_press = Double(txtFieldBenchPress.text!), !bench_press.isNaN,
              let incre = Double(txtFieldIncrement.text!), !incre.isNaN
        else {
            labelErrMsg.text = "Missing field data or incorrect inputs"
            labelErrMsg.isHidden = false
            return
        }
        
        //check picked date again
        //this avoid the scenario where the default date is Sunday and the plan is created without any date picked
        if checkPickedDateIsSun()
        {
            labelDateErrMsg.text = "Cannot choose Sunday as workout day. Please pick another date"
            labelDateErrMsg.isHidden = false
            return
        } else {
            labelDateErrMsg.isHidden = true
            let plan_ref = db.collection("Accounts").document("\(uid)").collection("Plans")
            
            //make all plans to be "Completed" before the new plan is created
            plan_ref.getDocuments(){(querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if (document.documentID != "plan\(self.numOfPlan)")
                        {
                            document.reference.updateData(["status": "Completed"])
                        }
                    }
                }}
            
            plan_ref.document("plan\(numOfPlan)").setData([
                "plan_name": plan_name,
                "create_date": currentDate,
                "status": "Ongoing",
                "gender": gender,
                "start_weight": weight,
                "start_date": startDate,
                "start_squat": squat,
                "start_press": press,
                "start_deadlift": deadlift,
                "start_bench_press": bench_press,
                "increment": incre
            ]){ err in
                if let err = err {
                    print("CreatePlanViewController:CreatePlan -> Error writing document: \(err)")
                    return
                } else {
                    print("CreatePlanViewController:CreatePlan -> Document successfully written!")
                }
            }
            labelErrMsg.isHidden = true
            
            //create schedule in histories
            createSchedule(planRef: plan_ref,planID: "plan\(numOfPlan)",
                           planName: plan_name, startDateString: startDate,
                           startSquat: squat, startPress: press,
                           startDeadlift: deadlift, startBenchPress: bench_press, weight: weight)
            
            //back to Home page
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func createSchedule(planRef: CollectionReference, planID: String,
                        planName: String, startDateString: String,
                        startSquat: Double, startPress: Double,
                        startDeadlift: Double, startBenchPress: Double, weight: Double)
    {
        dateFormatter.dateFormat = "MMM d, yyyy"
        let start_date = dateFormatter.date(from: startDateString)!
        var next_date = Date()
        if (startWeekday == "Friday" || startWeekday == "Saturday")
        {
            //jump 3 three days as there is Sunday
            next_date = Calendar.current.date(byAdding: .day, value: 3, to: start_date)!
        } else {
            next_date = Calendar.current.date(byAdding: .day, value: 2, to: start_date)!
        }
        let next_date_str = dateFormatter.string(from: next_date)
        planRef.document("\(planID)").collection("Histories").document("history1").setData([
            "date": startDateString,
            "workout_type": "A",
            "squat": startSquat,
            "squat_status": false,
            "press": startPress,
            "press_status": false,
            "deadlift": startDeadlift,
            "deadlift_status": false,
            "bench_press": startBenchPress,
            "bench_press_status": false,
            "weight": weight,
            "workout_status": "Not started",
            "next_date" : next_date_str
        ])
    }
}
