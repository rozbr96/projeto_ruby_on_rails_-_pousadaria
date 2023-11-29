
## Summary

- [API](#api)
  - [List inns](#list-inns)
  - [List Cities](#list-cities)
  - [List City Inns](#list-city-inns)
  - [Search](#search)
  - [View inn details](#view-inn-details)
  - [List inn rooms](#list-inn-rooms)
  - [Room Availability Verification](#room-availability-verification)
  - [Generic Reponses](#generic-responses)
- [TODO](#todo)


## API

### List inns

#### Request
```
GET /api/v1/inns
```


#### Params
```
None
```


#### Response
- **Status Code**: 200

  **Body**: list of existing and active inns

  **Example**:
  ```json
  [
    {
      "id": 1,
      "name": "Moura LTDA",
      "description": "Deserunt provident sapiente. Reiciendis ex consequatur. Quo et explicabo.",
      "pets_are_allowed": false,
      "usage_policies": "Explicabo et necessitatibus. Iste voluptates molestiae. Distinctio sed voluptas.",
      "email": "moura.ltda@blick.example",
      "enabled": true,
      "innkeeper_id": 1,
      "check_in": "2000-01-01T02:23:46.952Z",
      "check_out": "2000-01-01T04:40:34.490Z",
      "created_at": "2023-11-24T05:29:21.810Z",
      "updated_at": "2023-11-24T05:29:21.810Z",
      "score_avg": 2.0,
      "address": {
        "id": 1,
        "street": "Ponte Marli da Conceição",
        "number": 84241,
        "complement": "Casa 2",
        "neighbourhood": "Royal Creek",
        "city": "Brejo Alegre",
        "state": "RR",
        "postal_code": "24560-679",
        "inn_id": 1,
        "created_at": "2023-11-24T05:29:21.825Z",
        "updated_at": "2023-11-24T05:29:21.825Z"
      }
    },
    .
    .
    .
  ]
  ```



### List cities

#### Request
```
GET /api/v1/cities
```


#### Params
```
None
```


#### Response
- **Status Code**: 200

  **Body**: list of cities with existing and active inns

  **Example**:
  ```json
  [
    "Cidade A",
    "Cidade B",
    .
    .
    .
  ]
  ```



### List city inns

#### Request
```
GET /api/v1/city/:city/inns
```


#### Params
- city

  **type**: string

  **location**: path

  **description**: the city in which you wanna search for inns


#### Request example
```sh
curl "http://host_api:port_api/api/v1/cities/Cidade Alfa/inns"
```


#### Response
- **Status Code**: 200

  **Body**: list of existing and active inns in the given city

  **Example**:
  ```json
  [
    {
      "id": 1,
      "name": "Moura LTDA",
      "description": "Deserunt provident sapiente. Reiciendis ex consequatur. Quo et explicabo.",
      "pets_are_allowed": false,
      "usage_policies": "Explicabo et necessitatibus. Iste voluptates molestiae. Distinctio sed voluptas.",
      "email": "moura.ltda@blick.example",
      "enabled": true,
      "innkeeper_id": 1,
      "check_in": "2000-01-01T02:23:46.952Z",
      "check_out": "2000-01-01T04:40:34.490Z",
      "created_at": "2023-11-24T05:29:21.810Z",
      "updated_at": "2023-11-24T05:29:21.810Z",
      "score_avg": 2.0,
      "address": {
        "id": 1,
        "street": "Ponte Marli da Conceição",
        "number": 84241,
        "complement": "Casa 2",
        "neighbourhood": "Royal Creek",
        "city": "Cidade Alfa",
        "state": "RR",
        "postal_code": "24560-679",
        "inn_id": 1,
        "created_at": "2023-11-24T05:29:21.825Z",
        "updated_at": "2023-11-24T05:29:21.825Z"
      }
    },
    .
    .
    .
  ]
  ```



### Search

#### Request
```
GET /api/v1/search
```


#### Params
- search_for

  **type**: string

  **location**: query

  **description**: the term to search for


#### Request example
```sh
curl "http://host_api:port_api/api/v1/search?search_for=moura"
```


#### Response
- **Status Code**: 200

  **Body**: list of found and active inns

  **Example**:
  ```json
  [
    {
      "id": 1,
      "name": "Moura LTDA",
      "description": "Deserunt provident sapiente. Reiciendis ex consequatur. Quo et explicabo.",
      "pets_are_allowed": false,
      "usage_policies": "Explicabo et necessitatibus. Iste voluptates molestiae. Distinctio sed voluptas.",
      "email": "moura.ltda@blick.example",
      "enabled": true,
      "innkeeper_id": 1,
      "check_in": "2000-01-01T02:23:46.952Z",
      "check_out": "2000-01-01T04:40:34.490Z",
      "created_at": "2023-11-24T05:29:21.810Z",
      "updated_at": "2023-11-24T05:29:21.810Z",
      "score_avg": 2.0,
      "address": {
        "id": 1,
        "street": "Ponte Marli da Conceição",
        "number": 84241,
        "complement": "Casa 2",
        "neighbourhood": "Royal Creek",
        "city": "Brejo Alegre",
        "state": "RR",
        "postal_code": "24560-679",
        "inn_id": 1,
        "created_at": "2023-11-24T05:29:21.825Z",
        "updated_at": "2023-11-24T05:29:21.825Z"
      }
    },
    .
    .
    .
  ]
  ```



### View Inn Details

#### Request
```
GET /api/v1/inns/:inn_id
```


#### Params
- inn_id

  **type**: integer

  **location**: path

  **description**: the id of the inn you wanna see the details


#### Response
- **Status Code**: 200

  **Body**: the details of the inn

  **Example:**
  ```json
  {
    "id": 1,
    "name": "Moura LTDA",
    "description": "Deserunt provident sapiente. Reiciendis ex consequatur. Quo et explicabo.",
    "pets_are_allowed": false,
    "usage_policies": "Explicabo et necessitatibus. Iste voluptates molestiae. Distinctio sed voluptas.",
    "email": "moura.ltda@blick.example",
    "enabled": true,
    "innkeeper_id": 1,
    "check_in": "2000-01-01T02:23:46.952Z",
    "check_out": "2000-01-01T04:40:34.490Z",
    "created_at": "2023-11-24T05:29:21.810Z",
    "updated_at": "2023-11-24T05:29:21.810Z",
    "score_avg": 2.0,
    "address": {
      "id": 1,
      "street": "Ponte Marli da Conceição",
      "number": 84241,
      "complement": "Casa 2",
      "neighbourhood": "Royal Creek",
      "city": "Brejo Alegre",
      "state": "RR",
      "postal_code": "24560-679",
      "inn_id": 1,
      "created_at": "2023-11-24T05:29:21.825Z",
      "updated_at": "2023-11-24T05:29:21.825Z"
    }
  }
  ```



### List Inn Rooms

#### Request
```
GET /api/v1/inns/:inn_id/rooms
```


#### Params
- inn_id

  **type**: integer

  **location**: path

  **description**: the id of the inn you wanna see the rooms of


#### Response
- Status Code: 200
- Body: list of existing and active rooms of the inn with the given id
- Example:
  ```json
  [
    {
      "id": 6,
      "name": "Maya Ribeira",
      "description": "Incidunt at saepe. Distinctio quae id. Quis ut deserunt.",
      "dimension": 142,
      "price": 92929,
      "maximum_number_of_guests": 9,
      "number_of_bathrooms": 1,
      "number_of_wardrobes": 0,
      "has_balcony": false,
      "has_tv": false,
      "has_air_conditioning": false,
      "has_vault": true,
      "is_accessible_for_people_with_disabilities": true,
      "enabled": true,
      "inn_id": 2,
      "created_at": "2023-11-24T05:29:22.283Z",
      "updated_at": "2023-11-24T05:29:22.283Z"
    },
    .
    .
    .
  ]
  ```



### Room Availability Verification

#### Request
```
GET /api/v1/rooms/:room_id/availability
```


#### Params
- room_id

  **type**: integer

  **location**: path

  **description**: the id of the room you wanna check the availability for

- start_date

  **type**: string

  **location**: query

  **description**: the start date, in the format yyyy-mm-dd, of the period you wanna check the availability for
  **example**: 2023-03-16

- end_date

  **type**: string

  **location**: query

  **description**: the end date, in the format yyyy-mm-dd, of the period you wanna check the availability for
  **example**: 2023-12-06

- guests_number

  **type**: integer

  **location**: query

  **description**: the number of guests intented to be hosted


#### Request example
```sh
curl "http://host_api:port_api/api/v1/rooms/1/availability?start_date=2023-01-10&end_date=2023-01-23&guests_number=2"
```


#### Response
- **Status Code**: 200

  **Description**: success with the verification

  **Body**: the estimated price (in real) for the booking OR the reason not to be able to book with the given params, ALONG with a value indicating if such room is available or not

  **Examples**:

  - available room
    ```json
    {
      "available": true,
      "estimated_price": 12963.58
    }
    ```

  - unavailable room
    ```json
    {
      "available": false,
      "reason": "Período de reserva está sobrepondo algum outro período..."
    }
    ```

- **Status Code**: 400

  **Description**: error within the given params

  **Body**: an error array with the errors found in the provided params

  **Example**:

  ```json
  {
    "errors": [
      "Número de Convidados excede a quantidade máxima permitida pelo quarto"
    ]
  }
  ```



### Generic Responses

- **Status Code**: 404

  **Description**: the requested resource or some other resource required for the requested resource(s) could not be found

  **Body**: None


## TODO
  - [    ] fix some creation/editon logics
    - [    ] inn
      - [    ] phone numbers
        - [    ] deletion
        - [    ] ensure at least one is being saved

  - [    ] frontend (almost everything, since no much work has been done regarding the frontend)
    - [ ✅ ] pages structures
    - [    ] use better input fields according for some fields
    - [    ] use some styles
    - [    ] use some icons
    - [    ] enable dark theme
    - [    ] display errors close to their related fields
    - [    ] add meaningful descriptions for some boolean values
    - [    ] auto format some input values
      - [    ] inn
        - [    ] registration_number
        - [    ] postal_code
      - [    ] inn room
        - [    ] price
    - [    ] dynamically search for the address data by the given postal code
    - [    ] add some pre/append label icons to some input fields


  - [    ] some extra ideas
    - [    ] inn rooms
      - [    ] add photos upload capability
