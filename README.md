# :envelope_with_arrow: Mikroservices - Emails

![Build Status](https://github.com/Mikroservices/Emails/workflows/Build/badge.svg)
[![Swift 5.2](https://img.shields.io/badge/Swift-5.2-orange.svg?style=flat)](ttps://developer.apple.com/swift/)
[![Vapor 4](https://img.shields.io/badge/vapor-4.0-blue.svg?style=flat)](https://vapor.codes)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![Platforms OS X | Linux](https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat)](https://developer.apple.com/swift/)


Microservice which provides API for sending emails.
Application is written in [Swift](https://swift.org) and [Vapor 4](https://vapor.codes).

## API

Service provides simple RESTful API. Below there is a description of each endpoint.

Endpoint for sending emails.

**Request**

```
METHOD: POST
URL: /emails/send
BODY:
{
    "to: {
        "address": "email@server.com",
        "name": "John Doe"
    },
    "subject": "Email subject",
    "body": "Email content",
    "from": {
        "address": "from@server.com",
        "name": "Emily Doe"
    },
    "replyTo": {
        "address": "replyto@server.com",
        "name": "Viki Doe"
    }
}
```

**Response**

```
STATUS: 200 (Ok)
BODY:
{
    "result": true
}
```

**Errors**

```
STATUS: 400 (BadRequest)
BODY: 
{
    "error": true,
    "code": "validationError",
    "reason": "Validation errors occurs.",
    "failures": [
        {
            "field": "[FIELD]",
            "failure": "[VALIDATION MESSAGE]"
        }
    ]
}
```

## Getting started

First you need to have [Swift](https://swift.org) installed on your computer.
Next you should run following commands:

```bash
$ git clone https://github.com/Mikroservices/Emails.git
$ cd Emails
$ swift package update
$ swift build
```

Now you can run the application:

```bash
$ .build/debug/Run serve --port 8000
```

If application starts open following link in your browser: [http://localhost:8000](http://localhost:8000).
You should see blank page with text: *Service is up and running!*. Now you can use API which is described above.

## Configuration

You can define application settings in `appsettings.json` file or by setting suitable environment variables:

- `smtp.fromName`
- `smtp.fromEmail`
- `smtp.hostname`
- `smtp.port`
- `smtp.username`
- `smtp.password`
- `smtp.secure`


## Deployment

You can deploy application as service in the Kubernates cluster or as a single service in Linux.

### Users service in Linux

You must modify and copy file `users.service` to your Linux server (folder `/lib/systemd/system`). Then you can start service using below command:

```bash
$ systemctl start users.service
```

If you want start service at system boot you must run following command:

```bash
$ systemctl enable users.service
```
