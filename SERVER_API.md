# Elevate Academy — Server API Specification

This document is the **single source of truth** for building the Elevate Academy backend.
Paste this file (or relevant sections) into your AI assistant to scaffold the server.

---

## Stack Assumptions

- **Runtime:** Node.js + TypeScript
- **Framework:** Express.js (or NestJS — your choice)
- **Database:** PostgreSQL (recommended) or MongoDB
- **ORM:** TypeORM / Prisma (PostgreSQL) or Mongoose (MongoDB)
- **Auth:** JWT (access token) — no refresh tokens needed for now
- **File storage:** Local disk OR AWS S3 (configurable via env)
- **Base URL:** `http://localhost:4002`
- **All routes prefixed with:** `/api`

---

## Environment Variables

```env
PORT=4002
DATABASE_URL=postgresql://user:pass@localhost:5432/elevate_academy
JWT_SECRET=your-secret-here
JWT_EXPIRES_IN=7d
FRONTEND_URL=http://localhost:3000
UPLOAD_DIR=./uploads
AWS_S3_BUCKET=                  # optional — for S3 uploads
SMTP_HOST=
SMTP_PORT=587
SMTP_USER=
SMTP_PASS=
FROM_EMAIL=noreply@era92elevate.org
```

---

## Auth Middleware

All routes except `POST /api/auth/login`, `POST /api/register`, `POST /api/auth/forgot-password`,
and `POST /api/auth/reset-password` require a valid JWT in the `Authorization` header:

```
Authorization: Bearer <token>
```

The decoded token must contain: `{ id, email, roles[], permissions[], contactId, fullName }`.

---

## Data Models

### User
```
id            UUID (PK)
email         string (unique)
passwordHash  string
fullName      string
username      string
avatar        string (URL)
roles         string[]        — e.g. ["ADMIN", "INSTRUCTOR", "STUDENT"]
permissions   string[]        — e.g. ["STUDENT_VIEW", "CLASS_EDIT"]
contactId     UUID (FK → Student)
isActive      boolean
createdAt     datetime
updatedAt     datetime
```

### Student
```
id              UUID (PK)
firstName       string
lastName        string
middleName      string
name            string (computed: firstName + lastName)
email           string
phone           string
hub             string  — slug: katanga | kosovo | jinja | namayemba | lyantode
hubName         string  — display: "Katanga Hub"
course          string  — slug: graphic-design | website-development | film-photography | alx-course
ageGroup        string
gender          string  — Male | Female
civilStatus     string  — Single | Married | Divorced | Other
occupation      string
residence       json    — { freeForm, placeId, lat, lon, district }
avatar          string (URL)
status          string  — active | pending | inactive
registeredAt    datetime
createdAt       datetime
updatedAt       datetime
hasLaptop       string  — Yes | No
interestedInCourses string
hubLocationId   UUID (FK → Hub)
```

### Hub
```
id          UUID (PK)
name        string  — "Katanga Hub"
slug        string  — "katanga"
location    string
address     string
createdAt   datetime
```

### Course
```
id          UUID (PK)
name        string
slug        string  — graphic-design | website-development | film-photography | alx-course
description string
hub         string (FK)
capacity    integer
isActive    boolean
createdAt   datetime
```

### Class (Session)
```
id            UUID (PK)
name          string
courseId      UUID (FK → Course)
courseName    string
hubId         UUID (FK → Hub)
hubName       string
instructor    string
instructorId  UUID (FK → User)
startTime     datetime
endTime       datetime
date          date
attendance    integer
status        string — scheduled | ongoing | completed | cancelled
createdAt     datetime
```

### Enrollment
```
id          UUID (PK)
studentId   UUID (FK → Student)
courseId    UUID (FK → Course)
hubId       UUID (FK → Hub)
status      string — active | completed | dropped
enrolledAt  datetime
progress    integer (0–100)
```

### Assignment
```
id              UUID (PK)
title           string
description     string
course          string
hub             string
dueDate         date
totalMarks      integer
status          string — open | closed
instructorId    UUID (FK → User)
files           json[]  — [{ name, url, type }]
totalStudents   integer
submissionsCount integer
gradedCount     integer
createdAt       datetime
```

