# Glassbottle

Glassbottle is an app that works across all iOS devices that allows users to scan any cosmetic or skincare product, and then break down and learn exactly how safe or harmful that product truly is, by analyzing each and every one of its complicated chemical ingredients. This allows users to actually understand what they're using and applying on their body, and choose the best & safest option for themselves.

Glassbottle was made with **Swift** as its primary language.

## Technologies

Glassbottle uses **Machine Learning** (**Vision** Framework + custom-trained **NLP Classification Algorithm**), Camera Operations, **Realm Sync**, a webscraper (using **SwiftSoup**), **MongoDB Atlas**, various databases & APIs, and an interactive UI in order to perform its various operations. 

## Features
* Trained a Barcode Scanner using Vision & Device Camera Operations that accesses UPC (Universal Product Code) from camera/photo and generates product       information.
* Created a dynamic database that globally persists itself on every user's phone using Realm Sync and MongoDB Atlas, which allows for a quick query time of   previously scanned ingredients. This is so that, if there are similar/same ingredients in a newly scanned product then there's no need for 2 of the same
  ingredients to exist within the database.
* Used SwiftSoup to create a web scraping algorithm to parse loads of medical information online on each product ingredient and uses a custom made Natural Language Processing classification model to evaluate product harm level.
* Integrated an interactive and dynamic storyboard UI using CocoaPods and Swift UI elements, with a full product breakdown and ingredient list of harmful ingredients.

## Demo

![Alt Text](https://media0.giphy.com/media/ciCgnNUnvbUQ0agxBG/giphy.gif?cid=790b76111908da5dc9352765dd79bd1edb536ceae91c51da&rid=giphy.gif&ct=g)
