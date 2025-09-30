-- =================================================================
-- SQL Query Script: Using Subqueries for Complex Lookups
-- =================================================================
-- This script demonstrates how to use subqueries (a query nested
-- inside another query) to perform complex data retrieval that
-- would be difficult or impossible with a single query.
-- =================================================================
-- Selects the 'healthcare' database to ensure all subsequent commands are run against it.
use healthcare;
-- =================================================================
-- 1. Subqueries with IN (Filtering against a list)
-- =================================================================
-- This is the most common use. The inner query runs first and
-- returns a list of values. The outer query then uses this list
-- to filter its results.

-- Query 1: Find the names of all patients who have an appointment with a Pediatrician.
-- The inner query first finds all DoctorIDs for 'Pediatrics'.
-- The outer query then finds the patients linked to those appointments.
SELECT
    FirstName,
    SecondName
FROM
    Patients
WHERE
    PatientID IN (
        SELECT PatientID FROM Appointments WHERE DoctorID IN (
            SELECT DoctorID FROM Doctors WHERE Specialization = 'Pediatrics'
        )
    );

-- Query 2: Find all doctors who have NOT treated the patient 'Aarav Mehta'.
-- The inner query gets the IDs of doctors who HAVE treated Aarav.
-- The outer query then selects all doctors who are NOT IN that list.
SELECT
    FirstName,
    SecondName
FROM
    Doctors
WHERE
    DoctorID NOT IN (
        SELECT DoctorID FROM Appointments WHERE PatientID = (
            SELECT PatientID FROM Patients WHERE FirstName = 'Aarav' AND SecondName = 'Mehta'
        )
    );

-- =================================================================
-- 2. Scalar Subqueries with = (Getting a single value)
-- =================================================================
-- A scalar subquery is a subquery that returns exactly one row and
-- one column. You can use it just like a single value.

-- Query 1: Find which patient had the most recent appointment.
-- The inner query finds the latest date and time from all appointments.
-- The outer query then finds the appointment that matches that exact time.
SELECT
    PatientID,
    AppointmentDateTime,
    Reason
FROM
    Appointments
WHERE
    AppointmentDateTime = (SELECT MAX(AppointmentDateTime) FROM Appointments);

-- Query 2: Get the medical record for a specific, known appointment.
-- (This is a simple example to show the concept clearly).
-- Let's find the record for the appointment with the reason 'Knee Injury (Cricket)'.
SELECT
    Diagnosis,
    TreatmentPlan,
    Prescription
FROM
    MedicalRecords
WHERE
    AppointmentID = (SELECT AppointmentID FROM Appointments WHERE Reason = 'Knee Injury (Cricket)');


-- =================================================================
-- 3. Subqueries with EXISTS (Checking for existence)
-- =================================================================
-- EXISTS is used to check if the subquery returns any rows at all.
-- It's often more efficient than IN because it stops processing
-- as soon as it finds one matching row. It returns TRUE or FALSE.

-- Query 1: Find all doctors who have at least one scheduled appointment.
-- For each doctor, the subquery checks if any record exists in Appointments for them.
SELECT
    FirstName,
    SecondName
FROM
    Doctors D
WHERE EXISTS (
    SELECT 1 FROM Appointments A WHERE A.DoctorID = D.DoctorID
);

-- Query 2: Find all patients who do NOT have any medical records yet.
-- NOT EXISTS checks if the subquery returns zero rows.
SELECT
    FirstName,
    SecondName
FROM
    Patients P
WHERE NOT EXISTS (
    SELECT 1 FROM MedicalRecords MR WHERE MR.PatientID = P.PatientID
);


-- =================================================================
-- 4. Correlated Subqueries (The clever assistant)
-- =================================================================
-- This is an advanced type where the inner query depends on the
-- outer query for its values. It's like the inner query runs once
-- for every single row processed by the outer query.

-- Query 1: For each patient, show their name and the date of their last appointment.
-- For each patient (P) in the outer query, the inner query runs to find the
-- MAX appointment date specifically for that patient's ID.
SELECT
    P.FirstName,
    P.SecondName,
    (SELECT MAX(A.AppointmentDateTime)
     FROM Appointments A
     WHERE A.PatientID = P.PatientID) AS LastAppointmentDate
FROM
    Patients P;

-- Query 2: Find all appointments that are the FIRST ever appointment for that specific patient.
-- For each appointment (A1) in the outer query, the inner query checks if its date
-- is the MINIMUM date for that same patient.
SELECT
    A1.PatientID,
    A1.AppointmentDateTime,
    A1.Reason
FROM
    Appointments A1
WHERE
    A1.AppointmentDateTime = (
        SELECT MIN(A2.AppointmentDateTime)
        FROM Appointments A2
        WHERE A2.PatientID = A1.PatientID
    );
