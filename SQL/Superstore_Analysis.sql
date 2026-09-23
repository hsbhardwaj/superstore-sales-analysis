CREATE DATABASE superstore_db;

USE superstore_db;
CREATE TABLE superstore (
    `Row ID` INT,
    `Order ID` VARCHAR(30),
    `Order Date` DATE,
    `Ship Date` DATE,
    `Ship Mode` VARCHAR(50),
    `Customer ID` VARCHAR(30),
    `Customer Name` VARCHAR(100),
    `Segment` VARCHAR(50),
    `Country` VARCHAR(100),
    `City` VARCHAR(100),
    `State` VARCHAR(100),
    `Postal Code` VARCHAR(20),
    `Region` VARCHAR(50),
    `Product ID` VARCHAR(30),
    `Category` VARCHAR(50),
    `Sub-Category` VARCHAR(50),
    `Product Name` VARCHAR(255),
    `Sales` DECIMAL(14,3),
    `Quantity` INT,
    `Discount` DECIMAL(5,2),
    `Profit` DECIMAL(14,3)
);
SHOW TABLES;
DESCRIBE superstore;
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'D:/Project-2/Sample - Superstore.csv'
INTO TABLE superstore
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    `Row ID`,
    `Order ID`,
    @OrderDate,
    @ShipDate,
    `Ship Mode`,
    `Customer ID`,
    `Customer Name`,
    `Segment`,
    `Country`,
    `City`,
    `State`,
    `Postal Code`,
    `Region`,
    `Product ID`,
    `Category`,
    `Sub-Category`,
    `Product Name`,
    @Sales,
    `Quantity`,
    @Discount,
    @Profit
)
SET
    `Order Date` = STR_TO_DATE(TRIM(@OrderDate), '%m/%d/%Y'),
    `Ship Date` = STR_TO_DATE(TRIM(@ShipDate), '%m/%d/%Y'),
    `Sales` = CAST(TRIM(@Sales) AS DECIMAL(14,3)),
    `Discount` = CAST(TRIM(@Discount) AS DECIMAL(5,2)),
    `Profit` = CAST(TRIM(@Profit) AS DECIMAL(14,3));
    DESCRIBE superstore;
    TRUNCATE TABLE superstore;
SELECT COUNT(*) AS Total_Rows
FROM superstore;
SHOW WARNINGS LIMIT 20;
SELECT *
FROM superstore
LIMIT 10;
SELECT
    COUNT(*) AS Total_Rows,
    SUM(`Order Date` IS NULL) AS Missing_Order_Date,
    SUM(`Ship Date` IS NULL) AS Missing_Ship_Date,
    SUM(Sales IS NULL) AS Missing_Sales,
    SUM(Quantity IS NULL) AS Missing_Quantity,
    SUM(Discount IS NULL) AS Missing_Discount,
    SUM(Profit IS NULL) AS Missing_Profit
FROM superstore;
SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    COUNT(DISTINCT `Customer ID`) AS Total_Customers,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM superstore;
SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM superstore
GROUP BY Category
ORDER BY Total_Sales DESC;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. Technology is the most profitable category,
--    generating approximately $145.46K in profit.

-- 2. Office Supplies has the highest quantity sold,
--    with 22,906 units.

-- 3. Furniture generates approximately $742K in sales,
--    but only about $18.45K in profit.

-- 4. High sales or quantity does not necessarily
--    result in high profitability.

-- =========================================
--  SUB-CATEGORY ANALYSIS
-- =========================================

SELECT
    `Sub-Category`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM superstore
GROUP BY `Sub-Category`
ORDER BY Total_Profit DESC;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. Copiers are the most profitable sub-category,
--    generating approximately $55.62K in profit.

-- 2. Phones generate the highest sales among all
--    sub-categories, with approximately $330.01K in sales.

-- 3. Paper has relatively low sales but generates
--    approximately $34.05K in profit.

