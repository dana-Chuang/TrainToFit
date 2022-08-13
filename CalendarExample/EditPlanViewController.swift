import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditPlanViewController: UIViewController
{
    @IBOutlet weak var txtFieldPlanName: UITextField!
    @IBOutlet weak var txtFieldWeight: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var txtFieldSquat: UITextField!
    @IBOutlet weak var txtFieldPress: UITextField!
    @IBOutlet weak var txtFieldDeadlift: UITextField!
    @IBOutlet weak var txtFieldBenchPress: UITextField!
    @IBOutlet weak var txtFieldIncrement: UITextField!
    
    var planID = ""
    var planName = ""
    var weight = Double()
    var start_date = ""
    var squat = Double()
    var press = Double()
    var deadlift = Double()
    var benchPress = Double()
    var increment = Double()
    var db: Firestore!
    let uid : String = (Auth.auth().currentUser?.uid)!
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        db = Firestore.firestore()
        changePlaceHolderText()
    }
    
    func changePlaceHolderText()
    {
        txtFieldPlanName.text = planName
        txtFieldWeight.text = String(weight)
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        let date = dateFormatter.date(from:start_date)!
        startDatePicker.date = date
        
        txtFieldSquat.text = String(squat)
        txtFieldPress.text = String(press)
        txtFieldDeadlift.text = String(deadlift)
        txtFieldBenchPress.text = String(benchPress)
        txtFieldIncrement.text = String(increment)
    }
    
    @IBAction func savePlan(_ sender: Any)
    {
        guard let edit_name = txtFieldPlanName.text, !edit_name.isEmpty, !(edit_name.contains("/")),
              let edit_weight = Double(txtFieldWeight.text!), !edit_weight.isNaN,
              let edit_squat = Double(txtFieldSquat.text!), !edit_squat.isNaN,
              let edit_press = Double(txtFieldPress.text!), !edit_press.isNaN,
              let edit_deadlift = Double(txtFieldDeadlift.text!), !edit_deadlift.isNaN,
              let edit_bench_press = Double(txtFieldBenchPress.text!), !edit_bench_press.isNaN,
              let edit_increments = Double(txtFieldIncrement.text!), !edit_increments.isNaN
        else {
            print("Missing field data or incorrect inputs")
            return
        }
        start_date = dateFormatter.string(from: startDatePicker.date)
        db.collection("Accounts").document("\(uid)").collection("plans").document("\(planID)").updateData([
            "plan_name" : edit_name,
            "start_weight" : edit_weight,
            "start_date" : start_date,
            "start_squat" : edit_squat,
            "start_press" : edit_press,
            "start_deadlift" : edit_deadlift,
            "start_bench_press" : edit_bench_press,
            "increments" : edit_increments
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document: plan details successfully updated")
            }
        }
        if let viewController = storyboard?.instantiateViewController(identifier: "plans_view") as? PlanViewController
        {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
