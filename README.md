# Bicycle Count Forecasting and Real-Time Monitoring in Paris

## Overview

This project focuses on forecasting bicycle traffic in Paris for 2024 using historical data and comparing the predictions with real-time data. It demonstrates the process of analyzing historical data, generating forecasts, and visualizing both forecasted and real-time data. Additionally, it sets up an automated pipeline to update and visualize real-time data continuously, providing valuable insights for urban planning and promoting sustainable transportation.

## Objectives

- **Forecast bicycle traffic**: Predict bicycle counts in Paris for the year 2024 using historical data.
- **Real-time monitoring**: Compare forecasts with real-time bicycle count data.
- **Visualization**: Create visualizations for both forecasted and real-time data.
- **Automation**: Develop an automated pipeline for continuous data updates and visualizations.

## Datasets

### Historical Data
**Comptage vélo - Historique - Données Compteurs et Sites de comptage**
- **Source**: [Paris Open Data](https://parisdata.opendatasoft.com/explore/dataset/comptage-velo-historique-donnees-compteurs/information/)
- **Description**: Hourly bicycle counts and locations of counting sites collected by permanent bicycle counters deployed over several years.

### Real-Time Data
**REAL-TIME BIKE COUNTING - COUNTER DATA (PARIS)**
- **Source**: [Paris Open Data](https://parisdata.opendatasoft.com/explore/dataset/comptage-velo-donnees-compteurs/information/)
- **Description**: Hourly bicycle counts by counter and locations of counting sites, updated daily over a rolling 13-month period.

## Project Structure (draft!!!)

├── data \
│ ├── historical_data.csv # Historical bicycle count data \
│ ├── real_time_data.csv # Real-time bicycle count data \
├── scripts \
│ ├── data_preprocessing.R # Script for data cleaning and preprocessing \
│ ├── forecasting_model.R # Script for building and evaluating the forecast model \
│ ├── real_time_monitoring.R # Script for fetching and processing real-time data \
│ ├── visualization.R # Script for generating visualizations \
│ ├── pipeline.R # Script to set up the automated pipeline \
└── README.md
