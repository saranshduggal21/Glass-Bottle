//
//  ViewController2.swift
//  Glass Bottle


import UIKit
import Charts
import RealmSwift

class ViewController2: UIViewController {
    var realm = try! Realm()
    lazy var ingredients = realm.objects(Ingredient.self)
    var productIngredients: [String] = []
    var productName = ""
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pieChart: PieChartView!
    var HarmfulIngredientEntry = PieChartDataEntry(value: 0)
    var SafeIngredientEntry = PieChartDataEntry(value: 0)

    var numberOfIngredientsDataEntries = [PieChartDataEntry]()
    
    @IBOutlet weak var isHarmfulLabel: UILabel!
    @IBOutlet weak var productNameTitleLabel: UILabel!
    @IBOutlet weak var productHealthGradeTitleLabel: UILabel!
    @IBOutlet weak var productIsHealthyTitleLabel: UILabel!
    @IBOutlet weak var usabilityHarmfulNumberTitleLabel: UILabel!
    @IBOutlet weak var usabilityIsBetterTitleLabel: UILabel!
    @IBOutlet weak var backgroundGradientView: UIView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)

        // Create a gradient layer.
        let gradientLayer = CAGradientLayer()
        // Set the size of the layer to be equal to size of the display.
        gradientLayer.frame = view.bounds
        // Set an array of Core Graphics colors (.cgColor) to create the gradient.
        // This example uses a Color Literal and a UIColor from RGB values.
        gradientLayer.colors = [#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1).cgColor, UIColor(red: 121/255, green: 126/255, blue: 246/255, alpha: 1).cgColor]
        // Rasterize this static layer to improve app performance.
        gradientLayer.shouldRasterize = true
        // Apply the gradient to the backgroundGradientView.
        backgroundGradientView.layer.addSublayer(gradientLayer)
    }
    
    
    func runProductAnalysis(){
        var ingredientNumber = 0
        var harmfulIngredientNumber = 0
        var nonHarmfulIngredientNumber = 0
        
        for ingredient in productIngredients {
            ingredientNumber += 1
            
            //Filter by the current ingredient in the Cosmetic Product's ingredient list
            let ingredientQueriedArray = ingredients.where {
                        $0.name == ingredient
            }
            
            //If there aren't any ingredients by that name, we have to refer to the NLP qeury
            if ingredientQueriedArray.isEmpty {
                
                //runScrapandNLP()
                continue
            }
            else {
                let ingredientQueried = ingredientQueriedArray[0]
                
                //Check the isHarmful status in the Atlas collection, for now have it be binary true/false value
                if (ingredientQueried.isHarmful == true) {
                    harmfulIngredientNumber += 1
                }
                else {
                    nonHarmfulIngredientNumber += 1
                }
            }
            
        }
        
        
        
        //Logic for UI
        var analysisDict = [100: "A",
                            90: "B",
                            80: "C",
                            70: "D"]
        
        var percentSafe = Int(nonHarmfulIngredientNumber/ingredientNumber)*100
        
        print("Number of Ingredients: \(ingredientNumber)")
        print("Number of Harmful Ingredients: \(harmfulIngredientNumber)")
        print("Number of Nonharmful Ingredients: \(nonHarmfulIngredientNumber)")
        
        print("% Safe of Product: \(percentSafe)")
        
        var productGrade = analysisDict[percentSafe]
        
        //Display UI Labels
        productHealthGradeTitleLabel.text = productGrade
        //Set product name label to product title
        productNameTitleLabel.text = productName
        if productGrade == "A" {
            isHarmfulLabel.text = "Safe"
            isHarmfulLabel.textColor = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1)
            productIsHealthyTitleLabel.text = "Healthy"
            usabilityIsBetterTitleLabel.text = "Better than most"
        }
        else {
            isHarmfulLabel.text = "Harmful"
            isHarmfulLabel.textColor = UIColor(red: 217/255, green: 33/255, blue: 33/255, alpha: 1)
            productIsHealthyTitleLabel.text = "Unhealthy"
            usabilityIsBetterTitleLabel.text = "Worse than most"
        }
        usabilityHarmfulNumberTitleLabel.text = "There are \(harmfulIngredientNumber) harmful ingredients."

        pieChart.chartDescription.text = ""
        
        HarmfulIngredientEntry.value = Double(harmfulIngredientNumber)
        HarmfulIngredientEntry.label = "Harmful"
        SafeIngredientEntry.value = Double(nonHarmfulIngredientNumber)
        SafeIngredientEntry.label = "Safe"
        
        numberOfIngredientsDataEntries = [HarmfulIngredientEntry, SafeIngredientEntry]
        updateChartData()
    }
    
    func updateChartData() {
        let chartDataSet = PieChartDataSet(entries: numberOfIngredientsDataEntries, label: "Product Ingredients")
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1), UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)]
        chartDataSet.colors = colors
        
        pieChart.data = chartData
    }
}
