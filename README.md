TUMitfahrer
===========

[![Build Status](https://travis-ci.org/pkwiecien/tumitfahrer.png?branch=master)](https://travis-ci.org/pkwiecien/tumitfahrer)

TUMitfahrer Web App as well as REST API for mobile clients. Backend is written in Ruby on Rails.

System overview
-------------

![Alt text](https://raw.githubusercontent.com/pkwiecien/tumitfahrer/develop/public/system_diagram.png
"System overview showing interaction of clients with the server")


Development process of TUMitfahrer
---------------------------

![Alt text](https://raw.githubusercontent.com/pkwiecien/tumitfahrer/master/public/development_process_diagram.png
"High level overview of the development process of TUMitfahrer")


Domain Model
------------

Domain model is shown on the class diagram below (click to zoom):
![Alt text](https://github.com/pkwiecien/tumitfahrer/raw/master/public/ClassDiagram.png
"Domain model of TUMitfahrer showing all classes and relationships between them")

Roadmap: 
-------

Elements being implemented:

* backend in Rails and REST API (Pawel)
* iOS app (Pawel)
* web app using Haml/jQuery (Anuradha, Shahid)
* Android app (Abhijith, Amr)
* Pebble app and VisioM intergration(Saqib, Behroz)
* Test framework (Dansen)
* UI and UX (Lukasz)


API Reference
-------------

To use API, use for now http://tumitfahrer-staging.herokuapp.com/.
Each API call starts with `/api/v2` and is followed by a specific verb, e.g. http://tumitfahrer-staging.herokuapp.com/api/v2/rides.

If it's not clear what should be e.g. format of parameters, check out how is the API implemented and try to reverse engineer it. The API functions are [HERE](https://github.com/pkwiecien/tumitfahrer/tree/develop/app/controllers/api/v2). The output of API controllers is defined in serializers [HERE](https://github.com/pkwiecien/tumitfahrer/tree/develop/app/serializers).


Currenlty not all API requests require api_key in request header, however, soon it will be added on backend so it will be required to get a response.

#### Sessions

TUMitfahrer has existing user base of over 1000 users. Their passwords are obviously encrypted and cannot be read. The idea is to create a authentication system that will enable old users as well as new ones to login in. Therefore the authentication mechanism is a bit complex.

To login to TUmitfahrer you need to create a POST request to sessions. In the header `Authorization: Basic`, you should provide encrypted credentials in the form: `base64_encryption(username:sha512_encryption(password+'toj369sbz1f316sx'))`. sha512_encryption is a standard encryption algorithm whose implementation you can find on the Internet, and here it's used to encrypt password with added salt 'toj369sbz1f316sx' (the salt is taken from the old system). `username:sha512_encryption` are again encrypted with base64 encryption.

So to sum up, pass a header in form:
`Authorization: Basic base64_encryption(username:sha512_encryption(password+'toj369sbz1f316sx'))`


Type | URI | Explanation
--- | --- | ---
*POST* | `/sessions` | create a new session for the user. Required header: `email, hashed_password`

#### Users

http://tumitfahrer-staging.herokuapp.com/api/v2/users

To create a new user, create a POST request to `/users`

Type | URI | Explanation
--- | --- | ---
*GET* | `/users` | get all users. Response `{ "users": [ {"id": 1, ...} ] }`. 
*GET* | `/users/1` | get user no. 1. Required header: `Authorization: Basic encrypted_email_and_password`. For encrypted password and email, see above. Response: `{"user": {"id": 1, ...} }`
*POST* | `/users` | create a new user, required parameters as json: `{"user" : { "email" : "xyz@tum.de", "first_name": "Name", "last_name": "Name", "department": department_id}}`  where departmentNo is a number of faculty (faculties are taken is alpabethic order from : http://www.tum.de/en/about-tum/faculties/, so e.g. Architecture has departmentNo `0`)
*PUT* | `/users/1` | update user no. 1. Required header: `Authorization: Basic encrypted_email_and_password`. For encrypted password and email, see above.  Parameters that can be updated: `phone_number:  string, car : string, department : integer, hashed_password : string, password_confirmation : string, first_name : string, last_name : string`. Password and password_confirmation are required parameters.


#### Rides

http://tumitfahrer-staging.herokuapp.com/api/v2/rides

Type | URI | Explanation
--- | --- | ---
*GET* | `/rides?page=0` | get all rides by page.  Response `{ "rides": [ {"id": 1, ...} ] }`. 
*GET* | `/rides?from_date` | get all rides that were updated after `from_date : date, ride_type : integer`. Ride type = 0 is campus ride, ride type = 1 is activity ride.
*GET* | `/rides/ids` | get ids of rides that exists in webservice. This method is called on a mobile client to check which rides should be deleted from the local database
*GET* | `/rides/1` | get ride no. 1.  Response `{ "ride": [ {"id": 1, ...} ] }`. 
*GET* | `/users/1/rides` | get all rides of user no. 1. Optional parameters: `driver=true` returns rides where user is driver. `passenger=true` returns rides where user passenger. `past=true` return all past rides of the user.
*POST* | `/users/1/rides` | create a new ride for user no. 1. This user will become ride owner (it can be ride as driver or ride request). Required header: `api_key: string`, which is api key of this user. Ride params: `"ride" : {"departure_place": string, "destination": string, "departure_time": date, "free_seats" : integer, "meeting_point" : string, "ride_type" : intger (0->campus, 1-> activity), "is_driving" : true, "car" : string, "departure_latitude" : double, "departure_longitude" : double, "destination_latitude": double, "destination_longitude":double }` 
*PUT* | `/users/1/rides/2` | Parameters : `"ride" : {"departure_place": string, "destination": string, "departure_time": date, "free_seats" : integer, "meeting_point" : string, "ride_type" : intger (0->campus, 1-> activity)` 
*PUT* | `/users/1/rides/2?removed_passenger=10` | Update a ride by removing a passenger with a given id.
*DELETE* | `/users/1/rides/2` | delete a ride no. 2 for user no. 1  

#### Devices

Type | URI | Explanation
--- | --- | ---
*GET* | `/users/1/devices` | get all devices of the user no. 1
*POST* | `/users/1/devices` | create a new device for the user no. 1. Parameters `token (string), enabled (boolean), platform (string)`. Platform is one of: `android, ios, windows`

#### Messages

**still needs to be implemented in api/v2**

Type | URI | Explanation
--- | --- | ---
*GET* | `/users/1/messages` | get all messages of user no. 1. Parameters: `receiver_id (integer)`
*GET* | `/users/1/messages/2` | get a specific message for user no 1 from user no 2.
*POST* | `/users/1/messages/` | create a new message for user no. 1. Parameter: `receiver_id (integer), content (string)`
*PUT* | `/messages/1` | update message no. 1 and mark it as seen. Paramter: `is_seen (boolean)`


#### Ratings

**still needs to be implemented in api/v2**

Type | URI | Explanation
--- | --- | ---
*GET* | `/users/1/ratings` | get all ratings (both given and received) of user no 1. Optional parameters: `pending=true (boolean).
*POST* | `/users/1/ratings` | create new rating for user no. 1. Parameters: `to_user_id, ride_id, rating_type`

#### Ride Requests

Type | URI | Explanation
--- | --- | ---
*GET* | `/rides/1/requests/` | Get all requests for a ride with given id.  Response `{ "requests": [ {"id": integer, "passenger_id" : integer, "ride" : Ride, created_at : date, updated_at : date} ] }`. 
*GET* | `/users/1/requests/` | Get all user's requets. Response with Request (see above).
*POST* | `/rides/1/requests` | create a new ride request for a ride no. 1. Parameters: `passenger_id : integer`. Response: newly created Request
*PUT* | `/rides/1/requests` | handle ride request for a ride no. 1. Parameters: `passenger_id : integer, confirmed : boolean`
*DELETE* | `/rides/1/requests` | delete a ride requests for a given ride.

#### Search

Type | URI | Explanation
--- | --- | ---
*POST* | `/search` | search for a ride. Parameters `start_carpool (string), end_carpool (string), ride_date (datetime), ride_type (integer)`


Discarded API calls:
---------------------------

* friend_requests
* friends
* payments
* contributions
* projects
* passnegers

Contributions
-------------

In the architecture diagram I used following icon licensed under Creative Commons Attribution that should be attributed:
* Smart Phone by Emily Haasch from The Noun Project
* Code by buzzyrobot from The Noun Project
* Database by Stefan Parnarov from The Noun Project
* Application by Brian Gonzalez from The Noun Project
* User by Rémy Médard from The Noun Project

