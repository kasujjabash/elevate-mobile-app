# About Elevate Academy

Elevate Academy is a digital skills school management system focused on empowering students with modern digital skills. The platform simplifies the process of managing students, courses, and educational resources across multiple learning hubs, specialized in digital skills training including website development, video production, film and photography, and UI/UX design.

# The Tech

This repository contains the Elevate Academy School Management System server.

## Project Setup / Installation 🚀

1. Clone the repository:

   > `git clone <your-elevate-academy-repo-url>`

2. Install dependencies:

   > `npm install`

3. Create a `.env` file based on the `.env.sample`.

   Set these environment variables in the `env` file as follows

   > `APP_ENVIRONMENT=local` - If you are running the app locally.

   > `DB_USERNAME=<your-local-postgres-db-username>`

   > `DB_PASSWORD=<your-local-postgres-db-password>`

   > `DB_DATABASE=elevate-academy-db`

4. Go ahead and manually create a new postgreSQL database called: `elevate-academy-db`

5. Finally, spin up the project with:

   > `npm run start:dev`

6. Create and seed data for a new school hub by running:
   > `npm run command create-hub kosovo `

This will create a hub named `kosovo`. You can login to that hub using the default admin credentials.

## Test Login Credentials

Run `npm run seed:elevate && npm run seed:admin` to create all accounts.

**Login request format** (`POST /api/auth/login`):
```json
{
  "username": "admin@era92elevate.org",
  "password": "elevate2024",
  "hubName": "elevate"
}
```

### Super Admin

| Email | Password | Role |
|-------|----------|------|
| `superadmin@elevate.org` | `admin2024` | SUPER_ADMIN |

### Hub Managers

| Email | Password | Role | Hub |
|-------|----------|------|-----|
| `robert.kizza@hub.elevate.org` | `hubmanager2024` | HUB_MANAGER | Katanga |
| `annet.nabukenya@hub.elevate.org` | `hubmanager2024` | HUB_MANAGER | Kosovo |
| `isaac.opio@hub.elevate.org` | `hubmanager2024` | HUB_MANAGER | Jinja |

### Trainers / Instructors

| Email | Password | Role | Specialization |
|-------|----------|------|----------------|
| `admin@era92elevate.org` | `elevate2024` | ADMIN | — |
| `instructor@era92elevate.org` | `elevate2024` | TRAINER | Website Development |
| `trainer@era92elevate.org` | `elevate2024` | TRAINER | General |
| `daniel.ochieng@trainer.elevate.org` | `trainer2024` | TRAINER | Film & Photography |
| `grace.akello@trainer.elevate.org` | `trainer2024` | TRAINER | ALX Course |
| `patrick.ssali@trainer.elevate.org` | `trainer2024` | TRAINER | Graphic Design (Kosovo) |
| `miriam.atim@trainer.elevate.org` | `trainer2024` | TRAINER | Website Development (Kosovo) |
| `peter.mwanje@trainer.elevate.org` | `trainer2024` | TRAINER | Website Development |
| `nickolus.onapa@trainer.elevate.org` | `trainer2024` | TRAINER | Graphic Design |
| `andrew@trainer.elevate.org` | `trainer2024` | TRAINER | UI/UX Design |
| `mark.omudigi@trainer.elevate.org` | `trainer2024` | TRAINER | Film & Photography |

### Demo Students

| Email | Password | Hub | Course |
|-------|----------|-----|--------|
| `webdev.student@era92elevate.org` | `student2024` | Katanga | Website Development |
| `design.student@era92elevate.org` | `student2024` | Kosovo | Graphic Design |
| `student@era92elevate.org` | `student2024` | Katanga | Website Development *(default)* |

### Named Students

| Email | Password | Hub | Course |
|-------|----------|-----|--------|
| `jane.nakato@student.elevate.org` | `student2024` | Katanga | Website Development |
| `brian.ssekandi@student.elevate.org` | `student2024` | Katanga | Website Development |
| `mercy.apio@student.elevate.org` | `student2024` | Katanga | Graphic Design |
| `david.okello@student.elevate.org` | `student2024` | Kosovo | Graphic Design |
| `grace.namugga@student.elevate.org` | `student2024` | Kosovo | Graphic Design |
| `peter.mugisha@student.elevate.org` | `student2024` | Jinja | Film & Photography |
| `annet.akello@student.elevate.org` | `student2024` | Jinja | Film & Photography |
| `moses.waiswa@student.elevate.org` | `student2024` | Namayemba | ALX Course |
| `esther.nanyanzi@student.elevate.org` | `student2024` | Lyantode | Website Development |
| `samuel.kato@student.elevate.org` | `student2024` | Lyantode | Website Development |