### AssignmentSubmission
```
id            UUID (PK)
assignmentId  UUID (FK → Assignment)
studentId     UUID (FK → Student)
studentName   string
text          string
fileUrl       string
grade         integer
feedback      string
status        string — submitted | graded
submittedAt   datetime
gradedAt      datetime
```

### Exam
```
id            UUID (PK)
title         string
course        string
hub           string
date          date
time          string
duration      integer  — minutes
totalMarks    integer
instructions  string
status        string   — scheduled | ongoing | completed | cancelled
instructorId  UUID (FK → User)
createdAt     datetime
```

### ExamResult
```
id          UUID (PK)
examId      UUID (FK → Exam)
studentId   UUID (FK → Student)
studentName string
score       integer
grade       string  — A | B | C | D | F
status      string  — graded | pending
createdAt   datetime
```

### Report
```
id          UUID (PK)
name        string
categoryId  UUID (FK → ReportCategory)
createdAt   datetime
```

### ReportSubmission
```
id          UUID (PK)
reportId    UUID (FK → Report)
submittedBy UUID (FK → User)
data        json
status      string — pending | submitted | reviewed
createdAt   datetime
```

---

## API Endpoints

---

### AUTH

#### POST /api/auth/login
Login with email and password.

**Request body:**
```json
{
  "username": "admin@era92elevate.org",
  "password": "elevate"
}
```

**Response 200:**
```json
{
  "token": "eyJhbGci...",
  "user": {
    "id": "uuid",
    "email": "admin@era92elevate.org",
    "fullName": "Admin User",
    "username": "admin",
    "avatar": null,
    "contactId": "uuid",
    "roles": ["ADMIN", "SUPER"],
    "permissions": ["DASHBOARD", "STUDENT_VIEW", "STUDENT_EDIT", "USER_VIEW", "USER_EDIT",
                    "COURSE_VIEW", "COURSE_EDIT", "CLASS_VIEW", "CLASS_EDIT",
                    "REPORT_VIEW", "REPORT_VIEW_SUBMISSIONS", "ROLE_EDIT", "MANAGE_HELP",
                    "HUB_VIEW", "HUB_EDIT", "TAG_VIEW", "TAG_EDIT"]
  }
}
```

**Response 401:** `{ "message": "Invalid credentials" }`

---

#### GET /api/auth/profile
Returns the currently authenticated user's profile.

**Response 200:** Same shape as `user` object above.

---

#### POST /api/auth/forgot-password
Sends a password reset email.

**Request body:** `{ "email": "user@example.com" }`
**Response 200:** `{ "message": "Reset link sent" }`

---

#### POST /api/auth/reset-password
Resets password using token from email.

**Request body:** `{ "token": "...", "password": "newpassword" }`
**Response 200:** `{ "message": "Password updated" }`

---

### REGISTRATION (Public)

#### POST /api/register
Student self-registration (no auth required). Called from the Register page.

**Request body:**
```json
{
  "hubName": "katanga",
  "firstName": "Jane",
  "otherNames": "Doe Smith",
  "gender": "Female",
  "birthDay": "15",
  "birthMonth": "06",
  "civilStatus": "Single",
  "ageGroup": "18-24",
  "email": "jane@example.com",
  "phone": "0701234567",
  "interestedInCourses": "website-development",
  "hasLaptop": "Yes",
  "occupation": "Student",
  "residence": { "freeForm": "Kampala, Uganda", "placeId": null },
  "hubLocationId": "uuid-of-hub"
}
```

**Response 201:**
```json
{ "message": "Registration successful. Check your email for login instructions." }
```

Server should:
1. Create a Student record
2. Send a welcome email with login credentials
3. Create a User account with role `STUDENT` and generate a temporary password

---

### STUDENTS

#### GET /api/students
List students with filters. Supports pagination.

**Query params:**
| Param    | Type   | Description |
|----------|--------|-------------|
| query    | string | Search name, email, or phone |
| hub      | string | Slug: katanga, kosovo, jinja, namayemba, lyantode |
| course   | string | Slug: graphic-design, website-development, film-photography, alx-course |
| dateFrom | string | YYYY-MM-DD — filter registeredAt >= dateFrom |
| dateTo   | string | YYYY-MM-DD — filter registeredAt <= dateTo |
| limit    | number | Default 50 |
| skip     | number | Default 0 |

