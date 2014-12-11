sync-ios
========

This prototype demonstrates a simple syncing mechanism between an iOS app and a Ruby on Rails application.

Rails: [sync-rails](https://github.com/sixoverground/sync-rails)

General Concept
---------------

* Syncing happens with a single POST request, initiated from the client.
* Both Rails and iOS use a generated UUID as the unique primary key identifier.
* All updated timestamps are created on the server.
* Objects are never destroyed from the server. Instead, they are marked with a deleted timestamp when removed.

Sync Process
------------

* iOS finds the most recent updatedAt date on each local object.
* iOS collects all recently created and updated local objects.
* The max date and objects are posted to the server.

`POST /api/sync`

#### Request
```json
{
  "updated_at": "yyyy-MM-ddTHH:mm:ssZ",
  "events": [
    {
      "uuid": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx1",
      "title": "Valid Title",
      "deleted_at": null
    },
    {
      "uuid": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx2",
      "title": "Invalid Title",
      "deleted_at": null
    }
  ]
}
```
* Rails loops through all posted objects, and creates or updates each one appropriately.
* Rails finds all objects, including newly created objects, that have an updated_at field more recent than the posted parameter.
* All successfully saved and found objects are returned in a success array.
* Any objects that cannot be saved are returned in an error array.

#### Response
```json
{
  "events": {
    "success": [
      {
        "uuid": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx1",
        "title": "Valid Title",
        "deleted_at": null,
        "updated_at": "yyyy-MM-ddTHH:mm:ssZ"
      }
    ],
    "error": [
      {
        "uuid": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx2",
        "message": "Title is invalid."
      }
    ]
  }
}
```

* iOS updates all successfully returned objects, and deletes any objects marked as deleted.
* iOS handles any errors returned from the server appropriately.
