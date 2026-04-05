create database telco_churn_analysis;
USE telco_churn_analysis;

SELECT * FROM raw_telco_data LIMIT 10;
SELECT COUNT(*) FROM raw_telco_data;

CREATE TABLE customers AS
SELECT 
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents
FROM raw_telco_data;
SELECT * FROM customers LIMIT 10;

CREATE TABLE services AS
SELECT 
    customerID,
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies
FROM raw_telco_data;
SELECT * FROM services LIMIT 10;

CREATE TABLE billing AS
SELECT 
    customerID,
    tenure,
    Contract,
    PaperlessBilling,
    PaymentMethod,
    MonthlyCharges,
    TotalCharges
FROM raw_telco_data;
SELECT * FROM billing LIMIT 10;

CREATE TABLE churn_analysis AS
SELECT 
    b.customerID,
    b.tenure,
    b.MonthlyCharges,
    b.TotalCharges,
    b.Contract,
    s.InternetService,
    s.TechSupport,
    r.Churn
FROM billing b
JOIN services s ON b.customerID = s.customerID
JOIN raw_telco_data r ON b.customerID = r.customerID;
SELECT * FROM churn_analysis LIMIT 10;

ALTER TABLE churn_analysis
ADD COLUMN Risk_Segment VARCHAR(50);

ALTER TABLE churn_analysis
MODIFY customerID VARCHAR(50),
ADD PRIMARY KEY (customerID);

SET SQL_SAFE_UPDATES = 0;
UPDATE churn_analysis
SET Risk_Segment = 
	CASE 
		WHEN tenure < 12 AND MonthlyCharges > 70 THEN 'High Risk'
		WHEN tenure < 24 THEN 'Medium Risk'
		ELSE 'Low Risk'
	END;


SELECT customerID, tenure, MonthlyCharges, Risk_Segment 
FROM churn_analysis 
LIMIT 20;

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE churn_analysis
ADD COLUMN Avg_Monthly_Value DECIMAL(10,2);

UPDATE churn_analysis
SET Avg_Monthly_Value = TotalCharges / NULLIF(tenure, 0);

SELECT * 
FROM churn_analysis
WHERE customerID IS NULL;

DELETE FROM churn_analysis
WHERE customerID IS NULL;

SELECT * FROM churn_analysis LIMIT 10;
SELECT COUNT(*) FROM churn_analysis;



