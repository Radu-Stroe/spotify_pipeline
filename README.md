# **🎵 Global vs. Local Music Popularity Analysis**  
 
## **📌 Project Overview**  
Music streaming platforms like **Spotify** provide rankings for the most popular songs in various countries. Some songs dominate the **global charts**, while others remain **regionally popular**. However, there is no straightforward way to compare a song’s **international success** with its **local popularity** over time.  
 
This project builds an **end-to-end data pipeline** to analyze and visualize how **song rankings differ between global and country-specific charts**.  
 
### **Key Insights Provided by This Project:**
✅ **Which songs are globally recognized vs. locally popular?**  
✅ **How do song rankings change over time across different regions?**  
✅ **What trends emerge in different countries' music preferences?**  
 
To achieve this, we implement a **batch data pipeline** that processes and visualizes data using modern cloud technologies.
 
---
 
## **🛠️ Technologies Used**  
 
### **📥 Data Extraction with Kaggle API**  
This project uses the **Kaggle API** to download the dataset directly from Kaggle. The API allows automated and reproducible data extraction without manual downloads.  
 
| **Component**              | **Technology**   | **Purpose** |
|----------------------------|-----------------|-------------|
| **Infrastructure as Code (IaC)** | Terraform | Provisioning cloud resources |
| **Workflow Orchestration** | Kestra | Automating batch data ingestion |
| **Data Storage (Datalake)** | Google Cloud Storage (GCS) | Storing raw Spotify data |
| **Data Warehouse** | BigQuery | Storing, partitioning, and querying transformed data |
| **Data Transformation** | dbt | Cleaning and preparing data for analysis |
| **Visualization & Dashboard** | Looker Studio | Creating interactive reports |
 
Each of these tools is chosen to ensure **scalability, automation, and reproducibility** in handling large datasets efficiently.
 
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
 
## **💻 Setup Instructions**

### **🛠 Setting Up Terraform**

#### **Pre-requisites:**
Before proceeding, ensure the following steps are completed:
- **Create a GCP project**: `spotify-sandbox`
- **Set up a service account** with the following roles:
  - Storage Admin
  - BigQuery Admin
  - Compute Admin
- **Download the JSON key file** and store it securely (e.g., in the `keys/` directory).

---