-- 4. Tables are the biggest loss-making sub-category,
--    generating approximately $206.97K in sales but
--    a loss of approximately $17.73K.

-- 5. Bookcases and Supplies are also loss-making
--    sub-categories.

-- 6. High sales do not necessarily result in high
--    profitability.

-- =========================================
--      PROFIT MARGIN BY SUB-CATEGORY
-- =========================================

SELECT
    `Sub-Category`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY `Sub-Category`
ORDER BY Profit_Margin_Percent DESC;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. Labels have the highest profit margin at 44.42%.

-- 2. Paper and Envelopes also have strong profit
--    margins of 43.39% and 42.27% respectively.

-- 3. Copiers generate a strong profit margin of 37.20%.

-- 4. Machines have a very low profit margin of only
--    1.79% despite generating approximately $189K in sales.

-- 5. Supplies, Bookcases and Tables have negative
--    profit margins.

-- 6. Tables have the lowest profit margin at -8.56%,
--    indicating a significant profitability problem.

-- 7. High sales do not necessarily translate into
--    high profit margins.

-- =========================================
--      REGIONAL PERFORMANCE
-- =========================================

SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. West is the strongest region overall,
--    generating approximately $725.46K in sales
--    and $108.42K in profit.

-- 2. East is the second-highest region in terms
--    of sales, generating approximately $678.78K.

-- 3. Central has the lowest profit margin at 7.92%,
--    which indicates relatively weak profitability.

-- 4. West has the highest profit margin at 14.94%
--    among all regions.

-- 5. Central generates more sales than South,
--    but its profit is lower, showing that higher
--    sales do not always mean higher profitability.

-- 6. Regional performance should be evaluated using
--    both sales and profitability, rather than sales alone.

-- =========================================
--      REGIONAL + DISCOUNT ANALYSIS
-- =========================================

SELECT
    Region,
    ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Percent,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY Region
ORDER BY Avg_Discount_Percent DESC;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. Central has the highest average discount at 24.04%
--    and the lowest profit margin at 7.92%.

-- 2. West has the lowest average discount at 10.93%
--    and the highest profit margin at 14.94%.

-- 3. The results show an association between higher
--    discount levels and lower profitability across regions.

-- 4. Central should be investigated further to identify
--    which categories or sub-categories are contributing
--    to its low profitability.

-- 5. Discount strategy should be reviewed region-wise
--    to balance sales growth with profitability.

-- =========================================
--       CENTRAL REGION SUB-CATEGORY ANALYSIS
-- =========================================

SELECT
    `Sub-Category`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent,
    ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Percent
FROM superstore
WHERE Region = 'Central'
GROUP BY `Sub-Category`
ORDER BY Total_Profit ASC;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. Furnishings is the biggest loss-making
--    sub-category in the Central region, with
--    approximately $3.91K in losses and a
--    -25.61% profit margin.

-- 2. Tables and Appliances are also major
--    loss-making sub-categories, with losses of
--    approximately $3.56K and $2.64K respectively.

-- 3. Several loss-making sub-categories have
--    relatively high average discounts, including
--    Furnishings, Appliances, Machines and Binders.

-- 4. Binders generate approximately $56.92K in sales
--    but still produce a loss of approximately $1.04K,
--    with an average discount of 50.93%.

-- 5. Central's profitability problem is concentrated
--    in specific sub-categories rather than across
--    the entire region.

-- 6. Discount policies for loss-making sub-categories
--    should be reviewed to improve regional profitability.

-- =========================================
--      TOP 10 LOSS-MAKING PRODUCTS
-- =========================================

SELECT
    `Product Name`,
    `Category`,
    `Sub-Category`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Percent
FROM superstore
GROUP BY
    `Product Name`,
    Category,
    `Sub-Category`
ORDER BY Total_Profit ASC
LIMIT 10;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. The Cubify CubeX 3D Printer Double Head Print
--    is the largest loss-making product, generating
--    approximately $8.88K in losses.

