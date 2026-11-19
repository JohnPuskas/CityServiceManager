# CityServiceManager

City Service Manager is a SQL Server database and business reporting project that simulates municipal service request and work order management.

The project uses relational database design, T-SQL development, synthetic data generation, data validation, and the creation of reporting solutions.

## Technologies

- Microsoft SQL Server Express
- SQL Server Management Studio
- T-SQL
- Microsoft Power BI Report Builder

## Database Design

The database contains seven related tables:

| Table                | Purpose                                                               |
| -------------------- | --------------------------------------------------------------------- |
| Departments          | City departments responsible for service operations                   |
| Employees            | Employees associated with departments                                 |
| RequestTypes         | Categories of city service requests                                   |
| Locations            | Geographic locations associated with requests                         |
| ServiceRequests      | Submitted requests, including submission and cancellation information |
| WorkOrders           | Department-assigned work, including status, priority, and dates       |
| WorkOrderAssignments | Employee assignments to work orders                                   |

The Entity Relationship Diagram (ERD) is available in `database/erd/`.

## Synthetic Data

The database is populated with synthetic data using T-SQL seed scripts. The project uses entirely synthetic data and does not contain real citizen or employee records.

The current dataset contains:

| Table                | Records |
| -------------------- | ------: |
| Departments          |       6 |
| Employees            |      40 |
| Locations            |     250 |
| RequestTypes         |      12 |
| ServiceRequests      |   2,000 |
| WorkOrders           |   1,500 |
| WorkOrderAssignments |   2,000 |

The data includes varied service request categories, work-order statuses, priorities, departmental assignments, and timestamps to provide for reporting and analysis.

## Reporting Development

The project will include creating SQL Server reporting datasets and formatted business reports.

Reports will include:

- **Service Request Summary:** Request volumes, categories, statuses, and date-range analysis.
- **Department Work Order Performance:** Departmental workloads, priorities, completion times, and deadline compliance.