**Response 200:**
```json
{
  "data": [
    {
      "id": "uuid",
      "firstName": "Jane",
      "lastName": "Doe",
      "name": "Jane Doe",
      "email": "jane@example.com",
      "phone": "0701234567",
      "hub": "katanga",
      "hubName": "Katanga Hub",
      "course": "website-development",
      "ageGroup": "18-24",
      "gender": "Female",
      "civilStatus": "Single",
      "avatar": null,
      "status": "active",
      "registeredAt": "2026-03-01T10:00:00.000Z",
      "occupation": "Student",
      "residence": { "freeForm": "Kampala" }
    }
  ],
  "total": 120,
  "todayCount": 3,
  "weekCount": 14
}
```

---

#### GET /api/students/:id
Get a single student's full profile.

**Response 200:** Full Student object plus related data:
```json
{
  "id": "uuid",
  "firstName": "Jane",
  "lastName": "Doe",
  "name": "Jane Doe",
  "email": "jane@example.com",
  "phone": "0701234567",
  "hub": "katanga",
  "hubName": "Katanga Hub",
  "course": "website-development",
  "ageGroup": "18-24",
  "gender": "Female",
  "civilStatus": "Single",
  "avatar": null,
  "status": "active",
  "registeredAt": "2026-03-01T10:00:00.000Z",
  "occupation": "Student",
  "residence": { "freeForm": "Kampala" },
  "enrollments": [],
  "assignments": [],
  "examResults": []
}
```

---

#### PUT /api/students/:id
Update student profile.

**Request body:** Any subset of Student fields.
**Response 200:** Updated Student object.

---

#### GET /api/students/people
Returns students in a people-list format (id, name, avatar, email, phone).
Used for combo/autocomplete selects.

---

#### GET /api/students/people/combo
Returns `[{ id, name }]` for dropdown selects.

---

#### POST /api/students/import
Bulk import students from a CSV/Excel file.

**Request:** `multipart/form-data` with field `file`.
**Response 200:** `{ "imported": 45, "failed": 2, "errors": [] }`

---

#### GET /api/student/hub
Returns students grouped by hub.

**Response 200:**
```json
[
  { "hub": "katanga", "hubName": "Katanga Hub", "count": 32 },
  { "hub": "kosovo",  "hubName": "Kosovo Hub",  "count": 18 }
]
```

---

#### GET /api/students/emails
Returns `[{ id, studentId, value, category, isPrimary }]` for a student.
**Query:** `?studentId=uuid`

---

#### GET /api/students/phones
Returns `[{ id, studentId, value, category, isPrimary }]` for a student.
**Query:** `?studentId=uuid`

---

#### GET /api/students/addresses
Returns addresses for a student.
**Query:** `?studentId=uuid`

---

#### GET /api/students/identifications
Returns identification documents for a student.
**Query:** `?studentId=uuid`

---

#### GET /api/students/requests
Returns pending group/course membership requests for a student.
**Query:** `?studentId=uuid`

---

#### PUT /api/students/student/avatar
Upload/update a student's avatar image.

**Request:** `multipart/form-data` with field `avatar` (image file) and `studentId`.
**Response 200:** `{ "avatarUrl": "https://..." }`

---

### HUBS

#### GET /api/hubs
List all hubs.

**Response 200:**
```json
[
  { "id": "uuid", "name": "Katanga Hub", "slug": "katanga", "location": "Katanga, Kampala", "address": "..." },
  { "id": "uuid", "name": "Kosovo Hub",  "slug": "kosovo",  "location": "Kosovo, Kampala",  "address": "..." },
  { "id": "uuid", "name": "Jinja Hub",   "slug": "jinja",   "location": "Jinja Town",       "address": "..." },
  { "id": "uuid", "name": "Namayemba Hub","slug": "namayemba","location": "Namayemba",      "address": "..." },
  { "id": "uuid", "name": "Lyantode Hub","slug": "lyantode","location": "Lyantode",         "address": "..." }
]
```

---

#### POST /api/hubs
Create a new hub. (Admin only)

---

### COURSES

#### GET /api/courses/course
List all courses.

**Query params:** `hub`, `categoryId`, `isActive`, `limit`, `skip`