-- 2. Several of the top loss-making products have
--    relatively high average discount levels,
--    ranging from approximately 28% to 53%.

-- 3. Machines contain several major loss-making
--    products, including the Cubify CubeX printers
--    and Lexmark MX611dhe printer.

-- 4. Tables also contain multiple products among
--    the top loss-makers.

-- 5. The results suggest that certain products may
--    require closer review of their pricing and
--    discount strategies.

-- 6. High discounts are associated with several
--    major loss-making products, but this analysis
--    alone does not prove that discounts caused
--    the losses.
-- =========================================
--      CUSTOMER PROFITABILITY ANALYSIS
-- =========================================

SELECT
    `Customer Name`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY `Customer Name`
ORDER BY Total_Profit ASC
LIMIT 10;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. Cindy Stewart is the most loss-making customer,
--    generating approximately $6.63K in losses despite
--    approximately $5.69K in sales.

-- 2. Several customers generate significant sales but
--    still result in negative profitability.

-- 3. Sean Miller generated approximately $25.04K in sales
--    but produced a loss of approximately $1.98K, showing
--    that high customer sales do not always mean
--    profitable customers.

-- 4. Some customers have extremely negative profit margins,
--    indicating that their transactions require further
--    investigation.

-- 5. Customer-level profitability should be monitored
--    alongside sales when evaluating customer performance.
-- =========================================
--     LOSS-MAKING CUSTOMER DRILL-DOWN
-- =========================================

SELECT
    `Order ID`,
    `Product Name`,
    `Category`,
    `Sub-Category`,
    ROUND(Sales, 2) AS Sales,
    ROUND(Discount * 100, 2) AS Discount_Percent,
    ROUND(Profit, 2) AS Profit
FROM superstore
WHERE `Customer Name` = 'Cindy Stewart'
ORDER BY Profit ASC;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. Cindy Stewart's overall loss is primarily
--    driven by the Cubify CubeX 3D Printer Double
--    Head Print transaction.

-- 2. The Cubify CubeX transaction generated $4.50K
--    in sales but resulted in a loss of approximately
--    $6.60K at a 70% discount.

-- 3. The GBC Ibimaster 500 Binding System also generated
--    a loss of approximately $304 at a 70% discount.

-- 4. The remaining transactions for Cindy Stewart
--    generated positive profit.

-- 5. This shows that customer-level losses can sometimes
--    be concentrated in specific product transactions.

-- 6. Highly discounted loss-making transactions should
--    be reviewed before applying similar discounts in
--    future sales.

-- =========================================
--    YEARLY SALES & PROFIT ANALYSIS
-- =========================================

SELECT
    YEAR(`Order Date`) AS Order_Year,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY YEAR(`Order Date`)
ORDER BY Order_Year;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. Sales increased substantially from approximately
--    $484.25K in 2014 to $733.22K in 2017.

-- 2. Total profit increased every year, from
--    approximately $49.54K in 2014 to $93.44K in 2017.

-- 3. In 2015, sales decreased slightly compared with
--    2014, but profit increased, indicating improved
--    profitability despite lower sales.

-- 4. 2017 recorded the highest sales and profit
--    during the period analyzed.

-- 5. Profit margin increased from 10.23% in 2014
--    to 13.43% in 2016, before declining slightly
--    to 12.74% in 2017.

-- 6. Overall, the business shows strong growth in
--    sales and profit, although the decline in profit
--    margin in 2017 should be monitored.

-- =========================================
--      MONTHLY SALES & PROFIT ANALYSIS
-- =========================================

SELECT
    MONTH(`Order Date`) AS Month_Number,
    MONTHNAME(`Order Date`) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM superstore
GROUP BY
    MONTH(`Order Date`),
    MONTHNAME(`Order Date`)
ORDER BY Month_Number;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. November recorded the highest sales,
--    approximately $352.46K, followed by
--    December at approximately $325.29K.

