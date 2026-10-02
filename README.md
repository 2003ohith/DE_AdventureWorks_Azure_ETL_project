# AdventureWorks Data Engineering Project

## Overview

This project implements an Azure-based Medallion Architecture for processing and transforming AdventureWorks data into analytics-ready datasets.

The project uses GitHub Raw HTTPS as the source, Azure Data Factory for ingestion, Azure Data Lake Storage Gen2 for data storage, Azure Databricks and PySpark for data transformation, Delta Lake for reliable table storage, Unity Catalog for governance, Azure Synapse Analytics for serving, and Power BI for reporting.

### Technology Stack

- GitHub Raw HTTPS
- Azure Data Factory (ADF)
- Azure Data Lake Storage Gen2 (ADLS Gen2)
- Azure Databricks
- PySpark
- Delta Lake
- Unity Catalog
- Azure Synapse Analytics
- Power BI
- Bronze, Silver, and Gold layers

---

## Architecture Flow

```text
GitHub Repository
AdventureWorks CSV Files
          |
          | Raw HTTPS
          v
   Azure Data Factory
   Ingestion / Orchestration
          |
          v
      ADLS Gen2
  stgactadventureworks
          |
          v
       Bronze
     Raw Data
          |
          v
   Azure Databricks
   PySpark + Delta Lake
          |
     +----+----+
     |         |
     v         v
  Silver     Gold
  Cleaned    Business
   Data       Ready
     |         |
     +----+----+
          |
          v
    Unity Catalog
    Adventureworks
          |
     +----+----+
     |         |
     v         v
  Silver      Gold
  Schema     Schema
     |         |
     +----+----+
          |
          v
 Azure Synapse Analytics
    SQL / Serving Layer
          |
          v
       Power BI
 Reports / Dashboards
 ```
# 1. Source Systems

The project uses the AdventureWorks dataset stored in a GitHub repository.

The CSV files are accessed using the GitHub Raw HTTPS URL.

**Source**
```text
GitHub Repository
        |
        └── AdventureWorks CSV Files
```
**The source contains datasets related to:**

- Customers
- Products
- Product Categories
- Product Subcategories
- Calendar
- Sales / Orders
- Territories
- Other AdventureWorks datasets

The source data is ingested into ADLS Gen2 using Azure Data Factory.

# 2. Azure Data Factory

Azure Data Factory (ADF) is used for data ingestion and pipeline orchestration.

**Responsibilities**

- Connect to GitHub Raw HTTPS
- Read AdventureWorks CSV files
- Copy source data into ADLS Gen2
- Orchestrate ingestion pipelines
- Automate data movement
- Separate ingestion from transformation

**Flow**
```
GitHub Raw HTTPS
        |
        v
Azure Data Factory
        |
        v
    ADLS Gen2
```

# 3. Azure Data Lake Storage Gen2

The project uses the following ADLS Gen2 storage account:
```
stgactadventureworks
```
The storage account is organized into separate data zones.

**ADLS Structure**
```
ADLS Gen2
stgactadventureworks
│
├── bronze
│     └── AdventureWorks CSV
│
├── silver
│     └── processed Delta
│
├── gold
│     └── final Delta
│
└── UC_data
      └── Unity Catalog managed tables
```
**Bronze**

The Bronze container contains the raw AdventureWorks data ingested from GitHub.
```
bronze
└── AdventureWorks CSV files
```
**Silver**

The Silver container is used for processed Delta data where applicable.
```
silver
└── processed Delta
```
**Gold**

The Gold container is used for final Delta datasets where applicable.
```
gold
└── final Delta
```
**UC_data**

The UC_data location is used as the storage location for Unity Catalog managed tables.
```
UC_data
└── Unity Catalog managed tables
```

# 4. Azure Databricks

Azure Databricks is used as the main data processing and transformation platform.

**The project uses:**

- PySpark
- Delta Lake
- Spark SQL
- DataFrame transformations
- Unity Catalog

**The data is processed through the Medallion Architecture:**
```
Bronze
   |
   v
Silver
   |
   v
Gold
```
**Main transformation activities**

- Data cleansing
- Null handling
- Duplicate handling
- Data type conversion
- Column standardization
- Date transformations
- String transformations
- Joins
- Aggregations
- Business transformations
- Schema validation
- Delta table creation

# 5. Bronze Layer

The Bronze layer contains the raw AdventureWorks data.

The data ingested by Azure Data Factory into ADLS Gen2 is used as the source for Bronze processing.

**Responsibilities**

- Preserve source data
- Store raw data
- Convert raw data into Delta where required
- Preserve source-level information
- Add ingestion metadata
- Perform minimal transformations

**Typical Metadata**
```
_source_file
_ingested_at
```
**Flow**
```
GitHub Raw HTTPS
        |
        v
Azure Data Factory
        |
        v
ADLS Gen2 Bronze
        |
        v
Bronze Delta
```
The Bronze layer provides the foundation for downstream transformations.

