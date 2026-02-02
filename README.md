# GREEN-IT-DATA-PLATFORM

## Overview
Green IT – Oracle & Data Engineering Platform is an end-to-end data platform focusing on Energy, CO₂, Performance, Cost, and Security.

## Architecture
The platform follows a comprehensive data flow:
**Oracle → Databricks → Power BI**

### Components

#### X001_Oracle
Oracle Database layer with:
- Schema design
- Indexing
- RMAN backup
- Security & roles

#### X002_Databricks
Medallion architecture implementation:
- **Bronze**: Raw data ingestion
- **Silver**: Cleaned and transformed data
- **Gold**: Business-level aggregated data

#### X003_Powerbi
Power BI dashboards based on Gold layer for data visualization and insights.

#### X004_Logo
Project branding and visual identity resources.

**Team View Design Logo**: [View and edit in Canva](https://www.canva.com/design/DAHAKBiRNFE/EzB1Mq9jjYpA335IjrYH0Q/edit?utm_content=DAHAKBiRNFE&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)

## Documentation
For more detailed architecture information, see [docs/architecture.md](docs/architecture.md).

## Project Focus
- ⚡ **Energy Efficiency**: Optimizing data processing for lower energy consumption
- 🌍 **CO₂ Reduction**: Minimizing carbon footprint through efficient data operations
- 🚀 **Performance**: High-performance data processing and analytics
- 💰 **Cost Optimization**: Efficient resource utilization
- 🔒 **Security**: Enterprise-grade security and compliance