**Response 200:**
```json
[
  {
    "id": "uuid",
    "name": "Website Development",
    "slug": "website-development",
    "description": "...",
    "hub": "katanga",
    "capacity": 30,
    "enrolledCount": 24,
    "isActive": true
  }
]
```

---

#### POST /api/courses/course
Create a course. (Admin/Instructor)

---

#### GET /api/courses/combo
Returns `[{ id, name }]` for course dropdowns.

---

#### GET /api/courses/category
List course categories.

---

#### POST /api/courses/enrollment
Enroll a student in a course.

**Request body:**
```json
{
  "studentId": "uuid",
  "courseId": "uuid",
  "hubId": "uuid"
}
```
**Response 201:** Enrollment object.

---

#### GET /api/courses/enrollment
Get enrollments for a student.
**Query:** `?contactId=uuid`

**Response 200:**
```json
[
  {
    "id": "uuid",
    "courseId": "uuid",
    "courseName": "Website Development",
    "courseSlug": "website-development",
    "hubName": "Katanga Hub",
    "status": "active",
    "progress": 45,
    "enrolledAt": "2026-01-15T00:00:00.000Z"
  }
]
```

---

#### GET /api/courses/coursereports
Returns aggregated course attendance/completion reports.

---

#### GET /api/courses/coursescombo
Returns courses as `[{ id, name }]` combo list.

---

### CLASSES (Sessions)

#### GET /api/classes/class
List classes/sessions.

**Query params:**
| Param     | Type   | Description |
|-----------|--------|-------------|
| from      | string | YYYY-MM-DD start date |
| to        | string | YYYY-MM-DD end date |
| hubId     | string | Filter by hub |
| courseId  | string | Filter by course |
| hubName   | string | Filter by hub name |
| limit     | number | Default 100 |
| skip      | number | Default 0 |

**Response 200:**
```json
[
  {
    "id": "uuid",
    "name": "Website Dev - Session 12",
    "courseName": "Website Development",
    "courseId": "uuid",
    "hubName": "Katanga",
    "hubId": "uuid",
    "instructor": "John Mukasa",
    "instructorId": "uuid",
    "startTime": "2026-03-07T09:00:00.000Z",
    "endTime": "2026-03-07T12:00:00.000Z",
    "date": "2026-03-07",
    "attendance": 18,
    "status": "scheduled"
  }
]
```

---

#### POST /api/classes/class
Create a class session. (Instructor/Admin)

---

#### GET /api/classes/member
Get classes a student has attended.
**Query:** `?contactId=uuid`

---

#### GET /api/classes/attendance
Get attendance records for a class.
**Query:** `?classId=uuid`

---

#### POST /api/classes/attendance
Mark attendance for a class.

**Request body:**
```json
{
  "classId": "uuid",
  "studentIds": ["uuid1", "uuid2"]
}
```

---

#### GET /api/classes/registration
Get class registrations.
**Query:** `?classId=uuid` or `?contactId=uuid`

---

#### POST /api/classes/registration
Register a student for a class.

---

#### GET /api/classes/category
List class categories.

---

#### GET /api/classes/fields
List custom fields for classes.

---

#### GET /api/classes/activities
Get activity log for a class.

---

#### GET /api/classes/metrics/raw
Raw metrics used for the legacy dashboard widget charts.

**Query:** `from`, `to`, `groupIdList[]`

**Response 200:** Array of event/metric objects with `metaData` fields used by the existing `DashboardData` component:
```json
[
  {
    "id": "uuid",
    "categoryId": "course",
    "attendance": 18,
    "metaData": {
      "tuitionFees": 0,
      "noOfCertifications": 2,
      "noOfEnrollments": 5,
      "noOfInstructors": 1,
      "totalCourseAttendance": 18,
      "totalClassAttendance": 18
    }
  }
]
```

---

#### GET /api/classes/dayoff
Get scheduled days off / public holidays.

---

### DASHBOARD

#### GET /api/dashboard/stats
Top-level platform statistics for the admin dashboard.

**Response 200:**
```json
{
  "totalStudents": 147,
  "newThisWeek": 12,
  "todayClasses": 5,
  "pendingExams": 2
}
```

---