# 6. Silver Layer

The Silver layer contains cleaned, standardized, and trusted AdventureWorks data.

The Silver datasets are created using PySpark transformations.

**Responsibilities**

- Clean invalid data
- Handle null values
- Handle duplicate records
- Standardize data types
- Standardize column formats
- Validate data
- Maintain schema consistency
- Handle schema changes
- Perform joins
- Refine Bronze datasets
- Create trusted datasets

**Flow**
```
Bronze
   |
   +-- Data Cleaning
   |
   +-- Data Validation
   |
   +-- Type Conversion
   |
   +-- Standardization
   |
   +-- Deduplication
   |
   +-- Transformation
   |
   v
Silver
```
**Example Silver tables:**
```
slv_customers
slv_products
slv_calendar
...
```

# 7. Gold Layer

The Gold layer contains business-ready and analytics-ready AdventureWorks datasets.

The Gold layer is created using trusted Silver datasets.

**Responsibilities**

- Join Silver datasets
- Apply business logic
- Create analytical datasets
- Create dimensions
- Create fact datasets
- Add derived attributes
- Add business attributes
- Create reporting-ready datasets

**Example Gold Tables**
```
gld_customers
gld_products
gld_calendar
gld_categories
gld_brands
gld_sales
...
```
**Example Analytical Model**
```
                    Dim Customer
                         |
                         |
Dim Product ---- Fact Sales / Orders ---- Dim Category
                         |
                         |
                     Dim Brand
```
The Gold layer is designed for downstream analytical and reporting workloads.

# 8. Unity Catalog

Unity Catalog is used for data governance, organization, access control, and metadata management.

The project uses the following Unity Catalog:
```
Adventureworks
```
The catalog contains separate Silver and Gold schemas.

**Unity Catalog Structure**
```
Unity Catalog
│
└── Adventureworks
      │
      ├── silver
      │     │
      │     ├── slv_customers
      │     ├── slv_products
      │     ├── slv_calendar
      │     └── ...
      │
      └── gold
            │
            ├── gld_customers
            ├── gld_products
            ├── gld_calendar
            └── ...
```
The architecture does not require separate Unity Catalog schemas for the ADLS Bronze, Silver, and Gold containers.

**Instead:**
```
ADLS
│
├── bronze
│     └── Raw AdventureWorks data
│
├── silver
│     └── Processed data
│
├── gold
│     └── Final data
│
└── UC_data
      └── Unity Catalog managed tables
```
Unity Catalog manages the logical Silver and Gold tables.

# 9. Unity Catalog Managed Tables

The Silver and Gold analytical tables are managed using Unity Catalog.

**Silver**
```
Adventureworks.silver.slv_customers
Adventureworks.silver.slv_products
Adventureworks.silver.slv_calendar
```
**Gold**
```
Adventureworks.gold.gld_customers
Adventureworks.gold.gld_products
Adventureworks.gold.gld_calendar
```
The physical storage for Unity Catalog managed tables is maintained under:
```
ADLS Gen2
└── UC_data
```
This separates the logical table organization from the physical storage location.

# 10. Unity Catalog Access Architecture

The project uses Azure-based access configuration to allow Databricks and Unity Catalog to access ADLS Gen2.

**The access architecture is:**
```
Azure Access Connector
        |
        v
External Credential
        |
        v
External Location
        |
        v
ADLS Gen2
```
**Unity Catalog provides centralized management for:**

- Catalogs
- Schemas
- Tables
- External Locations
- External Credentials
- Permissions
- Access Control
- Managed Tables

# 11. Delta Lake

Delta Lake is used as the primary table format for processed data.

**Delta Lake provides:**

- ACID transactions
- Schema enforcement
- Schema evolution when configured
- Reliable reads and writes
- Transaction history
- Data versioning
- Reliable data pipelines

**Flow**
```
Raw CSV
   |
   v
Bronze Delta
   |
   v
Silver Delta
   |
   v
Gold Delta
```

# 12. Azure Synapse Analytics

Azure Synapse Analytics is used as the serving and SQL analytics layer.

The Gold data can be made available for analytical querying and downstream consumers.

**Flow**
```
Gold Data
    |
    v
Azure Synapse Analytics
    |
    v
SQL Analytics
```
Synapse provides a SQL-oriented serving layer between the processed data and reporting consumers.

# 13. Power BI

Power BI is used as the reporting and visualization layer.

The final analytical datasets can be used to create:

- Dashboards
- Reports
- KPIs
- Sales analysis
- Customer analysis
- Product analysis
- Business insights

**Flow**
```
Gold / Serving Layer
        |
        v
Azure Synapse Analytics
        |
        v
Power BI
        |
        v
Reports / Dashboards
```

# 14. End-to-End Data Flow

