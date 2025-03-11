# **🎵 Global vs. Local Music Popularity Analysis**  

## **📌 Project Overview**  
Music streaming platforms like **Spotify** provide rankings for the most popular songs in various countries. Some songs dominate the **global charts**, while others remain **regionally popular**. However, there is no straightforward way to compare a song’s **international success** with its **local popularity** over time.  

This project builds an **end-to-end data pipeline** to analyze and visualize how **song rankings differ between global and country-specific charts**.  

### **Key Insights Provided by This Project:**
✅ **Which songs are globally recognized vs. locally popular?**  
✅ **How do song rankings change over time across different regions?**  
✅ **What trends emerge in different countries' music preferences?**  

To achieve this, we implement a **batch data pipeline** that processes and visualizes data using modern cloud technologies.

## **📊 Data Pipeline Overview**  
The image below represents the end-to-end data pipeline implemented in this project:

![Data Pipeline](pipeline_diagram.png)

- **Kaggle API**: Extracts the dataset from Kaggle.
- **Google Cloud Storage (GCS)**: Stores raw data for processing.
- **Kestra Workflow**: Automates the batch pipeline.
- **BigQuery**: Acts as the data warehouse for analysis.
- **dbt**: Transforms and cleans the data for insights.
- **Looker Studio**: Visualizes the final processed data in an interactive dashboard.

---

## **🛠️ Technologies Used**  

| **Component**              | **Technology**   | **Purpose** |
|----------------------------|-----------------|-------------|
| **Infrastructure as Code (IaC)** | Terraform | Provisioning cloud resources |
| **Workflow Orchestration** | Kestra | Automating batch data ingestion |
| **Data Storage (Datalake)** | Google Cloud Storage (GCS) | Storing raw Spotify data |
| **Data Warehouse** | BigQuery | Storing, partitioning, and querying transformed data |
| **Data Transformation** | dbt | Cleaning and preparing data for analysis |
| **Visualization & Dashboard** | Looker Studio | Creating interactive reports |

Each of these tools is chosen to ensure **scalability, automation, and reproducibility** in handling large datasets efficiently.

## **📥 Data Extraction with Kaggle API**  
This project uses the **Kaggle API** to download the dataset directly from Kaggle. The API allows automated and reproducible data extraction without manual downloads.  

### **🔧 Setup Kaggle API**  
1. Install the Kaggle API package if you haven't already:  
   ```bash
   pip install kaggle
   ```
2. Authenticate by placing your Kaggle API key (`kaggle.json`) in the correct directory:  
   ```bash
   mkdir -p ~/.kaggle
   mv kaggle.json ~/.kaggle/
   chmod 600 ~/.kaggle/kaggle.json
   ```
3. Download the dataset using the Kaggle API:  
   ```bash
   kaggle datasets download -d asaniczka/top-spotify-songs-in-73-countries-daily-updated
   ```
4. Unzip the dataset:  
   ```bash
   unzip top-spotify-songs-in-73-countries-daily-updated.zip -d data/
   ```

---

## **📂 Dataset: Spotify Top 50 Songs in 73 Countries**  

The dataset used in this project is publicly available on Kaggle:  
🔗 [Top Spotify Songs in 73 Countries (Daily Updated)](https://www.kaggle.com/datasets/asaniczka/top-spotify-songs-in-73-countries-daily-updated/)  

### **Dataset Description**  
This dataset contains **daily updated rankings of the top 50 Spotify songs** across 73 countries, including **global rankings**. Key attributes include:

| **Column**          | **Description** |
|--------------------|------------------------------|
| `spotify_id` | Unique identifier for the song |
| `name` | Song title |
| `artists` | Artist(s) associated with the song |
| `daily_rank` | The song's position in the top 50 for a specific day |
| `daily_movement` | Rank change compared to the previous day |
| `weekly_movement` | Rank change compared to the previous week |
| `country` | Country of the ranking (or "Global" for worldwide charts) |
| `snapshot_date` | The date of the ranking |
| `popularity` | A numerical measure of song popularity |
| `is_explicit` | Indicates whether the song has explicit lyrics |
| `duration_ms` | Length of the song in milliseconds |
| `danceability`, `energy`, `valence`, `tempo`, etc. | Audio features describing the song’s characteristics |

This dataset allows us to compare **global vs. local song rankings** over time and analyze trends in different regions.

---

## **📊 Dashboard Overview**  

The final dashboard (built in **Looker Studio**) contains **two key visualizations**:

1️⃣ **Categorical Graph:** **Distribution of Songs in Global vs. Local Charts**  
   - Compares the number of songs that appear in both **global** and **country-specific** Top 50 lists.  
   - Helps identify how many songs are **international hits** vs. **regionally popular**.  

2️⃣ **Time-Series Graph:** **Trend of a Song’s Rank in Global vs. Local Charts**  
   - Tracks how a song’s position changes over time in both **global rankings** and **a specific country**.  
   - Shows whether songs **gain international traction** or remain local favorites.  

---

## **🚀 Getting Started**  
This section will guide users on how to set up and run the project.

### **🔧 Prerequisites**
Ensure you have the following installed:
- **Google Cloud SDK**
- **Terraform**
- **Kestra**
- **dbt**
- **Looker Studio (Google Account required)**

### **💻 Setup Instructions**
1️⃣ **Clone the repository**  
```bash
git clone <repository-url>
cd <project-folder>
```

2️⃣ **Provision Cloud Resources with Terraform**  
```bash
terraform init
terraform apply
```

3️⃣ **Run the Kestra Workflow for Data Ingestion**  
```bash
kestra deployment apply
kestra flow run spotify_ingestion
```

4️⃣ **Transform Data with dbt**  
```bash
dbt run
```

5️⃣ **Access the Dashboard in Looker Studio**  
- Open the Looker Studio link: `<dashboard-url>`

---

## **📌 Next Steps**  
- Implement **more advanced transformations** (e.g., clustering by genre or sentiment analysis).  
- Add **forecasting models** to predict future ranking trends.  
- Enhance **data enrichment** (e.g., incorporating social media trends or streaming statistics).

---

## **📜 License**  
This project is for educational purposes and follows Kaggle's data usage policies.