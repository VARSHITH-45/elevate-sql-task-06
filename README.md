**SQL Subquery Operations | Task 06**


This repository contains the SQL script SubQuerieshealthcare_schema.sql, which provides a practical guide to using subqueries (also known as inner queries or nested queries) for complex data retrieval. Using a healthcare database schema, the script showcases how to leverage different types of subqueries to answer questions that would be difficult or inefficient to handle with simple joins.

The project covers a range of subquery implementations, from basic list filtering with IN to advanced row-by-row processing with correlated subqueries.

**Tasks Performed & Core Concepts**

The script is structured to clearly demonstrate each type of subquery, explaining its purpose and providing practical examples.


**1. Subqueries with IN**


This section demonstrates the most common use case for subqueries: generating a list of values to be used as a filter in the main query's WHERE clause.

**Query 1:** Identifies all patients who have appointments with a Pediatrician by using a nested subquery to first find the relevant doctor IDs.

**Query 2:** Uses NOT IN to find all doctors who have not treated a specific patient, showcasing how to filter based on exclusion.


**2. Scalar Subqueries with =**


A scalar subquery is one that returns a single value (one row, one column). This section shows how it can be used in a comparison.

**Query 1:** Finds the patient who had the most recent appointment by first running a subquery to find the MAX(AppointmentDateTime).

**Query 2:** Retrieves a specific medical record by using a subquery to find the AppointmentID based on the reason for the visit.


**3. Subqueries with EXISTS**


The EXISTS operator is a highly efficient way to check for the existence of rows returned by a subquery. It returns TRUE if the subquery returns one or more rows.

**Query 1:** Finds all doctors who have at least one appointment scheduled, demonstrating a common and efficient check.

**Query 2:** Uses NOT EXISTS to find all patients who do not yet have any medical records, a classic use case for finding records that lack a corresponding entry in another table.


**4. Correlated Subqueries**


This is the most advanced topic covered. A correlated subquery is one where the inner query depends on the outer query for its values, meaning it is executed repeatedly, once for each row processed by the outer query.

Challenge & Diagnosis: These queries solve problems that are difficult for standard joins, such as finding an aggregate value related to each specific row of the outer query.

**Query 1:** For each patient, it calculates and displays the date of their last appointment.

**Query 2:** It identifies all appointments that were the first-ever appointment for each patient by comparing each appointment's date to the minimum date for that same patient.

**How to Use**

Ensure the healthcare database schema is created and populated with data.

Open the SubQuerieshealthcare_schema.sql file in a MySQL-compatible client.

Execute the queries individually to observe how each subquery type retrieves and filters data in a unique way.