#### GET /api/dashboard/hub-stats
Student counts broken down per hub.

**Response 200:**
```json
[
  { "hub": "Katanga",   "studentCount": 42, "activeCount": 38 },
  { "hub": "Kosovo",    "studentCount": 31, "activeCount": 28 },
  { "hub": "Jinja",     "studentCount": 27, "activeCount": 25 },
  { "hub": "Namayemba", "studentCount": 19, "activeCount": 17 },
  { "hub": "Lyantode",  "studentCount": 28, "activeCount": 26 }
]
```

---

#### GET /api/dashboard/stats/top-performers
Best student and best performing course this term.

**Response 200:**
```json
{
  "topStudent": {
    "name": "Jane Nakato",
    "hub": "Katanga",
    "course": "Website Development",
    "score": 94
  },
  "topCourse": {
    "name": "Graphic Design",
    "enrolledCount": 31,
    "avgScore": 87
  }
}
```

---

### TIMETABLE

#### GET /api/timetable
Weekly timetable across all hubs.

**Query:** `?week=2026-03-07` (any date in the week)

**Response 200:**
```json
[
  {
    "hub": "Katanga",
    "day": "Monday",
    "date": "2026-03-09",
    "classes": [
      { "time": "9:00 AM", "course": "Website Development", "instructor": "John Mukasa", "room": "Lab 1" }
    ]
  }
]
```

---

### ASSIGNMENTS

#### GET /api/assignments
List assignments. Instructors see their own; admins see all.

**Query:** `hub`, `course`, `status` (open|closed), `limit`, `skip`

**Response 200:**
```json
[
  {
    "id": "uuid",
    "title": "Build a personal portfolio website",
    "description": "Create a 3-page portfolio using HTML and CSS.",
    "course": "Website Development",
    "hub": "Katanga",
    "dueDate": "2026-03-15",
    "totalMarks": 100,
    "status": "open",
    "instructorId": "uuid",
    "files": [
      { "name": "assignment-brief.pdf", "url": "https://...", "type": "application/pdf" }
    ],
    "totalStudents": 24,
    "submissionsCount": 11,
    "gradedCount": 8,
    "createdAt": "2026-03-01T00:00:00.000Z"
  }
]
```

---

#### POST /api/assignments
Create a new assignment. Supports file attachments via multipart.

**Request:** `multipart/form-data`
| Field       | Type    |
|-------------|---------|
| title       | string  |
| description | string  |
| course      | string  |
| hub         | string  |
| dueDate     | date    |
| totalMarks  | number  |
| files       | File[]  |

**Response 201:** Assignment object.

---

#### GET /api/assignments/submissions
Get submissions for an assignment.

**Query:** `?assignmentId=uuid`

**Response 200:**
```json
[
  {
    "id": "uuid",
    "assignmentId": "uuid",
    "studentId": "uuid",
    "studentName": "Jane Nakato",
    "text": "Here is my portfolio link: ...",
    "fileUrl": "https://...",
    "grade": 85,
    "feedback": "Great work on the layout!",
    "status": "graded",
    "submittedAt": "2026-03-10T14:30:00.000Z",
    "gradedAt": "2026-03-11T09:00:00.000Z"
  }
]
```

---

#### POST /api/assignments/files
Upload additional files to an existing assignment.

**Request:** `multipart/form-data` with `assignmentId` and `files[]`.

---

#### POST /api/assignments/grades
Save a grade and feedback for a submission.

**Request body:**
```json
{
  "submissionId": "uuid",
  "grade": 85,
  "feedback": "Excellent work! Clean code and great design."
}
```
**Response 200:** Updated submission object.

---

### EXAMS

#### GET /api/exams
List exams.

**Query:** `hub`, `course`, `status` (scheduled|ongoing|completed|cancelled), `limit`, `skip`

**Response 200:**
```json
[
  {
    "id": "uuid",
    "title": "Website Development — Term 1 Exam",
    "course": "Website Development",
    "hub": "Katanga",
    "date": "2026-03-20",
    "time": "09:00",
    "duration": 120,
    "totalMarks": 100,
    "instructions": "Open book. No phones.",
    "status": "scheduled",
    "instructorId": "uuid",
    "createdAt": "2026-03-01T00:00:00.000Z"
  }
]
```