#### **1. Ensure Terraform is Installed**
- If Terraform is not installed, download it from [Terraform's official site](https://developer.hashicorp.com/terraform/downloads).
- Verify installation:
  ```bash
  terraform -v
     ```

2. **Navigate to the Terraform Directory**
   ```bash
   cd spotify_pipeline/terraform
   ```

3. **Create and Configure Terraform Files**
    - main.tf → Defines infrastructure resources (e.g., GCS bucket, BigQuery dataset).
    - variables.tf → Stores reusable values (e.g., project ID, bucket name, region).

4. **Initialize Terraform** (only needed for the first time):
   ```bash
   terraform init
   ```
    - This downloads the required Google provider and sets up the working directory.

5. **Validate and Preview Terraform Changes**:
   ```bash
   terraform plan
   ```
   - This checks for any errors and previews what Terraform will create.

6. **Apply Terraform to Create Resources**:
   ```bash
   terraform apply
   ```
   - Type **yes** when prompted to confirm resource creation.

7. **Verify the Created Resources**:
   - **Check the GCS bucket:**
     ```bash
     gcloud storage buckets list
     ```
   - **Check the BigQuery dataset:**
     ```bash
     bq ls
     ```


### **📥 Setting Up Kaggle API**  
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
   kaggle datasets download -d asaniczka/top-spotify-songs-in-73-countries-daily-updated -p data/
   ```  
4. Unzip the dataset:  
   ```bash
   unzip top-spotify-songs-in-73-countries-daily-updated.zip -d data/
   ```

### **Upload the Dataset to GCS**  
1. Before uploading, make sure you have set up Google Cloud authentication:  
```bash  
export GOOGLE_APPLICATION_CREDENTIALS="keys/project.json"  
```  
2. Now, upload the dataset to your Google Cloud Storage (GCS) bucket:  
```bash  
gsutil cp data/top-spotify-songs-in-73-countries-daily-updated.csv gs://spotify_radu_bucket/raw_data/  
```  
3. After uploading, confirm that the file is in your bucket:  
```bash  
gsutil ls gs://spotify_radu_bucket/raw_data/  
```  
4. Expected output:  
```  
gs://spotify_radu_bucket/raw_data/top-spotify-songs-in-73-countries-daily-updated.csv  
```  

### **📀 Loading Data into BigQuery**

1. Verify the File in GCS
Before loading the data, ensure that the file is correctly stored in your GCS bucket.
```
gsutil ls gs://spotify_radu_bucket/raw_data/
```
2. Define the BigQuery Table Schema in Terraform
Inside terraform/variables.tf, ensure the schema is properly stored as a variable:
```
variable "bigquery_table_id" {
  description = "Table ID for the BigQuery table"
  default     = "spotify_top_songs"
}

variable "bigquery_table_schema" {
  description = "Schema for the BigQuery table"
  default = <<EOF
[
  {"name": "spotify_id", "type": "STRING", "mode": "REQUIRED"},
  {"name": "name", "type": "STRING", "mode": "REQUIRED"},
  {"name": "artists", "type": "STRING", "mode": "REQUIRED"}, 
  {"name": "daily_rank", "type": "INTEGER", "mode": "REQUIRED"},
  {"name": "daily_movement", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "weekly_movement", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "country", "type": "STRING", "mode": "NULLABLE"},
  {"name": "snapshot_date", "type": "DATE", "mode": "REQUIRED"},
  {"name": "popularity", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "is_explicit", "type": "BOOLEAN", "mode": "NULLABLE"},
  {"name": "duration_ms", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "album_name", "type": "STRING", "mode": "NULLABLE"},
  {"name": "album_release_date", "type": "DATE", "mode": "NULLABLE"},
  {"name": "danceability", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "energy", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "key", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "loudness", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "mode", "type": "INTEGER", "mode": "NULLABLE"},
  {"name": "speechiness", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "acousticness", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "instrumentalness", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "liveness", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "valence", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "tempo", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "time_signature", "type": "INTEGER", "mode": "NULLABLE"}
]
EOF
}
```
3. Define BigQuery Table in Terraform
Inside terraform/main.tf, ensure the table creation is defined using the variables:
```
resource "google_bigquery_table" "spotify_songs" {
  dataset_id = google_bigquery_dataset.spotify_radu_dataset.dataset_id
  table_id   = var.bigquery_table_id
  project    = var.project_id
  schema     = var.bigquery_table_schema
}
```
4. Apply Terraform Changes
After adding the table definition, run Terraform to create the table in BigQuery:
```bash
cd terraform
terraform init  # If not already initialized
terraform plan
terraform apply
```
5. Verify That the Table Was Created
Run:
```bash
bq ls spotify_radu_dataset
```
6. Load Data from GCS into BigQuery
Now that we have the table created, we can load the data from GCS:
```bash
bq load \
  --source_format=CSV \
  --skip_leading_rows=1 \
  spotify-sandbox-453505:spotify_radu_dataset.spotify_top_songs \
  gs://spotify_radu_bucket/raw_data/top-spotify-songs-in-73-countries-daily-updated.csv
```
7. Verify Data in BigQuery
Run:
```bash
bq query --nouse_legacy_sql \
'SELECT * FROM `spotify-sandbox-453505.spotify_radu_dataset.spotify_top_songs` LIMIT 10'
```

---
 
## **📌 Next Steps**  
- Implement **more advanced transformations** (e.g., clustering by genre or sentiment analysis).  
- Add **forecasting models** to predict future ranking trends.  
- Enhance **data enrichment** (e.g., incorporating social media trends or streaming statistics).
 
---
 
## **📜 License**  
This project is for educational purposes and follows Kaggle's data usage policies.