**The complete data flow is:**
```
GitHub Repository
        |
        v
GitHub Raw HTTPS
        |
        v
Azure Data Factory
        |
        v
ADLS Gen2
stgactadventureworks
        |
        v
Bronze
Raw AdventureWorks Data
        |
        v
Azure Databricks
PySpark + Delta Lake
        |
        v
Silver
Cleaned & Standardized Data
        |
        v
Gold
Business & Analytics Ready Data
        |
        v
Unity Catalog
Adventureworks
        |
        +-------------------+
        |                   |
        v                   v
     silver               gold
        |                   |
        +---------+---------+
                  |
                  v
       Azure Synapse Analytics
                  |
                  v
               Power BI
```

# 15. Data Layer Responsibilities

| Layer     | Technology / Location              | Purpose             | Main Operations                           |
| --------- | ---------------------------------- | ------------------- | ----------------------------------------- |
| Source    | GitHub Raw HTTPS                   | Source data         | AdventureWorks CSV                        |
| Ingestion | Azure Data Factory                 | Data movement       | Copy and orchestration                    |
| Bronze    | ADLS Gen2                          | Raw data            | Landing, metadata, minimal transformation |
| Silver    | Databricks + Delta + Unity Catalog | Trusted data        | Cleaning, validation, standardization     |
| Gold      | Databricks + Delta + Unity Catalog | Business-ready data | Joins, business logic, dimensions, facts  |
| Serving   | Azure Synapse Analytics            | SQL analytics       | Query and serving                         |
| BI        | Power BI                           | Reporting           | Dashboards and visualization              |

# 16. Technology Stack

| Technology              | Role                             |
| ----------------------- | -------------------------------- |
| Azure                   | Cloud Platform                   |
| GitHub                  | Source Repository                |
| GitHub Raw HTTPS        | Source File Access               |
| Azure Data Factory      | Data Ingestion and Orchestration |
| ADLS Gen2               | Data Lake Storage                |
| Azure Databricks        | Data Processing                  |
| PySpark                 | Distributed Data Processing      |
| Delta Lake              | Reliable Table Storage           |
| Unity Catalog           | Governance and Access Control    |
| Azure Synapse Analytics | SQL Analytics / Serving          |
| Power BI                | Reporting and Visualization      |

# 17. Key Design Principles
Separation of Data Layers

Raw, cleansed, and analytical data are separated into different layers.
```
Bronze → Raw
Silver → Cleaned & Trusted
Gold   → Business Ready
```
**Data Quality**

Data is progressively cleaned, validated, standardized, and refined before reaching the Gold layer.

**Reusability**

Silver datasets can be reused by multiple Gold analytical models.

**Governance**

Unity Catalog provides centralized organization, access control, and governance for the analytical tables.

**Reliable Storage**

Delta Lake provides reliable storage and transactional capabilities for processed datasets.

**Analytics Readiness**

Gold datasets are designed for SQL analytics and BI consumption.

# 18. Getting Started
**Prerequisites**
- Azure subscription
- Azure Data Factory
- Azure Data Lake Storage Gen2
- Azure Databricks workspace
- Unity Catalog enabled
- Azure Access Connector
- Appropriate ADLS permissions
- Azure Synapse Analytics
- Power BI

# 19. Final Architecture
```
                    GitHub Repository
                  AdventureWorks CSV
                          |
                       Raw HTTPS
                          |
                          v
              +-----------------------+
              |   Azure Data Factory  |
              | Ingestion / Orchestration |
              +-----------+-----------+
                          |
                          v
        +--------------------------------------+
        |              ADLS Gen2               |
        |       stgactadventureworks           |
        |                                      |
        |  +--------+ +--------+ +--------+   |
        |  | Bronze | | Silver | |  Gold  |   |
        |  | Raw    | | Delta  | | Delta  |   |
        |  +--------+ +--------+ +--------+   |
        |                                      |
        |             +---------+              |
        |             | UC_data |              |
        |             +---------+              |
        +------------------+-------------------+
                           |
                           v
              +-------------------------+
              |    Azure Databricks     |
              | PySpark + Delta Lake    |
              |                         |
              | Bronze → Silver → Gold  |
              +------------+------------+
                           |
                           v
              +-------------------------+
              |     Unity Catalog       |
              |     Adventureworks      |
              |                         |
              |  silver      gold       |
              |  slv_*       gld_*      |
              |                         |
              | Managed Delta Tables    |
              +------------+------------+
                           |
                           v
              +-------------------------+
              | Azure Synapse Analytics |
              |   SQL / Serving Layer   |
              +------------+------------+
                           |
                           v
              +-------------------------+
              |        Power BI         |
              | Reports / Dashboards    |
              +-------------------------+
```

# **Medallion Architecture Diagram:**

  <img src="AdventureWorks_architecture%20diagram.png" alt="AdventureWorks Architecture" width="900">
