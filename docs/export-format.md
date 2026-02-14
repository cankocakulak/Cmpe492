# JSON Export Format

File name: `cmpe492-export-YYYYMMDD-HHMMSS.json`

Top-level structure:
```
{
  "exportedAt": "2026-02-14T12:34:56Z",
  "tasks": [
    {
      "id": "UUID",
      "text": "Task text",
      "createdAt": "ISO-8601 date",
      "updatedAt": "ISO-8601 date",
      "scheduledDate": "ISO-8601 date or null",
      "completedAt": "ISO-8601 date or null",
      "state": "Not Started | Active | Completed",
      "sortOrder": 0
    }
  ]
}
```

Notes:
- Dates are encoded using ISO-8601.
- `scheduledDate` is `null` for Inbox tasks.
- `completedAt` is set only when the task is completed.
