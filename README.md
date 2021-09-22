###  Besty Esty
## Table of contents
* [General info](#general-info)
* [Screenshots](#screenshots)
* [Learning Goals](#learning-goals)
* [Technologies](#technologies)
* [Setup](#setup)
* [Features](#features)
* [Status](#status)
* [Contact](#contact)

## General info
Besty Esty is a 10 day, 4 person group project that builds a fictitious e-commerce platform where merchants and admins can manage inventory and fulfill customer invoices.
## Screenshots

![besty_esty_invoice_show](https://user-images.githubusercontent.com/81711519/134426268-3bf2ee74-2b10-4249-a18b-7a1d95e7fa77.jpg)
<img width="1912" alt="Screen Shot 2021-09-22 at 4 39 53 PM" src="https://user-images.githubusercontent.com/81711519/134426308-7dd21f0f-a80c-4a3a-bed9-b755decd1520.png">

## Benchmark Achievements
* Designed a normalized database schema and defining model relationships.
* Utilized advanced routing techniques including namespacing to organize and group like functionality together.
* Utilized advanced ActiveRecord and SQL techniques to perform complex database queries.
* Consumed a public API utilizing facades and services with query results saved and updated through caching.

## Technologies
Project is created with:
* Ruby version: 2.7.2
* Rails 5.2.5
* HTML 5
* Heroku
* Primary Gems: Faraday, RSpec, Capybara, SimpleCov, Webmock

## Setup
To run this program, save a copy of this repository locally. In the MacOS
application 'Terminal,' navigate into the `little-esty-shop` directory.
Then, run it using ruby (note: '$' is not typed).
1. Clone the repo using the web url:
   ```
   $ git clone https://github.com/TannerDale/little-esty-shop.git
   ```
   or with a password-protected SSH key:
   ```
   $ git clone git@github.com:TannerDale/little-esty-shop.git
   ```
2. Change into the directory:
   ```
   $ cd ./little-esty-shop
   ```
3. Enable development caching:
   ```
   $ rails dev:cache
   ```
4. Then enable server by entering the following into Terminal:
   ```
   $ rails s
   ```
5. Then open a browser and navigate to:
   ```
   localhost:3000
   ```

## Features
* GitHub API continuously updated to ensure accurate data.
* Merchant dashboard and password protected admin dashboard.


## Future Enhancements:
* Optimize user interface

## Contact
Created by
* [@TannderDale](https://github.com/TannerDale)
* [@cdelpone](https://github.com/cdelpone)
* [@jamiejpace](https://github.com/jamiejpace)
* [@mekimball](https://github.com/matthewjholmes)

Feel free to contact us!
