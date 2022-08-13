import Foundation
import UIKit
import Charts
import TinyConstraints

class ProgressViewController: UIViewController, ChartViewDelegate
{

    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var tblViewRecords: UITableView!
    
    var referenceTimeInterval: TimeInterval = 0
    var entries = [ChartDataEntry]()
    struct Record {
        var date: Date
        var weight: Double
    }
    var fitnessRecords: [Record] = []
    var recordTitleList = ["Squat", "Press", "Deadlift", "Bench Press", "Weight"]
    var selectedDataType = ""
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .darkGray
        
        //y axis
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(entries.count, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .systemYellow
        yAxis.labelPosition = .outsideChart
        
        //x axis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = .white
        xAxis.axisLineColor = .systemPink
        
        // Define chart xValues formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current

        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
        xAxis.valueFormatter = xValuesNumberFormatter
        
        chartView.animate(xAxisDuration: 1.5)
        return chartView
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblViewRecords.delegate = self
        tblViewRecords.dataSource = self
        tblViewRecords.isHidden = true
        
        //put the point-down image on the right side of the text
        btnDropDown.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnDropDown.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnDropDown.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        //locate the chart view
        view.addSubview(lineChartView)
        lineChartView.edgesToSuperview(insets: .top(250) + .left(0) + .right(0))
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        lineChartView.isHidden = true
    }
    
    
    @IBAction func RecordToShow(_ sender: Any)
    {
        if tblViewRecords.isHidden {
            animate(toogle: true)
        } else {
            animate(toogle: false)
        }
    }
    
    func animate(toogle: Bool)
    {
        if toogle
        {
            UIView.animate(withDuration: 0.3){
                self.tblViewRecords.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3){
                self.tblViewRecords.isHidden = true
            }
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    {
        print(entry)
    }
    
    func createDataEntries()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let expDate1 = dateFormatter.date(from: "28/7/22")!
        fitnessRecords.append(Record(date: expDate1, weight: 45.0))
        
        let expDate2 = dateFormatter.date(from: "30/7/22")!
        fitnessRecords.append(Record(date: expDate2, weight: 50.0))
        
        let expDate3 = dateFormatter.date(from: "1/8/22")!
        fitnessRecords.append(Record(date: expDate3, weight: 57.0))
    }
    
    func setData()
    {
        for record in fitnessRecords
        {
                let timeInterval = record.date.timeIntervalSince1970
                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)

                let yValue = record.weight
                let entry = ChartDataEntry(x: xValue, y: yValue)
                entries.append(entry)
        }
        
        let set1 = LineChartDataSet(entries: entries, label: "Weight(lbs)")
        //set1.drawCirclesEnabled = false
        //making line smooth
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(.white)
        set1.fill = Fill(color: .white)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true

        //remove horizontal line of highlight indicator
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemRed

        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
}

extension ProgressViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordTitleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)
        cell.textLabel?.text = recordTitleList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lineChartView.isHidden = false
        createDataEntries()
        setData()
        selectedDataType = recordTitleList[indexPath.row]
        btnDropDown.setTitle("\(selectedDataType)", for: .normal)
        animate(toogle: false)
    }

}
