# Online Examination System

A web-based examination management application built with **Java Servlets, JSP, JDBC, and MySQL**. It provides separate workflows for administrators and students, helping manage student registrations, examinations, questions, exam attempts, results, and administrative activity from one application.

## Features

### Student
- Create a student account and sign in after administrator approval.
- Access a student dashboard.
- View and update profile information.
- View available exams, take exams, and view results.

### Administrator
- Access an administration dashboard.
- Review student registrations and approve or reject accounts.
- Create, update, and delete exams.
- Manage exam questions and answer options.
- Review results and performance analytics.
- Review audit logs and activity summaries.

### Access and session handling
- Role-based navigation for administrators and students.
- Registration status checks (`PENDING`, `APPROVED`, and `REJECTED`).
- Session-based authentication and a 30-minute inactive-session timeout.
- Authentication filter and server-side access checks for protected workflows.

## Technology Stack

| Area | Technology |
|---|---|
| Backend | Java, Jakarta Servlet API |
| Server-rendered pages | JSP, HTML, CSS |
| Database access | JDBC |
| Database | MySQL |
| JDBC driver | MySQL Connector/J |
| Application server | Apache Tomcat 10.1.x |
| IDE/project configuration | Eclipse Dynamic Web Project |

The project configuration targets **Java 21** and **Apache Tomcat 10.1.36**.

## Project Structure

```text
OnlineExaminationSystem/
├── src/main/java/com/exam/
│   ├── controller/    # Servlet request handling
│   ├── dao/           # Database access logic
│   ├── filter/        # Authentication filter
│   ├── model/         # Application model classes
│   └── util/          # Database connection utilities
├── src/main/webapp/
│   ├── admin/         # Administrator pages
│   ├── student/       # Student pages
│   ├── WEB-INF/lib/   # MySQL JDBC driver
│   ├── index.jsp
│   ├── login.jsp
│   ├── register.jsp
│   └── style.css
└── README.md
```

## Prerequisites

Install or configure the following before running the application:

- JDK 21
- Apache Tomcat 10.1.x
- MySQL Server
- Eclipse IDE for Enterprise Java and Web Developers (or another Java web IDE)
- MySQL Connector/J (included in the project under `src/main/webapp/WEB-INF/lib/`)

## Database Configuration

The application currently connects to a MySQL database named `online_exam` on `localhost:3306`. Connection settings are defined in:

`src/main/java/com/exam/util/DBConnection.java`

Before running the application:

1. Start MySQL Server.
2. Create the database:

   ```sql
   CREATE DATABASE online_exam;
   ```

3. Configure the database username and password in `DBConnection.java` to match your local MySQL setup.
4. Create the tables required by the DAO classes before using the application.

**Important:** This repository archive does not include a separate database schema or SQL initialization script. The database tables must match the queries and expected columns used in the classes under `src/main/java/com/exam/dao/`. If you have a schema script from your project, run it against `online_exam` before launching the website.

For safety, do not commit real database passwords or other secrets to a public repository. Prefer environment-based configuration for deployments.

## Run Locally (Eclipse + Tomcat)

1. Extract or clone this repository.
2. Open Eclipse and import the `OnlineExaminationSystem` folder as an **Existing Projects into Workspace** project.
3. Confirm the project uses JDK 21 and a Tomcat 10.1.x server runtime.
4. Start MySQL and configure `DBConnection.java` with your local database credentials.
5. Ensure the required database tables exist in `online_exam`.
6. Add the project to your configured Tomcat server.
7. Start the server and open:

   ```text
   http://localhost:8080/OnlineExaminationSystem/
   ```

   If the welcome page is not configured as the default page in your environment, open:

   ```text
   http://localhost:8080/OnlineExaminationSystem/login.jsp
   ```

The port may differ if your Tomcat installation uses a port other than `8080`.

## Typical Workflow

1. A student registers through the registration page.
2. The new account remains pending until an administrator reviews it.
3. The administrator approves or rejects the registration.
4. An approved user signs in and is redirected according to their role.
5. Administrators manage exams and questions and review results and audit activity.
6. Students access their dashboard, take available exams, and view their results.

## Troubleshooting

- **Database connection error:** Confirm that MySQL is running, the `online_exam` database exists, credentials are correct, and the JDBC driver is available.
- **Login says account is pending:** An administrator must approve the student account first.
- **HTTP 404:** Confirm Tomcat is running, the project is deployed, and the context path is `OnlineExaminationSystem`.
- **Missing table/column errors:** Verify that your MySQL schema matches the SQL queries in the DAO classes. The archive does not provide a schema script.
- **Servlet/API errors:** Use Tomcat 10.1.x with the Jakarta Servlet API; this project imports `jakarta.servlet.*` packages.

## Security Notes

This project is intended as an academic/demo web application. Before production use, review password storage, secret management, input validation, database permissions, transport security (HTTPS), and deployment configuration. Do not use sample or local credentials in a production environment.

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Make and test your changes locally.
4. Submit a pull request with a clear description of the change.

## License

No license file was included in the supplied project archive. Add a `LICENSE` file if you intend to publish the project with explicit reuse terms.


## 🌐 Live Demo

**Live Website:** [Online Examination System](https://starts-valves-morning-forwarding.trycloudflare.com/OnlineExaminationSystem/login.jsp)

**Project Repository:** Browse the source code and project documentation in this repository.

> **Note:** This demo is hosted using Cloudflare Quick Tunnel. The website is available only while the host computer, Apache Tomcat server, and Cloudflare Tunnel are running. The URL may change when a new temporary tunnel is created.
