# DataAnalytics-Assessment
**A Repository of my Cowrywise assessment**

This project analyzes customer activity between funded savings and investment plans by running SQL queries against suitable database tables. Four main areas are emphasized:

Identifying customers with both funded savings and investment plans.

Analyzing transaction frequency including deposits and withdrawals.

Detecting inactive accounts based on recent transaction activity.

Estimating simplified Customer Lifetime Value (CLV) for customers.



**Per-Question Explanations**

**Question 1: Customers with Both Funded Savings & Investment Plans**

**Approach:**

Joined the user table with a grouped summary of plans per user to count how many savings and investment plans each user owns.

Calculated total deposits by summing confirmed amounts from all related savings accounts for each user.

Filtered to keep only customers who have at least one savings plan and one investment plan.

Returned user details and total deposits (converted from kobo to naira).

**Key points:**

Used conditional aggregation to count plans by type.

Subquery sums deposits for all plans belonging to each user.

**Question 2: Transaction Frequency Analysis**

**Approach:**

Treated withdrawals as well as deposits (savings transactions) as transactions and combined them using UNION ALL.

Created a temporary table of all transactions for each customer in order to find total number of transactions and active months.

Computed average transactions per month per customer and categorized them as High, Medium, or Low frequency users.

Categorized customer numbers by category and their mean transactions.

**Key points:**

Adding withdrawals provides an accurate picture of transaction activity.

Used TIMESTAMPDIFF to compute months active correctly and incremented 1 to avoid division by zero.

**Question 3: Account Inactivity Alert**

**Approach:**

Retrieved plans that are active (savings or investment).

Joined to find the date of the last transaction per plan.

Calculated inactivity as the number of days since the last transaction or since plan creation if no transactions exist.

Filtered for accounts inactive for more than 365 days or with no transactions at all.

**Key points:**

Left join ensures plans with no transactions are included.

Focused on identifying accounts needing review for inactivity.

**Question 4: Simple Customer Lifetime Value (CLV)**

**Approach:**

Computed per-transaction profit by multiplying confirmed amounts with a predetermined profit margin.

Aggredated up the transactions for each customer to find total profit, average profit per transaction, number of transactions, and tenure in months.

Computed estimated CLV by normalizing profit with tenure and extrapolating to a year (12 months).

Returned top 100 customers sorted by estimated CLV.

**Key points:**

Employed CTEs for modular and explicit aggregation steps.

Used NULLIF in division to handle customers with zero tenure safely.

**Challenges & Resolutions**

**Including withdrawals as transactions (Q2):**

Initially, only deposits were considered. After realizing withdrawals are also financial transactions, the code was adjusted to combine both deposits and withdrawals, providing a more accurate transaction frequency metric.

**Handling plans with no transactions (Q3):**

Some plans had no associated transactions, which risked being excluded. Using a LEFT JOIN and COALESCE allowed including these plans and properly calculating inactivity.

**Avoiding division by zero (Q4):**

When computing average monthly transactions and CLV, the tenure could be zero, leading to division errors. The NULLIF function was used to prevent division by zero, ensuring robust queries.
