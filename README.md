# Glassbottle

Glass Bottle is an app that works across all iOS devices that allows users to scan any cosmetic or skincare product, and then break down and learn exactly how safe or harmful that product truly is, by analyzing each and every one of its complicated chemical ingredients. This allows users to actually understand what they're using and applying on their body, and choose the best & safest option for themselves.

Glass Bottle was made with **Swift** as its primary language.

Glass Bottle uses **Machine Learning** (**Vision** Framework + custom-trained **NLP Classification Algorithm**), Camera Operations, **Realm Sync** (for a dynamic database that updates on every user's phone), a webscraper (using **SwiftSoup**), **MongoDB Atlas**, various databases & APIs, and an interactive UI in order to perform its various operations. 

## Features
* Barcode scanner that accesses UPC (Universal Product Code) from the camera and generates product information
* Uses web scraping to parse medical information online on each product ingredient and uses a Natural Language Processing model to evaluate harm
* Retrieves and sends ingredient information from a MongoDB database for quick lookup of previously scanned ingredients
* Dynamic storyboard UI with product breakdown and ingredient list