---

#### POST /api/exams
Schedule a new exam.

**Request body:**
```json
{
  "title": "Website Development — Term 1 Exam",
  "course": "Website Development",
  "hub": "Katanga",
  "date": "2026-03-20",
  "time": "09:00",
  "duration": 120,
  "totalMarks": 100,
  "instructions": "Open book. No phones."
}
```
**Response 201:** Exam object.

---

#### GET /api/exams/results
Get results for an exam.

**Query:** `?examId=uuid`

**Response 200:**
```json
[
  {
    "id": "uuid",
    "examId": "uuid",
    "studentId": "uuid",
    "studentName": "Jane Nakato",
    "score": 88,
    "grade": "A",
    "status": "graded"
  }
]
```

---

#### POST /api/exams/results
Submit exam results for a student.

**Request body:**
```json
{
  "examId": "uuid",
  "studentId": "uuid",
  "score": 88,
  "grade": "A"
}
```

---

### REPORTS

#### GET /api/reports
List available report templates.

---

#### GET /api/reports/category
List report categories.

---

#### GET /api/reports/:reportId/submissions
Get submissions for a report.

---

#### POST /api/reports/submit
Submit a report.

**Request body:** `{ "reportId": "uuid", "data": { ... } }`

---

### USERS & ROLES

#### GET /api/users
List platform users (admins, instructors, students).

**Query:** `role`, `limit`, `skip`

**Response 200:**
```json
[
  {
    "id": "uuid",
    "email": "instructor@era92elevate.org",
    "fullName": "John Mukasa",
    "username": "jmukasa",
    "roles": ["INSTRUCTOR"],
    "permissions": ["STUDENT_VIEW", "CLASS_VIEW", "CLASS_EDIT"],
    "isActive": true,
    "createdAt": "2026-01-01T00:00:00.000Z"
  }
]
```

---

#### POST /api/users
Create a new user account.

**Request body:**
```json
{
  "email": "instructor@era92elevate.org",
  "fullName": "John Mukasa",
  "password": "temp-password",
  "roles": ["INSTRUCTOR"],
  "permissions": ["STUDENT_VIEW", "CLASS_VIEW", "CLASS_EDIT"]
}
```

---

#### PUT /api/users/:id
Update user details or reset password.

---

#### GET /api/user-roles
List available roles and permissions.

**Response 200:**
```json
{
  "roles": ["SUPER", "ADMIN", "INSTRUCTOR", "STUDENT"],
  "permissions": [
    "DASHBOARD", "STUDENT_VIEW", "STUDENT_EDIT",
    "USER_VIEW", "USER_EDIT", "ROLE_EDIT",
    "COURSE_VIEW", "COURSE_EDIT",
    "CLASS_VIEW", "CLASS_EDIT",
    "HUB_VIEW", "HUB_EDIT",
    "REPORT_VIEW", "REPORT_VIEW_SUBMISSIONS",
    "TAG_VIEW", "TAG_EDIT", "MANAGE_HELP"
  ]
}
```

---

#### POST /api/user-roles
Assign roles and permissions to a user.

**Request body:**
```json
{
  "userId": "uuid",
  "roles": ["INSTRUCTOR"],
  "permissions": ["STUDENT_VIEW", "CLASS_VIEW", "CLASS_EDIT"]
}
```

---

### TAGS

#### GET /api/tags
List all tags.

#### POST /api/tags
Create a tag.

---

### UPLOADS

#### POST /api/uploads
General file upload endpoint. Used for assignment attachments, etc.

**Request:** `multipart/form-data` with `file` field.

**Response 200:**
```json
{
  "url": "https://your-bucket.s3.amazonaws.com/uploads/filename.pdf",
  "name": "filename.pdf",
  "type": "application/pdf",
  "size": 204800
}
```

#### POST /api/uploads/avatar
Upload a user/student avatar.

**Request:** `multipart/form-data` with `avatar` field.
**Response 200:** `{ "avatarUrl": "https://..." }`

---

### HELP

#### GET /api/help
List help articles.

#### POST /api/help
Create a help article. (Admin only)

---

### CHAT / EMAIL

#### GET /api/chat/email
List email threads.

#### POST /api/chat/email
Send an email.

---

