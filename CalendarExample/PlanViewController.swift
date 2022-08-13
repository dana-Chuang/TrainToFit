import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class PlanViewController: UIViewController
{
    var db: Firestore!
    @IBOutlet weak var planTableView: UITableView!
    var plan_IDs: [String] = []
    var plan_names: [String] = []
    var create_dates: [String] = []
    var plan_status: [String] = []
    let uid : String = (Auth.auth().currentUser?.uid)!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        db = Firestore.firestore()
        planTableView.delegate = self
        planTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        plan_IDs.removeAll()
        plan_names.removeAll()
        create_dates.removeAll()
        plan_status.removeAll()
        fetchData()
    }
    
    func fetchData()
    {
        db.collection("Accounts").document("\(uid)").collection("plans").getDocuments(){(querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                self.plan_IDs.append("\(document.documentID)")
                self.plan_names.append("\(document.data()["plan_name"] as? String ?? "Anonymous")")
                self.create_dates.append("\(document.data()["create_date"] as? String ?? "Anonymous")")
                self.plan_status.append("\(document.data()["status"] as? String ?? "Anonymous")")
            }
            self.planTableView.reloadData()
        }}
    }
    
    @IBAction func CreateNewPlan(_ sender: Any)
    {
        if let viewController = storyboard?.instantiateViewController(identifier: "create_plan") as? CreatePlanViewController {
                   viewController.numOfPlan = plan_IDs.count
                   navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension PlanViewController: UITableViewDelegate
{
    //respond to row selections
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //shift to plan details page
        if let viewController = storyboard?.instantiateViewController(identifier: "plan_details") as? PlanDetailsViewController {
            let plan_id = plan_IDs[indexPath.row]
            let plan_name = plan_names[indexPath.row]
            let status = plan_status[indexPath.row]
            viewController.planName = plan_name
            viewController.planID = plan_id
            db.collection("Accounts").document("\(uid)").collection("plans").document("\(plan_id)").getDocument{ (document, error) in
                if let document = document, document.exists {
                    viewController.labelStartWeight.text = "\(document.data()?["start_weight"] ?? "Anonymous")"
                    let create_date_string = document.data()?["start_date"] as? String ?? "Anonymous"
                    viewController.labelStartDate.text = create_date_string
                    viewController.labelStartSquat.text = "\(document.data()?["start_squat"] ?? "Anonymous")"
                    viewController.labelStartPress.text = "\(document.data()?["start_press"] ?? "Anonymous")"
                    viewController.labelStartDeadlift.text = "\(document.data()?["start_deadlift"] ?? "Anonymous")"
                    viewController.labelStartBenchPress.text = "\(document.data()?["start_bench_press"] ?? "Anonymous")"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    dateFormatter.dateFormat = "MMM d, yyyy"
                    let date = dateFormatter.date(from:create_date_string)!
                    dateFormatter.dateFormat = "EEEE"
                    let weekday = dateFormatter.string(from:date)
                    if (weekday == "Monday" || weekday == "Wednesday" || weekday == "Friday")
                    {
                        viewController.labelSchedule.text = "Mon/Wed/Fri"
                    } else {
                        viewController.labelSchedule.text = "Tue/Thu/Sat"
                    }
                    
                    //default, fixed
                    viewController.labelIncrement.text = "5.0"
                    
                    //disable completePlanButton and editPlanButton if the plan status is "Completed"
                    if (status == "Completed")
                    {
                        viewController.completePlanButton.isEnabled = false
                        viewController.editPlanButton.isEnabled = false
                    }else {
                        viewController.completePlanButton.isEnabled = true
                        viewController.editPlanButton.isEnabled = true
                    }
                    
                } else {
                    print("Document does not exist")
                }
            }
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

}

extension PlanViewController: UITableViewDataSource
{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return plan_IDs.count
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell") as! PlanTableViewCell
            let plan_name = plan_names[indexPath.row]
            let create_date = create_dates[indexPath.row]
            let status = plan_status[indexPath.row]
            cell.planName?.text = plan_name
            cell.planCreateDate?.text = create_date
            cell.statusLabel?.text = status
            
            if (status == "Completed")
            {
                cell.statusView.backgroundColor = UIColor.systemRed
            } else {
                cell.statusView.backgroundColor = UIColor.systemYellow
            }
            return cell
        }
}
