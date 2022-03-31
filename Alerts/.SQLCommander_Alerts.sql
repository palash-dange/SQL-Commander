{
    "AlertUUID": "c6bdc64c-51a4-44b4-b8f3-29eda54e8a2b",
    "AlertName": "SQL Commander",
    "AlertOwnerTeam": "mc-sre",
    "RunbookParameters": {
        "StackDetails": {
            "IsRequired": "true"
        },
        "AlertDetails": {
            "ShowAlertId": "No"
        }
    },
    "Commands": [
        {
            "Name": "DatabaseUptime"
        },
        {
            "Name": "DatabaseRestartStatusCheck"
        },
        {
            "Name": "BusinessRuleCheck"
        },
        {
            "Name": "MailServerSearchbyMID"
        },
        {
            "Name": "WhatsRunning"
        },
        {
            "Name": "AsyncAPI Raw Queue"
        }
    ]
}