-- 2. February recorded the lowest sales,
--    approximately $59.75K, indicating a
--    relatively weak sales period.

-- 3. December recorded the highest profit,
--    approximately $43.37K, despite November
--    having the highest sales.

-- 4. November recorded the highest quantity
--    sold with 5,775 units and the highest
--    number of orders with 753 orders.

-- 5. Sales increased substantially during the
--    final four months, with September,
--    October, November, and December being
--    the strongest-performing months.

-- 6. The business shows a clear seasonal
--    pattern, with sales and order volumes
--    generally increasing toward the end
--    of the year.

-- 7. Overall, November was the strongest
--    month based on sales, quantity sold,
--    and number of orders, while December
--    generated the highest profit.

-- 8. The business should focus on increasing
--    inventory and marketing activities during
--    high-performing months while developing
--    strategies to improve weaker months
--    such as January and February.

-- =========================================
--      MONTHLY PROFIT ANALYSIS
-- =========================================


SELECT
    MONTH(`Order Date`) AS Month_Number,
    MONTHNAME(`Order Date`) AS Month,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM Superstore
GROUP BY
    MONTH(`Order Date`),
    MONTHNAME(`Order Date`)
ORDER BY
    Total_Profit DESC;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. December recorded the highest monthly
--    profit, approximately $43.37K.

-- 2. January recorded the lowest monthly
--    profit, approximately $9.13K.

-- 3. September was the second-highest
--    profit-generating month, with approximately
--    $36.86K in profit.

-- 4. November generated approximately $35.47K
--    in profit, making it the third-highest
--    profitable month.

-- 5. The months from September to December
--    consistently recorded high profit,
--    indicating a strong year-end performance.

-- 6. Profit was relatively low during January
--    and February, with both months generating
--    less than $11K in profit.

-- 7. December generated the highest profit
--    even though November had the highest sales,
--    showing that higher sales do not always
--    directly result in the highest profit.

-- 8. Overall, the business shows a strong
--    seasonal profit pattern, with profitability
--    increasing significantly toward the end
--    of the year.
-- =========================================
-- STEP 21: TOP 10 MOST PROFITABLE PRODUCTS
-- =========================================

SELECT
    `Product Name`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM Superstore
GROUP BY
    `Product Name`
ORDER BY
    Total_Profit DESC
LIMIT 10;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. Canon imageCLASS 2200 Advanced Copier
--    is the most profitable product, generating
--    approximately $25.20K in profit from
--    approximately $61.60K in sales.

-- 2. Fellowes PB500 Electric Punch Plastic Comb
--    Binding Machine ranks second with approximately
--    $7.75K in profit.

-- 3. Hewlett Packard LaserJet 3310 Copier ranks
--    third with approximately $6.98K in profit.

-- 4. Canon PC1060 Personal Laser Copier generated
--    approximately $4.57K in profit from only
--    19 units sold, indicating strong profitability
--    per unit.

-- 5. The top 10 products are mainly printers,
--    copiers, binding machines, and other office
--    equipment, showing that high-value office
--    technology products contribute significantly
--    to overall profit.

-- 6. Canon imageCLASS 2200 Advanced Copier generated
--    the highest sales as well as the highest profit
--    among the top 10 products.

-- 7. Zebra ZM400 Thermal Label Printer generated
--    approximately $3.34K profit from only 6 units,
--    indicating strong profit per unit.

-- 8. High profitability is not always dependent on
--    selling a large quantity. Several products
--    generated substantial profit despite relatively
--    low unit sales.

-- 9. The business should maintain sufficient
--    inventory of highly profitable office equipment
--    and consider promoting these products to
--    maximize profitability.

-- 10. The analysis shows that premium office equipment
--     can be an important driver of business profit.

-- =========================================
-- STEP 22: TOP 10 CUSTOMERS BY SALES
-- =========================================