---

## API Endpoints

Base URL: `http://localhost:4002`  
All routes are prefixed with `/api`.  
All routes require `Authorization: Bearer <token>` except the public ones marked *(public)*.

---

### Auth

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/login` *(public)* | Login — returns JWT token and user object |
| GET | `/api/auth/profile` | Get current authenticated user's profile |
| POST | `/api/auth/forgot-password` *(public)* | Send password reset email |
| POST | `/api/auth/reset-password` *(public)* | Reset password using email token |

**Login request:**
```json
{ "username": "admin@era92elevate.org", "password": "elevate2024" }
```
**Login response:**
```json
{
  "token": "eyJhbGci...",
  "user": { "id": "uuid", "email": "...", "fullName": "...", "roles": ["ADMIN"], "permissions": ["DASHBOARD", "..."] }
}
```

---

### Registration

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/register` *(public)* | Student self-registration — creates Student + User account and sends welcome email |

---

### Students

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/students` | List students — supports `query`, `hub`, `course`, `dateFrom`, `dateTo`, `limit`, `skip` |
| GET | `/api/students/:id` | Get single student with enrollments, assignments, and exam results |
| PUT | `/api/students/:id` | Update student profile |
| GET | `/api/students/people` | Students in people-list format (id, name, avatar, email, phone) |
| GET | `/api/students/people/combo` | Students as `[{ id, name }]` for dropdowns |
| POST | `/api/students/import` | Bulk import from CSV/Excel — `multipart/form-data` with `file` field |
| GET | `/api/student/hub` | Students grouped by hub with counts |
| GET | `/api/students/emails` | Student email contacts — `?studentId=uuid` |
| GET | `/api/students/phones` | Student phone contacts — `?studentId=uuid` |
| GET | `/api/students/addresses` | Student addresses — `?studentId=uuid` |
| GET | `/api/students/identifications` | Student ID documents — `?studentId=uuid` |
| GET | `/api/students/requests` | Pending membership requests — `?studentId=uuid` |
| PUT | `/api/students/student/avatar` | Upload/update student avatar — `multipart/form-data` with `avatar` + `studentId` |

---

### Hubs

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/hubs` | List all hubs (katanga, kosovo, jinja, namayemba, lyantode) |
| POST | `/api/hubs` | Create a new hub *(Admin only)* |

---

### Courses

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/courses/course` | List courses — supports `hub`, `categoryId`, `isActive`, `limit`, `skip` |
| POST | `/api/courses/course` | Create a course *(Admin/Instructor)* |
| GET | `/api/courses/combo` | Courses as `[{ id, name }]` for dropdowns |
| GET | `/api/courses/category` | List course categories |
| POST | `/api/courses/enrollment` | Enroll a student in a course |
| GET | `/api/courses/enrollment` | Get student enrollments — `?contactId=uuid` |
| GET | `/api/courses/coursereports` | Aggregated attendance/completion reports |
| GET | `/api/courses/coursescombo` | Courses combo list |

---

### Classes (Sessions)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/classes/class` | List class sessions — supports `from`, `to`, `hubId`, `courseId`, `hubName`, `limit`, `skip` |
| POST | `/api/classes/class` | Create a class session *(Instructor/Admin)* |
| GET | `/api/classes/member` | Classes a student attended — `?contactId=uuid` |
| GET | `/api/classes/attendance` | Attendance records for a class — `?classId=uuid` |
| POST | `/api/classes/attendance` | Mark attendance — body: `{ classId, studentIds[] }` |
| GET | `/api/classes/registration` | Class registrations — `?classId=uuid` or `?contactId=uuid` |
| POST | `/api/classes/registration` | Register a student for a class |
| GET | `/api/classes/category` | List class categories |
| GET | `/api/classes/fields` | List custom fields for classes |
| GET | `/api/classes/activities` | Activity log for a class |
| GET | `/api/classes/metrics/raw` | Raw metrics for dashboard charts — `?from&to&groupIdList[]` |
| GET | `/api/classes/dayoff` | Scheduled days off and public holidays |

