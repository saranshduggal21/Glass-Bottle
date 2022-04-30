//
//  RealmDatabase.swift
//  Glass Bottle
//
//  Created by Saransh Duggal on 2022-04-27.
//

import UIKit
import RealmSwift

class RealmDatabase {
    
    let app: App
    var realmDatabase: Realm
    var token: NotificationToken?
    var productIngredients: [String]
    var realmQueue: DispatchQueue
    
    init(realm database: Realm, notificationToken token: NotificationToken?, ingredients productIngredients: [String], queue realmQueue: DispatchQueue) {
        self.app = App(id: "glassbottle-development-jszia")
        self.realmDatabase = database
        self.token = token
        self.productIngredients = productIngredients
        self.realmQueue = realmQueue
    }
    
    //Getting t he realm objects of type "Ingredient" from the opened Realm App (cloud) setting it equal to an array "realmIngredients"
    lazy var realmIngredients = realmDatabase.objects(Ingredient.self)
    
    
    //MARK: Authenticate Anonymous User
    //Initializing Realm app with the id registered on MongoDB website, then we need authentication in Realm Sync to work; thus use simple anonymizing authentication. Since we need all users to have read and write functionality on the whole database of harmful ingredients in order to compare with their products this is the easiest way to do it, even though not too secure -- our app isn't going into development so its fine.
    func runApp(){
        
        app.login(credentials: Credentials.anonymous) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                    case .failure(let error):
                        print("Login failed: \(error)")
                        
                    case .success(let user):
                        print("Successful Anonymous Login")
                        
                        //FILE LOCATION OF THE REALM CONFIG (LOCAL)
                        //  print(Realm.Configuration.defaultConfiguration.fileURL!) in case it is corrupted
                        
                        self.realmQueue.async {
                            //Put the code here
                            self.onLogin()
                        }
                }
            }
        }
    }
    
    
    //MARK: Opening Realm Asynchronously VIA asyncOpen
    
    func onLogin(){
        
        //Set the configuration, technically "redundant" since all configs are the same, but calls the function "setDefaultConfiguration"
        if let user = app.currentUser{
            setDefaultConfiguration(forUser: user)
        }
        
        // Open the realm asynchronously to ensure backend data is downloaded first.
        Realm.asyncOpen { (result) in
            switch result {
                case .failure(let error):
                    print("Failed to open realm: \(error.localizedDescription)")
                    
                case .success(let realm):
                    print("Successful Async Realm Open")
                    
                    self.realmQueue.async {
                        // Realm opened
                        self.onRealmOpened()
                    }
            }
        }
    }
    
    
    func onRealmOpened() {
        //Current way to reload the data once the realm opens, required as first calling a lazy var it will have no objects in its current assignment if we print it to screen, so this is required for population of data.
        print("Hi")
        if !(realmIngredients.isEmpty) {
            @ThreadSafe var realmIngredientsReference = realmIngredients
            print("Yes")
            self.realmQueue.async { [self] in
                print("Hello")
                guard var safeRealmIngredients = realmIngredientsReference
                else {
                    fatalError("Error.")
                }
                safeRealmIngredients = realmDatabase.objects(Ingredient.self)
                print("Bye")
                
                //MARK: Start Notification Observations
                //This section is simply to check for any dynamic changes to the Realm, typically this would also be in a proper handler to handle updating to the UI, in  this case we don't have live changes to data so there wouldn't be much to do here.
                // Retain notificationToken as long as you want to observe
                if let safeRealmReference = realmIngredientsReference {
                    DispatchQueue.main.sync { [self] in
                        self.token = safeRealmReference.observe { (changes) in
                            switch changes {
                                case .initial: break
                                    // Results are now populated and can be accessed without blocking the UI
                                case .update(_, let deletions, let insertions, let modifications):
                                    // Query results have changed.
                                    print("Deleted indices: ", deletions)
                                    print("Inserted indices: ", insertions)
                                    print("Modified modifications: ", modifications)
                                case .error(let error):
                                    // An error occurred while opening the Realm file on the background worker thread
                                    fatalError("\(error.localizedDescription)")
                            }
                        }
                        
                        print("The Realm has finished loading...")
                        
                        
                        //MARK: Checking Contents of Realm Database
                        //Printing the current database of ingredients
                        print("A list of all ingredients: \(realmIngredients)")
                        
                        runProductAnalysis()
                    }
                }
                }
            }
        
    }
    
    
    
    
    //MARK: Sync Configuration from User Object.
    func setDefaultConfiguration(forUser user: User) {
        // The partition determines which subset of data to access.
        let partitionValue = "glassbottle-development-jszia" //setting the realm_id to the partition, meaning every anonymous user will read/write to the same collection of all ingredient data (no partitioning)
        
        //This is where you can set any forms for configurations for a new logged in user, for example partitioning
        Realm.Configuration.defaultConfiguration = user.configuration(partitionValue: partitionValue)
    }
    
    
    
    
    //MARK: Product Ingredient Analysis
    func runProductAnalysis(){
        var ingredientNumber = 0
        var harmfulIngredientsNumber = 0
        var safeIngredientsNumber = 0
        
        for ingredient in productIngredients {
            ingredientNumber += 1
            
            //Filter by the current ingredient in the Cosmetic Product's ingredient list
            let ingredientQueriedArray = realmIngredients.where {
                $0.name == ingredient
            }
            
            //If there aren't any ingredients by that name, we have to refer to the NLP qeury
            if ingredientQueriedArray.isEmpty {
                
                //runScrapeandNLP()
                continue
            }
            else {
                let ingredientQueried = ingredientQueriedArray[0]
                
                //Check the isHarmful status in the Atlas collection, for now have it be binary true/false value
                if (ingredientQueried.isHarmful == true) {
                    harmfulIngredientsNumber += 1
                }
                else {
                    safeIngredientsNumber += 1
                }
            }
            
        }
        
        print("Number of Ingredients: \(ingredientNumber)")
        print("Number of Harmful Ingredients: \(harmfulIngredientsNumber)")
        print("Number of Nonharmful Ingredients: \(safeIngredientsNumber)")
        
        
    }
    
}