SELECT
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM Superstore
GROUP BY
    `Customer Name`
ORDER BY
    Total_Sales DESC
LIMIT 10;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. Sean Miller generated the highest sales
--    among all customers, with approximately
--    $25.04K in total sales.

-- 2. However, Sean Miller generated a loss of
--    approximately $1.98K, showing that high
--    sales do not always result in high profit.

-- 3. Tamara Chand generated approximately $19.05K
--    in sales and $8.98K in profit, making her one
--    of the most valuable customers.

-- 4. Raymond Buch generated approximately $15.12K
--    in sales and $6.98K in profit, showing strong
--    profitability.

-- 5. Adrian Barton purchased the highest quantity
--    among the listed customers with 73 units.
--    Sanjit Chand purchased 87 units, while
--    Ken Lonsdale purchased the highest quantity
--    overall with 113 units.

-- 6. Ken Lonsdale generated approximately $14.18K
--    in sales but only $806.86 in profit, indicating
--    relatively low profitability despite high
--    purchase quantity.

-- 7. The results show that customer sales volume
--    and customer profitability can be significantly
--    different.

-- 8. Sean Miller should be investigated further to
--    understand why the highest sales customer is
--    generating a negative profit.

-- 9. The business should focus not only on acquiring
--    high-sales customers but also on maintaining
--    profitable customer relationships.

-- 10. Customers such as Tamara Chand and Raymond Buch
--     are particularly valuable because they combine
--     high sales with strong profit generation.

-- =========================================
-- STEP 23: TOP 10 CUSTOMERS BY PROFIT
-- =========================================

SELECT
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM Superstore
GROUP BY
    `Customer Name`
ORDER BY
    Total_Profit DESC
LIMIT 10;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. Tamara Chand is the most profitable customer,
--    generating approximately $8.98K in profit
--    from approximately $19.05K in sales.

-- 2. Raymond Buch ranks second with approximately
--    $6.98K in profit from approximately $15.12K
--    in sales.

-- 3. Sanjit Chand ranks third with approximately
--    $5.76K in profit and 87 units purchased,
--    showing a strong and valuable customer
--    relationship.

-- 4. Hunter Lopez and Adrian Barton also generated
--    strong profits of approximately $5.62K and
--    $5.44K respectively.

-- 5. Tamara Chand generated the highest profit
--    among all customers even though Sean Miller
--    had the highest total sales.

-- 6. Sean Miller, who ranked first by sales in
--    Step 22, does not appear in the top 10
--    profitable customers because the customer
--    generated a loss of approximately $1.98K.

-- 7. This demonstrates that sales volume alone
--    is not sufficient to identify the most valuable
--    customers.

-- 8. Customers such as Tamara Chand and Raymond Buch
--    should be prioritized for customer retention
--    and loyalty strategies because they generate
--    both high sales and high profit.

-- 9. The business should investigate customers
--    generating high sales but low or negative profit
--    to identify issues such as excessive discounts,
--    low-margin products, or costly orders.

-- 10. Overall, customer profitability analysis helps
--     the business focus resources on customers who
--     contribute the most to sustainable profit.

-- =========================================
-- STEP 24: SHIP MODE PERFORMANCE
-- =========================================

SELECT
    `Ship Mode`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM Superstore
GROUP BY
    `Ship Mode`
ORDER BY
    Total_Profit DESC;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. Standard Class generated the highest sales,
--    approximately $1.36M, and the highest profit,
--    approximately $164.09K.

-- 2. Standard Class also handled the highest
--    quantity of products with 22,797 units and
--    the highest number of orders with 2,994 orders.

-- 3. Second Class ranked second with approximately
--    $459.19K in sales and $57.45K in profit.

-- 4. First Class generated approximately $351.43K
--    in sales and $48.97K in profit, ranking third
--    in both sales and profit.

-- 5. Same Day shipping had the lowest sales and
--    profit, generating approximately $128.36K
--    in sales and $15.89K in profit.