---

### Dashboard

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/dashboard/stats` | Top-level stats: totalStudents, newThisWeek, todayClasses, pendingExams |
| GET | `/api/dashboard/hub-stats` | Student counts broken down per hub |
| GET | `/api/dashboard/stats/top-performers` | Best student and best performing course this term |

---

### Timetable

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/timetable` | Weekly timetable across all hubs — `?week=YYYY-MM-DD` |

---

### Assignments

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/assignments` | List assignments — supports `hub`, `course`, `status`, `limit`, `skip` |
| POST | `/api/assignments` | Create assignment with file attachments — `multipart/form-data` |
| GET | `/api/assignments/submissions` | Submissions for an assignment — `?assignmentId=uuid` |
| POST | `/api/assignments/files` | Upload additional files to an assignment |
| POST | `/api/assignments/grades` | Save grade and feedback — body: `{ submissionId, grade, feedback }` |

---

### Exams

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/exams` | List exams — supports `hub`, `course`, `status`, `limit`, `skip` |
| POST | `/api/exams` | Schedule a new exam |
| GET | `/api/exams/results` | Results for an exam — `?examId=uuid` |
| POST | `/api/exams/results` | Submit exam result — body: `{ examId, studentId, score, grade }` |

---

### Reports

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/reports` | List available report templates |
| GET | `/api/reports/category` | List report categories |
| GET | `/api/reports/:reportId/submissions` | Get submissions for a report |
| POST | `/api/reports/submit` | Submit a report — body: `{ reportId, data: {...} }` |

---

### Users & Roles

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users` | List users — supports `role`, `limit`, `skip` |
| POST | `/api/users` | Create a new user account |
| PUT | `/api/users/:id` | Update user details or reset password |
| GET | `/api/user-roles` | List all available roles and permissions |
| POST | `/api/user-roles` | Assign roles and permissions to a user — body: `{ userId, roles[], permissions[] }` |

---

### Tags

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tags` | List all tags |
| POST | `/api/tags` | Create a tag |

---

### Uploads

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/uploads` | General file upload — `multipart/form-data` with `file` field |
| POST | `/api/uploads/avatar` | Upload user/student avatar — `multipart/form-data` with `avatar` field |

---

### Help

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/help` | List help articles |
| POST | `/api/help` | Create a help article *(Admin only)* |

---

### Chat / Email

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/chat/email` | List email threads |
| POST | `/api/chat/email` | Send an email |

---

## Error Response Shape

All errors follow this format:
```json
{ "message": "Human-readable error", "statusCode": 400, "error": "Bad Request" }
```

| Code | Meaning |
|------|---------|
| 400 | Bad Request — validation failure |
| 401 | Unauthorized — missing or invalid token |
| 403 | Forbidden — insufficient permissions |
| 404 | Not Found |
| 409 | Conflict — e.g. duplicate email |
| 500 | Internal Server Error |

---

## Pagination

List endpoints that accept `limit`/`skip` return:
```json
{ "data": [...], "total": 120, "limit": 50, "skip": 0 }
```

---

**Please Note:**

- If you don't have `node.js` installed, check out this guide https://nodejs.org/en/
- This repo works with the client at https://github.com/kanzucodefoundation/project-zoe-client so be sure to set that up too.

### Installation errors

1. `sh: eslint: command not found`

**Solution:** Run `npm install -g eslint` then `eslint --init`
If that fails, other alternatives here https://github.com/eslint/eslint/issues/10192

## Commitizen friendly

[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

## Github Action

This repo is automatically deployed to the prod server using github actions. We create an `.env` file during the deployment process. Rather than add each environment variable to the file one by one, we copied a complete `.env` file and encrypted it using base64. We use the command:

```
openssl base64 -A -in .env -out .env.prod.encrypted
```

We then get the contents of `.env.prod.encrypted` and add them as a Github Action variable called `PROD_ENV_FILE`
