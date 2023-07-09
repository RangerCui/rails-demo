# Rails-Demo 🚒

## intro

demo integrating rails, swagger, grape, rspec，Some details are still needed

### Technical framework

- Development language: ruby 2.7.3
- Application framework: rails 6
- Interface service: Grape
- Relational database: Mysql
- Task queue: Sidekiq

## activate

```sh
# 0. Pull the item
git clone git@github.com:RangerCui/rails-demo.git

# 1. Install the corresponding ruby version, using rvm as an example
rvm install 2.7.3 # Refer to the version in the.ruby-version file

# 3. Replace the default Settings locally
cp config/settings/application.yml.sample config/settings/application.yml

# 4. Start the service (interface service domain name is localhost:3000)
rails s

```

<br />

## Static check

This project through [rubocop] (https://github.com/rubocop/rubocop) as a static checking tool

## Basic system module flow design drawing
View file **system_flow_chart.puml**


> Developer Environment Installation > VSCode Users

## Method annotation

Format requirements are as follows

```ruby
#
# Methods a phrase to describe
#
# @param [Type] foo Parameter description
#
# @return [Type] result description
#
def hoge(foo)
  return 'bar'
end
```

<br />

For the class you create, you also need to write a document, just add the class description and author, the format is as
follows

```ruby
#
# Such a phrase to describe
#
# @author author
#
class HogeCommand
end
```

If you are developing using VSCode, you can download it[Yard Document]
> VSCode User

After installation, you can quickly generate method and class comments by using shortcut keys. First, move the cursor
over the method/class name of the document you want to generate and press the shortcut keys

- mac user: `cmd+option+enter`
- win user: `ctrl+alt+enter`

## UT

```sh
# Run the following command to view the UT coverage
pen coverage/index.html
```

```sh
# run test
rspec spec/example/bank_account_spec.rb -f d
```

# API v1

The API documentation below describes the endpoints and parameters available in this version of the API.

## summary API

#### monthly summary
Design idea:
* Create intermediate tables monthly_summaries and call the app/jobs/monthly_summary_job.rb at 11:00 on the last day of each month to collect monthly data
#### annual summary
Design idea:
* Create intermediate annual_summaries and call app/jobs/annual_summary_job.rb at 11pm on the last day of the year to summarize annual data

## Base URL

```
http://localhost:3000/api/v1
```

## User

Operations about users

### Get User Info Search

```
GET /user/info/search
```

Search user info

#### Parameters

| Name    | Type    | Required | Description         |
|---------|---------|----------|---------------------|
| user_id | integer | True     | Need search user id |

#### Responses

| Status Code | Description                   |
|-------------|-------------------------------|
| 10000       | Request successful            |
| 100         | Interface parameter exception |
| 300         | Data check failure            |
| 500         | Service exception             |

```
{
  "code": 10000,
  "message": "Request successful",
  "data": {
    "user_info": {
      "id": 1,
      "name": "Bob",
      "email": "bob@gamil.com"
    },
    "account_info": {
      "id": 1,
      "balance": 10.0,
      "status": "activated"
    },
    "order_info": [
      {
        "id": 1,
        "actual_return_time": null,
        "amount": 0.0,
        "borrowed_at": null,
        "estimated_return_time": "2023-07-02T23:34:04.000+08:00",
        "status": "returned",
        "book_id": 1
      },
      {
        "id": 2,
        "actual_return_time": null,
        "amount": 0.0,
        "borrowed_at": "2023-07-03T22:31:52.000+08:00",
        "estimated_return_time": null,
        "status": "borrowed",
        "book_id": 1
      }
    ]
  },
  "timestamps": 1688569604
}
```

### Set User Amount

```
POST /user/manage/set_user_amount
```

Set the user account amount

#### Parameters

| Name    | Type    | Required | Description           |
|---------|---------|----------|-----------------------|
| user_id | integer | True     | Need set user id      |
| balance | number  | True     | Need set user balance |

#### Responses

| Status Code | Description                   |
|-------------|-------------------------------|
| 10000       | Request successful            |
| 100         | Interface parameter exception |
| 300         | Data check failure            |
| 500         | Service exception             |

```
{
  "code": 10000,
  "message": "Request successful",
  "data": {
    "id": 1,
    "name": "Bob",
    "email": "bob@gamil.com"
  },
  "timestamps": 1688569754
}
```

## Borrow

Operations about borrows

### Post Borrow Create Borrow Book Order

```
POST /borrow/create_borrow_book_order
```

Borrow books

esign idea:
Considering that the volume of book collection in the library reaches a certain level, when a large number of concurrent requests enter the server, the response time of reducing the corresponding book inventory will be prolonged, so the loan book is modified into the following scheme:

- Introduce Aliyun's form storage to store large amounts of data or use Tencent's tdsql
- Split the hot and cold data table, and put popular borrowed books into the hot data table to reduce the query pressure of the books table
* At the beginning of the loan service, determine whether the data is the first loan, if the first loan will store the book information into redis, if redis already exists, if the data inventory is insufficient, directly return
* The reids data structure is: {inventory: book.inventory, is_hot_book: false, borrowed_times: 0, is_create_hot_book: false}
* After judging the inventory of books cached by redis, carry out the borrowing data process and update borrowed_times and inventory simultaneously
* When borrowed_times reaches 10 times, book data will be stored in hot_books table, cold and hot data table will be separated, and is_create_hot_book data will be modified synchronously
* When the book borrowing transaction occurs again, the data in redis will be diverted to books (cold data table) and hot_books (hot data table) for query, to reduce the pressure of books query

The scheme in the above split hot and cold data table is only a better verified scheme based on local development demo, of course, there are other schemes for splitting hot and cold data, which will not be diffused here
#### Parameters

Two additional time parameters are added here, borrowed_at (borrowing time) and estimated_return_time (expected return time), which are mainly used in order cost calculation

| Name                  | Type    | Required | Description                 |
|-----------------------|---------|----------|-----------------------------|
| user_id               | integer | True     | Need borrow user id         |
| book_id               | integer | True     | Borrowed book id            |
| borrowed_at           | string  | False    | Books borrowed time         |
| estimated_return_time | string  | False    | Books estimated return time |

#### Responses

| Status Code | Description                   |
|-------------|-------------------------------|
| 10000       | Request successful            |
| 100         | Interface parameter exception |
| 300         | Data check failure            |
| 500         | Service exception             |

```
{
    "code": 10000,
    "message": "Request successful",
    "data": {
        "id": 41,
        "actual_return_time": null,
        "amount": 1.0,
        "borrowed_at": "2023-07-09T18:56:11.000+08:00",
        "estimated_return_time": null,
        "status": "borrowed",
        "book_id": 43
    },
    "timestamps": 1688900172
}
```

## Return

Operations about returns

### Post Return Return Book

```
POST /return/return_book
```

Return books

#### Parameters
Here it is suggested in the requirements document to use book_id and user_id as parameters, because there is no specific business that specifies whether a user has only one order for a book, so order_id is introduced to uniquely solve the book order
Carry out the book return process

| Name     | Type    | Required | Description         |
|----------|---------|----------|---------------------|
| user_id  | integer | ture     | Need borrow user id |
| book_id  | integer | true     | Borrowed book id    |
| order_id | integer | false    | Borrowed order id   |

#### Responses

| Status Code | Description                   |
|-------------|-------------------------------|
| 10000       | Request successful            |
| 100         | Interface parameter exception |
| 300         | Data check failure            |
| 500         | Service exception             |

```
{
  "code": 10000,
  "message": "Request successful",
  "data": {
    "status": "returned",
    "estimated_return_time": "2023-07-05T23:15:00.000+08:00",
    "id": 1,
    "account_id": 1,
    "book_id": 1,
    "borrowed_at": null,
    "actual_return_time": null,
    "amount": 0.0,
    "created_at": "2023-07-02T22:30:06.212+08:00",
    "updated_at": "2023-07-05T23:15:00.327+08:00"
  },
  "timestamps": 1688570100
}

```

## Book

Operations about books

### Get Book Search Book Income

```
GET /book/search_book_income
```

Search book income

Design idea:
When the profits of a book are queried for a short period of time due to the rapid increase in the number of lending staff and books and the number of orders, there is a risk that the scanning cost will be too large and the query will be slow. Therefore, the intermediate table daily_profits table will be introduced.
It is used to record the daily income of the book, so the query will be divided into the following sections:
* Time ranges are split according to the time when the parameter is passed in. Within the time ranges, integer days are used to query daily_profits for the total amount generated by data calculation
* Both ends of the time period, which may not be a full day, will be searched for both ends of the time range to obtain orders, to calculate the total amount of books generated
* Split time periods to reduce table lookup pressure when the orders table data volume is large

#### Parameters

| Name       | Type    | Required | Description         |
|------------|---------|----------|---------------------|
| book_id    | integer | True     | Need search book id |
| start_time | string  | False    | Search start time   |
| end_time   | string  | False    | Search end time     |

#### Responses

| Status Code | Description                   |
|-------------|-------------------------------|
| 10000       | Request successful            |
| 100         | Interface parameter exception |
| 300         | Data check failure            |
| 500         | Service exception             |

```
{
  "code": 10000,
  "message": "Request successful",
  "data": 0,
  "timestamps": 1688570100
}
```