-- 6. Standard Class accounts for the majority of
--    the business's shipping activity, indicating
--    that customers primarily prefer economical
--    shipping over faster delivery options.

-- 7. Same Day shipping has the lowest order volume,
--    with only 264 orders, suggesting relatively
--    low demand for premium-speed delivery.

-- 8. The results show that shipping mode performance
--    is strongly influenced by order volume.

-- 9. The business should maintain reliable Standard
--    Class shipping capacity because it supports the
--    largest share of sales and orders.

-- 10. Faster shipping options should be evaluated
--     based on their additional cost and profitability
--     rather than sales volume alone.

-- =========================================
-- STEP 25: STATE-WISE PERFORMANCE
-- =========================================

SELECT
    State,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM Superstore
GROUP BY
    State
ORDER BY
    Total_Profit DESC;
-- =========================================
-- BUSINESS INSIGHTS
-- =========================================

-- 1. California is the strongest-performing state,
--    generating approximately $457.69K in sales
--    and $76.38K in profit.

-- 2. New York ranks second in profitability,
--    generating approximately $74.04K in profit
--    from $310.88K in sales.

-- 3. Washington ranks third in profit with
--    approximately $33.40K from $138.64K in sales.

-- 4. California also recorded the highest number
--    of orders with 1,021 and the highest quantity
--    sold with 7,667 units.

-- 5. Texas is the biggest loss-making state,
--    generating approximately $170.19K in sales
--    but recording a loss of approximately $25.73K.

-- 6. Ohio, Pennsylvania, Illinois, North Carolina,
--    Colorado, and Tennessee also recorded
--    significant losses.

-- 7. Pennsylvania generated approximately $116.51K
--    in sales but recorded a loss of approximately
--    $15.56K, indicating poor profitability despite
--    substantial sales volume.

-- 8. Illinois generated approximately $80.17K in
--    sales but recorded a loss of approximately
--    $12.61K.

-- 9. The analysis demonstrates that high sales
--    volume does not always translate into high
--    profitability at the state level.

-- 10. Loss-making states should be investigated
--     further for factors such as excessive discounts,
--     low-margin products, and unfavorable product
--     combinations.

-- 11. Strong states such as California and New York
--     should be studied to identify successful
--     products, customers, and sales strategies.

-- 12. Overall, the business should focus on
--     improving profitability in major loss-making
--     states while maintaining growth in
--     high-profit states.

-- =========================================
-- STEP 26: FINAL BUSINESS PERFORMANCE SUMMARY
-- =========================================

-- =========================================
-- 1. OVERALL BUSINESS PERFORMANCE
-- =========================================

-- The Superstore dataset contains approximately
-- 9,994 records covering multiple years, products,
-- customers, regions, and states.

-- The business generated strong overall sales and
-- positive overall profit, but profitability varies
-- significantly across products, customers, regions,
-- and states.


-- =========================================
-- 2. CATEGORY & SUB-CATEGORY PERFORMANCE
-- =========================================

-- Technology is one of the strongest contributors
-- to business performance, particularly through
-- high-value products such as copiers and printers.

-- Some sub-categories generate strong sales but
-- relatively low or negative profit, showing that
-- sales volume alone should not be used to evaluate
-- business performance.

-- Profitability should therefore be analyzed
-- alongside sales and discount levels.


-- =========================================
-- 3. REGIONAL PERFORMANCE
-- =========================================

-- The analysis shows significant differences in
-- profitability between regions.

-- The Central region requires particular attention
-- because several sub-categories and products
-- contribute to weaker profitability.

-- Regional performance should be evaluated together
-- with product mix and discount strategy.


-- =========================================
-- 4. YEARLY & MONTHLY PERFORMANCE
-- =========================================

-- Business performance improved significantly during
-- the later months of the year.

-- November recorded the highest sales at approximately
-- $352.46K.

