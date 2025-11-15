> I used ChatGPT to refine the wording, improve phrasing, and correct grammar.  
> However, the core ideas, reasoning, and main topic are entirely my own.

## 📌 Overview
This document outlines the complete analytical method to:

1. Verify whether sales performance on our own platform is statistically different from third-party platforms.
2. Analyze third-party marketplace data to understand customer and product frequently bought together.
3. Build full user activity tracking on our own platform.
4. Engineer features and identify key factors influencing sales.

We assume the following data is available from two third-party platforms:

- **Order Data**: `order_id`, `date`, `customer_id` (masked), `product_id`, `unit_price`, `quantity`, `fees`, `shipping`, `discount`, `device`, `region`
- **Product Data**: `product_id`, `category`, `brand`, `attributes/specs`
- **Traffic/Ads Data**: `campaign_source`, `impressions`, `clicks`, `conversions`

Note : for this problem. I try to demonstrate on my statistics, data science foundation and basic tools . No need for advanced neural network models and tools . Just SQL, pandas and matplotlib
---

# 1. Statistical Validation of Sales Differences

### 🎯 Goal  
To confirm whether the observed drop in sales on our platform is statistically significant and not due to random variation.

### 🔬 Methods

#### 1.1 Compare Sales Volume
- **Tests**:  
  - Two-sample t-test  
- **Metric**: daily/weekly units sold

#### 1.2 Compare Conversion Rate
- **Test**: Two-proportion z-test  
- **Metric**: conversions / clicks  

#### 1.3 Compare Revenue Per Order or Per Session
- **Tests**:  
  - t-test  
  - Bootstrap confidence intervals  

If statistically significant differences are found, proceed to deeper analysis.

---

# 2. Descriptive Analysis of Third-Party Platform Data

### 🎯 Goal  
Understand the behavior of customers on third-party platforms to identify what we must replicate or improve on our own platform.

---

## 2.1 Customer Acquisition Channels
Analyze traffic sources using `campaign_source`:

- Search 
- Ads 
- Social affiliation
- Internal recommendation engine

Using SQL to agregate data by chanel to see which source drive the traffic 
For ex.
    SELECT
    campaign_source,
    COUNT(*) AS sessions,
    SUM(CASE WHEN added_to_cart = true THEN 1 ELSE 0 END) AS carts,
    SUM(CASE WHEN purchased = true THEN 1 ELSE 0 END) AS purchases,
    SUM(CASE WHEN purchased = true THEN revenue ELSE 0 END) AS total_revenue,
    SUM(CASE WHEN purchased = true THEN 1 ELSE 0 END)::float /
    NULLIF(SUM(CASE WHEN added_to_cart = true THEN 1 ELSE 0 END), 0) 
        AS cart_to_purchase_cvr
    FROM traffic_events
    GROUP BY campaign_source;

---

## 2.3 Product Relationship Analysis (Frequently Bought Together)
For most third party platform , The recomendation system was used to offer product customer might buy together

**Algorithms:**

- Co-occurrence matrix  
- Association Rule Mining (Apriori, FP-Growth)

---

## 2.4 Feature-Level Impact on Sales
Analyze how product-related and order-related features correlate with sales.

### Features:
- Product category, brand, price
- Discount percentage
- Payment method
- Device
- Region
- Fees
- Campaign type

### Methods:
- Correlation (Pearson/Spearman)
- Chi-square test for categorical variables
- ANOVA for continuous variables
- Feature importance using:
  - Random Forest
  - XGBoost / LightGBM

---

# 3. Tracking Customer Activity on Our Platform

### 🎯 Goal  
Build a fully observable customer funnel that we cannot obtain from third-party platforms.

---

## 3.1 Required Events to Track
Track the following events with `user_id`, `session_id`, `timestamp`, `device`, `region`, `utm_source`:

- `page_view`
- `product_view`
- `add_to_cart`
- `begin_checkout`
- `payment_selected`
- `purchase`
- `search`
- `wishlist_add`
- `banner_click`
- `scroll_depth`

These events form the foundation of our Customer Data Platform (CDP).

---

## 3.2 Fields to Capture Each Event
- user_id (logged-in)
- anonymous_id (guest)
- session_id
- page URL
- product_id (if applicable)
- device type
- OS
- browser
- region
- UTM parameters
- timestamp

---

# 4. Feature Engineering & Correlation on Our Platform

### 🎯 Goal  
Determine which user, product, and behavioral features influence conversions.

---

## 4.1 Example Engineered Features
- Discount intensity
- Price rank within category
- Product views per session
- Time spent on product page
- Number of cart additions
- Number of searches before purchase
- Category preference score
- Session duration
- Referral source (organic/ads/social)
- Payment method preference

---

## 4.2 Analytical Methods

### Correlation Analysis
- Pearson correlation (numeric)
- Spearman correlation (ranked)
- Chi-square for categorical variables

### Feature Importance
Train simple predictive models:

- Random Forest Classifier  
- XGBoost / LightGBM  

Target: `purchase = 1 | 0`

Insight:
- Which features drive conversion?
- Which user behaviors indicate high intent?
- Which product attributes matter most?

