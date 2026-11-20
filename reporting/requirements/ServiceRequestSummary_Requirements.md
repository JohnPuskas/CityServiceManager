# Service Request Summary — Report Requirements

## 1. Purpose

Provide municipal staff with a summary of service
requests submitted during a selected reporting period.

The report will present request volumes, current statuses,
request type distributions, and monthly submission trends.

## 2. Data Sources

The report will retrieve data from the CityServiceManager
SQL Server database using:

- dbo.vw_ServiceRequestStatus
- dbo.RequestTypes
- dbo.Locations

Each service request should appear exactly once in the
underlying detail dataset.

## 3. Report Parameters

| Parameter | Type | Description |
|---|---|---|
| @StartDate | DATE | First submission date to include |
| @EndDate | DATE | Last submission date to include |
| @RequestTypeID | INT (nullable) | Filter by request type; NULL includes all |
| @EffectiveStatus | NVARCHAR(20) (nullable) | Filter by status; NULL includes all |

The date range is inclusive of both selected calendar dates.

The SQL query will implement this using an inclusive
start boundary and an exclusive upper boundary.

## 4. Report Sections

### A. Executive Summary

Display the following metrics:

- Total Requests
- Open Requests
- In Progress Requests
- Closed Requests
- Canceled Requests

All counts should reflect the selected report parameters.

### B. Request Type Breakdown

Display a grouped table containing:

- Request Type
- Request Count
- Percentage of Filtered Total

Include a grand total row.

### C. Monthly Submission Trend

Display a chart showing the number of submitted requests
by calendar year and month.

Monthly totals should reflect the selected report parameters.

## 5. Business Rules

1. The reporting period is based on ServiceRequests.SubmittedAt.
2. Effective status is retrieved from dbo.vw_ServiceRequestStatus.
3. Open includes requests without work orders and requests
   whose associated work orders have Open status.
4. Closed corresponds to completed work orders.
5. Canceled requests have no associated work orders.
6. Status values represent current statuses, not historical 
   status snapshots.
7. A request is counted once, regardless of related records.
8. Percentages use the total number of requests matching
   all selected filters as the denominator.

## 6. Initial Detail Dataset Fields

| Field | Source |
|---|---|
| ServiceRequestID | vw_ServiceRequestStatus |
| SubmittedAt | vw_ServiceRequestStatus |
| Description | vw_ServiceRequestStatus |
| RequestTypeID | vw_ServiceRequestStatus |
| RequestTypeName | RequestTypes |
| EffectiveStatus | vw_ServiceRequestStatus |
| LocationID | vw_ServiceRequestStatus |
| PostalCode | Locations |

## 7. Validation Requirements

Validation will include:

- One row per service request
- Correct request type and status values
- Date range boundary behavior
- Optional parameter filtering
- Accurate grouped counts and percentages
- Reconciliation of monthly totals
- Match between SQL results and report output
- Accurate PDF and Excel exports

## 8. Report Development Tools

Report designer:

- Microsoft Power BI Report Builder

## 9. Deliverables

- Parameterized T-SQL reporting dataset
- SQL validation scripts
- Microsoft Report Builder .rdl template
- Sample PDF and Excel exports