-- December recorded the highest monthly profit at
-- approximately $43.37K.

-- January recorded the lowest monthly profit at
-- approximately $9.13K.

-- September to December consistently showed strong
-- sales and profitability, indicating a strong
-- year-end seasonal pattern.


-- =========================================
-- 5. PRODUCT PERFORMANCE
-- =========================================

-- Canon imageCLASS 2200 Advanced Copier was the
-- most profitable product, generating approximately
-- $25.20K in profit.

-- Several other highly profitable products were
-- printers, copiers, binding machines, and office
-- equipment.

-- Some products generated substantial profit despite
-- relatively low quantities sold, showing that
-- high-value products can have a major impact on
-- overall profitability.

-- Loss-making products identified earlier should
-- be reviewed for excessive discounts, pricing
-- issues, and low margins.


-- =========================================
-- 6. CUSTOMER PERFORMANCE
-- =========================================

-- Sean Miller generated the highest customer sales
-- at approximately $25.04K but generated a loss of
-- approximately $1.98K.

-- Tamara Chand was the most profitable customer,
-- generating approximately $8.98K in profit.

-- Raymond Buch ranked second in customer profitability
-- with approximately $6.98K in profit.

-- This demonstrates that the customer with the highest
-- sales is not necessarily the most valuable customer
-- from a profitability perspective.

-- The business should prioritize customers who
-- generate both high sales and strong profit.


-- =========================================
-- 7. SHIPPING PERFORMANCE
-- =========================================

-- Standard Class was the dominant shipping mode,
-- generating approximately $1.36M in sales and
-- $164.09K in profit.

-- Standard Class also handled the highest number
-- of orders and units.

-- Same Day shipping had the lowest sales and profit,
-- indicating relatively low demand for premium-speed
-- delivery.


-- =========================================
-- 8. STATE-WISE PERFORMANCE
-- =========================================

-- California was the strongest state, generating
-- approximately $457.69K in sales and $76.38K
-- in profit.

-- New York ranked second in profitability with
-- approximately $74.04K in profit.

-- Texas was the biggest loss-making state,
-- generating approximately $170.19K in sales
-- but recording a loss of approximately $25.73K.

-- Ohio, Pennsylvania, Illinois, North Carolina,
-- Colorado, and Tennessee also recorded significant
-- losses.

-- These states should be investigated for discounting,
-- product mix, pricing, and shipping-related costs.


-- =========================================
-- 9. KEY BUSINESS PROBLEM
-- =========================================

-- The major business issue identified throughout
-- the analysis is that high sales do not always
-- result in high profit.

-- This pattern was observed at the product,
-- customer, and state levels.

-- Excessive discounts and low-margin sales should
-- therefore be investigated carefully.


-- =========================================
-- 10. FINAL BUSINESS RECOMMENDATIONS
-- =========================================

-- 1. Focus on high-profit products such as copiers,
--    printers, and other high-value office equipment.

-- 2. Investigate products generating high sales but
--    negative or very low profit.

-- 3. Prioritize highly profitable customers such as
--    Tamara Chand and Raymond Buch for retention
--    and loyalty strategies.

-- 4. Investigate high-sales customers who generate
--    low or negative profit.

-- 5. Review pricing and discount strategies,
--    particularly in loss-making states and
--    sub-categories.

-- 6. Maintain strong inventory and marketing efforts
--    during the high-performing September–December
--    period.

-- 7. Develop strategies to improve weak periods such
--    as January and February.

-- 8. Maintain reliable Standard Class shipping
--    capacity because it represents the largest
--    share of orders and sales.

-- 9. Investigate major loss-making states such as
--    Texas, Ohio, Pennsylvania, Illinois, and
--    North Carolina.

-- 10. Use profitability rather than sales alone as
--     the primary measure for important business
--     decisions.


-- =========================================
-- PROJECT: SQL ANALYSIS COMPLETED
-- =========================================