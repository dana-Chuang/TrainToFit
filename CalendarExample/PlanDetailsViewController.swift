import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class PlanDetailsViewController: UIViewController
{
    @IBOutlet weak var labelPlanName: UILabel!
    @IBOutlet weak var editPlanButton: UIButton!
    @IBOutlet weak var labelStartWeight: UILabel!
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelSchedule: UILabel!
    @IBOutlet weak var labelStartSquat: UILabel!
    @IBOutlet weak var labelStartPress: UILabel!
    @IBOutlet weak var labelStartDeadlift: UILabel!
    @IBOutlet weak var labelStartBenchPress: UILabel!
    @IBOutlet weak var labelIncrement: UILabel!
    @IBOutlet weak var completePlanButton: UIButton!
    
    var planID = ""
    var planName = ""
    var db: Firestore!
    let uid : String = (Auth.auth().currentUser?.uid)!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        db = Firestore.firestore()
        labelPlanName.text = planName
    }
    
    @IBAction func completePlan(_ sender: Any)
    {
        db.collection("Accounts").document("\(uid)").collection("plans").document("\(planID)").updateData([
            "status": "Completed"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document: status statement successfully updated")
            }
        }
        //back to the previous view controller
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editPlan(_ sender: Any)
    {
        if let viewController = storyboard?.instantiateViewController(identifier: "edit_plans") as? EditPlanViewController {
            viewController.planID = planID
            viewController.planName = labelPlanName.text!
            viewController.weight = Double(labelStartWeight.text!)!
            viewController.start_date = labelStartDate.text!
            viewController.squat = Double(labelStartSquat.text!)!
            viewController.press = Double(labelStartPress.text!)!
            viewController.deadlift = Double(labelStartDeadlift.text!)!
            viewController.benchPress = Double(labelStartBenchPress.text!)!
            viewController.increment = Double(labelIncrement.text!)!
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