## Roles & Permissions Reference

| Role        | Typical permissions |
|-------------|---------------------|
| SUPER       | All permissions |
| ADMIN       | All except ROLE_EDIT |
| INSTRUCTOR  | STUDENT_VIEW, CLASS_VIEW, CLASS_EDIT, COURSE_VIEW |
| STUDENT     | DASHBOARD, COURSE_VIEW, CLASS_VIEW |

Permission constants (used in the client's `appPermissions` object):

```
DASHBOARD               VIEW_ONLY — student dashboard access
STUDENT_VIEW            List and view students
STUDENT_EDIT            Create and edit students
USER_VIEW               List and view users
USER_EDIT               Create and edit users
ROLE_EDIT               Assign roles and permissions
COURSE_VIEW             View courses
COURSE_EDIT             Create and edit courses
CLASS_VIEW              View classes
CLASS_EDIT              Create and edit classes
HUB_VIEW                View hubs
HUB_EDIT                Create and edit hubs
REPORT_VIEW             View and submit reports
REPORT_VIEW_SUBMISSIONS View report submissions
TAG_VIEW                View tags
TAG_EDIT                Create and edit tags
MANAGE_HELP             Manage help articles
```

---

## Seeded Data

When the server starts for the first time, seed the following:

### Hubs
```
katanga    → Katanga Hub
kosovo     → Kosovo Hub
jinja      → Jinja Hub
namayemba  → Namayemba Hub
lyantode   → Lyantode Hub
```

### Courses
```
graphic-design      → Graphic Design
website-development → Website Development
film-photography    → Film & Photography
alx-course          → ALX Course
```

### Default admin account
```
email:    admin@era92elevate.org
password: elevate2024
roles:    [SUPER, ADMIN]
permissions: [all]
fullName: Elevate Admin
```

### Default instructor account
```
email:    instructor@era92elevate.org
password: elevate2024
roles:    [INSTRUCTOR]
permissions: [STUDENT_VIEW, CLASS_VIEW, CLASS_EDIT, COURSE_VIEW]
fullName: Test Instructor
```

### Default student account
```
email:    student@era92elevate.org
password: student2024
roles:    [STUDENT]
permissions: [DASHBOARD, COURSE_VIEW, CLASS_VIEW]
fullName: Test Student
hub:      katanga
course:   website-development
```

---

## CORS Configuration

Allow the following origins:
```
http://localhost:3000   (React dev server)
http://localhost:4002   (API itself — for health checks)
https://your-production-domain.com
```

Allowed methods: `GET, POST, PUT, PATCH, DELETE, OPTIONS`
Allowed headers: `Content-Type, Authorization`

---

## Error Response Shape

All errors must follow this format so the client's `ajax.ts` can parse them:

```json
{
  "message": "Human-readable error message",
  "statusCode": 400,
  "error": "Bad Request"
}
```

Common status codes:
- `400` Bad Request (validation failure)
- `401` Unauthorized (missing or invalid token)
- `403` Forbidden (insufficient permissions)
- `404` Not Found
- `409` Conflict (duplicate email, etc.)
- `422` Unprocessable Entity
- `500` Internal Server Error

---

## Pagination Convention

All list endpoints that accept `limit`/`skip` should return:

```json
{
  "data": [...],
  "total": 120,
  "limit": 50,
  "skip": 0
}
```

Or a plain array (the client handles both).

---

## Email Templates Needed

| Trigger | Template |
|---------|----------|
| Student registers | Welcome email with temporary login credentials |
| Password reset request | Reset link email |
| Assignment due soon (24h) | Reminder email to student |
| Exam scheduled | Notification to all enrolled students in that hub/course |
| Grade posted | "Your assignment has been graded" email to student |

---

## How to Connect the Client

1. Set `REACT_APP_API_URL=http://localhost:4002` in the client's `.env` file.
2. The client reads this via `process.env.REACT_APP_API_URL` in `src/data/constants.ts`.
3. All API calls go through `src/utils/ajax.ts` which attaches the JWT automatically.
4. JWT is stored in `localStorage` under key `__elevate__academy__token`.
5. The authenticated user object is stored under `__elevate__academy__user`.

---

*Generated from the Elevate Academy client source — keep in sync as endpoints change.*
