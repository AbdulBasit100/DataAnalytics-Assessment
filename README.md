# DataAnalytics-Assessment

## Question 1: High-Value Customers with Multiple Products
### Objective: Identify customers who hold both funded savings and investment plans.

Approach:

Joined users_customuser, savings_savingsaccount, and plans_plan tables.

Filtered for accounts with positive confirmed amounts (confirmed_amount > 0).

Used conditional aggregation (COUNT(CASE WHEN ...)) to count savings and investment plans per customer.

Applied a HAVING clause to include only customers with at least one savings and one investment plan.

Sorted results by total deposits in descending order.

## Question 2: Transaction Frequency Analysis
### Objective: Categorize customers based on their average monthly transaction frequency (High, Medium, Low).

Approach:

Calculated monthly transaction counts per user by grouping transactions by year and month.

Computed each customer’s average monthly transactions.

Categorized customers using SQL CASE statements:

High Frequency (≥10 transactions/month)

Medium Frequency (3–9 transactions/month)

Low Frequency (≤2 transactions/month)

Aggregated results by category to report customer counts and average transactions per category.

## Question 3: Account Inactivity Alert
### Objective: Identify active savings or investment accounts with no transactions in the last 365 days.

Approach:

Joined savings_savingsaccount and plans_plan tables to filter accounts by type (savings or investment).

Calculated each user-account pair’s last transaction date and days since last transaction.

Filtered accounts with inactivity exceeding 365 days using a HAVING clause.

Returned plan ID, user ID, account type, last transaction date (date only), and days inactive.

## Question 4: Customer Lifetime Value (CLV) Estimation
### Objective: Estimate CLV per customer based on tenure and transaction volume.

Approach:

Joined user data with transaction records.

Calculated account tenure in months from date_joined to current date.

Counted total transactions and computed average transaction amount (confirmed_amount).

Applied the CLV formula:

\text{CLV} = \left(\frac{\text{total_transactions}}{\text{tenure_months}}\right) \times 12 \times (0.1\% \times \text{avg_transaction_value})
Used LEFT JOIN to include users with zero transactions.

Handled zero-month tenure cases by setting CLV to zero.

Formed full customer names by concatenating first_name and last_name.

Ordered results by estimated CLV descending.


# Challenges & Resolutions
#### 1. Ambiguous Column Names:
I Initially had assumptions on columns like signup_date and is_active which were incorrect. After inspecting the schema, I replaced them with the correct columns (date_joined for signup, no explicit active status field).

#### 2. Null Name Values:
The name column was often null, requiring concatenation of first_name and last_name with null-safe handling (COALESCE).

#### 3. No Dedicated Transactions Table:
I Used savings_savingsaccount as the source for transactions, filtering on confirmed_amount > 0 to identify valid transactions.

#### 4. Date Formatting:
When I Needed last transaction dates without time to answer the question 3 (for the last transaction column); I applied SQL date functions (DATE()).

#### 5. Division by Zero in CLV Calculation:
Added logic to avoid dividing by zero months tenure by assigning CLV = 0 for such cases.
