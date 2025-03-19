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
gsutil cp data/universal_top_spotify_songs.csv gs://spotify_radu_bucket/raw_data/  
```  
3. After uploading, confirm that the file is in your bucket:  
```bash  
gsutil ls gs://spotify_radu_bucket/raw_data/  
```  
4. Expected output:  
```  
gs://spotify_radu_bucket/raw_data/universal_top_spotify_songs.csv  
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
  gs://spotify_radu_bucket/raw_data/universal_top_spotify_songs.csv
```
7. Verify Data in BigQuery
Run:
```bash
bq query --nouse_legacy_sql \
'SELECT * FROM `spotify-sandbox-453505.spotify_radu_dataset.spotify_top_songs` LIMIT 10'
```

### **🚀 Automating Data Ingestion with Kestra**  
Now that the data is successfully loaded into **BigQuery**, the next step is to **automate the data pipeline** so that new data is **extracted, uploaded, and ingested into BigQuery** automatically.  

We will use **Kestra**, a powerful workflow orchestration tool, to automate this process.

---

### **✅ Overview of the Automated Workflow**  
Using **Kestra**, we will create a **scheduled pipeline** that performs the following steps:

1️⃣ **Extract** data from Kaggle using the **Kaggle API**  
2️⃣ **Upload** the dataset to **Google Cloud Storage (GCS)**  
3️⃣ **Load** data from GCS into **BigQuery**  
4️⃣ **Schedule** the workflow to run automatically (e.g., daily)  

---

### **📌 Steps to Set Up Kestra for Automation**

### **1️⃣ Install & Run Kestra Locally**  
To run Kestra locally, you need **Docker**. If Docker is not installed, install it using:

- **For macOS (using Homebrew):**  
  ```bash  
  brew install --cask docker  
  ```  
- **For Ubuntu/Linux:**  
  ```bash  
  sudo apt update && sudo apt install docker.io -y  
  ```  

Once Docker is installed, start Kestra using:
```bash  
docker run --pull=always --rm -it -p 8080:8080 --user=root -v /var/run/docker.sock:/var/run/docker.sock -v /tmp:/tmp kestra/kestra:latest server local  
```
- Kestra will be available at **`http://localhost:8080/`**
- Open this URL in your browser.

---

### **2️⃣ Configure Kestra Web Interface**  
Once Kestra is running at **http://localhost:8080/**, follow these steps to set up credentials and create the ingestion flow:

#### **Step 1: Add Kaggle and GCP Credentials to KV Store**  
Kestra requires credentials to interact with Kaggle and Google Cloud. Add them securely to the **Kestra KV Store**:

1. Navigate to **http://localhost:8080/**
2. Go to **Settings → Secret Store**
3. Add the following entries:
   - **Key:** `KAGGLE_JSON` → Paste the content of your `kaggle.json` file.
   - **Key:** `GCP_SERVICE_ACCOUNT_BASE64` → Convert your GCP service account JSON file to Base64 and paste it:
     ```bash
     base64 keys/project.json
     ```
   - **Key:** `GCP_SERVICE_ACCOUNT` → Paste the full content of `project.json` (without encoding).

#### **Step 2: Create a New Flow in Kestra**  
1. In Kestra UI, go to **Flows → Create Flow**
2. Name it **spotify_ingestion**
3. Paste the following YAML code:
    ```yaml
    id: spotify_ingestion  
    namespace: spotify_pipeline
    description: "Automated pipeline: Download Spotify dataset from Kaggle, preprocess it, upload to GCS, and load into BigQuery."

    tasks:
    - id: download_spotify_dataset
        type: "io.kestra.plugin.scripts.shell.Commands"
        description: "Download the latest Spotify dataset from Kaggle."
        containerImage: "python:3.9"
        outputFiles:
        - "universal_top_spotify_songs.csv"
        env:
        KAGGLE_CONFIG_DIR: "/root/.kaggle"
        beforeCommands:
        - "pip install --no-cache-dir kaggle"
        commands:
        - "mkdir -p $KAGGLE_CONFIG_DIR"
        - "echo '{{ kv('KAGGLE_JSON') | toJson }}' > $KAGGLE_CONFIG_DIR/kaggle.json"
        - "chmod 600 $KAGGLE_CONFIG_DIR/kaggle.json"
        - "kaggle datasets download -d asaniczka/top-spotify-songs-in-73-countries-daily-updated -p ./ --force"
        - "unzip -o ./top-spotify-songs-in-73-countries-daily-updated.zip -d ./"
        - "ls -lh ./"
        - "[ -f ./universal_top_spotify_songs.csv ] && echo '✅ File exists!' || { echo '❌ ERROR: File not found!'; exit 1; }"

    - id: preprocess_csv
        type: "io.kestra.plugin.scripts.python.Commands"
        description: "Preprocess CSV to ensure empty values are recognized as NULL by BigQuery."
        containerImage: "python:3.9"
        outputFiles:
        - "cleaned_spotify_songs.csv.gz"
        beforeCommands:
        - "pip install pandas"
        commands:
        - |
            python - <<EOF
            import os
            import pandas as pd

            csv_file = "{{ outputs.download_spotify_dataset.outputFiles['universal_top_spotify_songs.csv'] }}"
            if not os.path.exists(csv_file):
                raise FileNotFoundError(f"❌ ERROR: {csv_file} not found!")
            
            print(f"✅ Found CSV file: {csv_file}")

            # Load CSV with proper encoding
            df = pd.read_csv(csv_file, encoding='utf-8')

            # Standardize empty values to NULL (handles spaces, tabs, and invisible characters)
            df = df.map(lambda x: None if isinstance(x, str) and x.strip() == "" else x)

            # Drop rows with missing required values
            required_columns = ["name", "spotify_id"]
            df.dropna(subset=required_columns, inplace=True)

            # Save as compressed CSV
            output_file = "cleaned_spotify_songs.csv.gz"
            df.to_csv(output_file, index=False, encoding='utf-8-sig', compression='gzip')

            print(f"✅ Processed CSV saved as: {output_file}")
            EOF

    - id: upload_to_gcs
        type: "io.kestra.plugin.scripts.shell.Commands"
        description: "Upload the cleaned dataset to Google Cloud Storage."
        containerImage: "google/cloud-sdk:latest"
        env:
        GOOGLE_APPLICATION_CREDENTIALS: "/tmp/gcp-key.json"
        commands:
        - "echo '{{ kv('GCP_SERVICE_ACCOUNT_BASE64') }}' | base64 -d > $GOOGLE_APPLICATION_CREDENTIALS"
        - "chmod 600 $GOOGLE_APPLICATION_CREDENTIALS"
        - "gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS"
        - "gcloud auth list"
        - "FILE_PATH={{ outputs.preprocess_csv.outputFiles['cleaned_spotify_songs.csv.gz'] }}"
        - "ls -lh $FILE_PATH || { echo '❌ ERROR: File not found!'; exit 1; }"
        - "gsutil -o 'GSUtil:parallel_composite_upload_threshold=100M' -h 'Content-Type:text/csv' -h 'Content-Encoding:gzip' cp $FILE_PATH gs://spotify_radu_bucket/raw_data/cleaned_spotify_songs.csv.gz"
        - "echo '✅ Upload complete!'"

    - id: load_to_bigquery
        type: io.kestra.plugin.gcp.bigquery.LoadFromGcs
        description: "Load the cleaned dataset into BigQuery."
        serviceAccount: "{{ kv('GCP_SERVICE_ACCOUNT') }}"
        projectId: "spotify-sandbox-453505"
        from:
        - "gs://spotify_radu_bucket/raw_data/cleaned_spotify_songs.csv.gz"
        destinationTable: "spotify-sandbox-453505.spotify_radu_dataset.spotify_top_songs"
        format: CSV
        csvOptions:
        skipLeadingRows: 1
        allowJaggedRows: true
        encoding: UTF-8
        fieldDelimiter: ","
        quote: '"'
        writeDisposition: WRITE_TRUNCATE
        schema:
        fields:
            - name: spotify_id
            type: STRING
            mode: REQUIRED
            - name: name
            type: STRING
            mode: REQUIRED
            - name: artists
            type: STRING
            mode: REQUIRED
            - name: daily_rank
            type: INT64
            mode: REQUIRED
            - name: daily_movement
            type: INT64
            mode: NULLABLE
            - name: weekly_movement
            type: INT64
            mode: NULLABLE
            - name: country
            type: STRING
            mode: NULLABLE
            - name: snapshot_date
            type: DATE
            mode: REQUIRED
            - name: popularity
            type: INT64
            mode: NULLABLE
            - name: is_explicit
            type: BOOL
            mode: NULLABLE
            - name: duration_ms
            type: INT64
            mode: NULLABLE
            - name: album_name
            type: STRING
            mode: NULLABLE
            - name: album_release_date
            type: DATE
            mode: NULLABLE
            - name: danceability
            type: FLOAT64
            mode: NULLABLE
            - name: energy
            type: FLOAT64
            mode: NULLABLE
            - name: key
            type: INT64
            mode: NULLABLE
            - name: loudness
            type: FLOAT64
            mode: NULLABLE
            - name: mode
            type: INT64
            mode: NULLABLE
            - name: speechiness
            type: FLOAT64
            mode: NULLABLE
            - name: acousticness
            type: FLOAT64
            mode: NULLABLE
            - name: instrumentalness
            type: FLOAT64
            mode: NULLABLE
            - name: liveness
            type: FLOAT64
            mode: NULLABLE
            - name: valence
            type: FLOAT64
            mode: NULLABLE
            - name: tempo
            type: FLOAT64
            mode: NULLABLE
            - name: time_signature
            type: INT64
            mode: NULLABLE
        autodetect: false

    triggers:
    - id: daily_schedule
        type: io.kestra.plugin.core.trigger.Schedule
        cron: "0 0 * * *"
    ```
4. Save and Deploy the flow.

---

### **3️⃣ Schedule the Workflow (Daily Execution)**
To run this flow automatically every day, update `spotify_ingestion.yaml` by adding:
```yaml
triggers:
  - id: daily_schedule
    type: io.kestra.core.models.triggers.types.Schedule
    cron: "0 0 * * *"  # Runs every day at 00:00 AM UTC
```
- Uses **Cron syntax** (`0 0 * * *` → Every day at **0:00 AM UTC**).

## 🚀 Automating Data Transformations with dbt
Now that the data is successfully loaded into **BigQuery**, the next step is to **clean, structure, and optimize it for analysis using dbt**.

We will use **dbt (Data Build Tool)** to transform raw Spotify data into a structured format for efficient querying and dashboard visualization.

## ✅ Overview of the dbt Workflow
Using **dbt**, we will:

1. **Set up dbt and configure it to work with BigQuery**  
2. **Create models to clean and transform raw Spotify data**  
3. **Schedule dbt to run automatically every day at 01:00 UTC**  

## 📌 Steps to Set Up dbt for Transformations

### 1️⃣ Install & Configure dbt
#### Step 1: Install dbt
 - **For macOS (Homebrew):**
  ```bash
  brew install dbt-bigquery
  ```
 - **For Ubuntu/Linux (via pip):**
  ```bash
  pip install dbt-bigquery
  ```

Verify installation:
```bash
dbt --version
```

### 2️⃣ Initialize dbt Project
Navigate to your project directory and create a new dbt project:
```bash
cd spotify_pipeline
dbt init spotify_dbt
```
 - This creates a `spotify_dbt/` folder inside the project.

### 3️⃣ Check dbt configuration for BigQuery
1. Check `~/.dbt/profiles.yml` (create it if it doesn’t exist):
   ```bash
   cat ~/.dbt/profiles.yml
   ```
2. Profiles configuration:
    ```yaml
    spotify_dbt:
      outputs:
        dev:
          dataset: spotify_radu_dataset
          job_execution_timeout_seconds: 300
          job_retries: 1
          keyfile: /Users/radu.stroe/Documents/spotify_pipeline/keys/project.json
          location: EU
          method: service-account
          priority: interactive
          project: spotify-sandbox-453505
          threads: 4
          type: bigquery
      target: dev
    ```

3. Test the connection:
Navigate to your dbt project:
    ```bash
    cd spotify_dbt
    ```
Verify dbt configuration:
   ```bash
   dbt debug
   ```
✅ If successful, dbt is now connected to BigQuery.

### 4️⃣ Create dbt Models for Transformations

Create a folder for **staging models**:
```bash
mkdir -p models/staging
```
Create a staging model:
```sql
WITH ranked_spotify AS (
    SELECT
        spotify_id,
        name,
        artists,
        COALESCE(country, 'GLOBAL') AS country,
        snapshot_date,
        daily_rank,
        daily_movement,
        weekly_movement,
        popularity,
        is_explicit,
        duration_ms,
        album_name,
        album_release_date,
        danceability,
        energy,
        key,
        loudness,
        mode,
        speechiness,
        acousticness,
        instrumentalness,
        liveness,
        valence,
        tempo,
        time_signature,
        ROW_NUMBER() OVER (
            PARTITION BY spotify_id, snapshot_date
            ORDER BY daily_rank ASC, country ASC
        ) AS rank_order
    FROM `spotify-sandbox-453505.spotify_radu_dataset.spotify_top_songs`
)

SELECT *
FROM ranked_spotify
WHERE rank_order = 1  
```
Create a schema for staging model and add tests: 
```yaml
version: 2

models:
  - name: stg_spotify
    description: "Staging model for Spotify song rankings, including country/global classification."
    columns:
      - name: stg_spotify
        description: "Staging table for Spotify daily rankings"
        tests:
          - unique:
              column_name: "(spotify_id, snapshot_date)"
          - not_null
      - name: name
        description: "Title of the song."
        tests:
          - not_null
      - name: artists
        description: "Artists performing the song."
        tests:
          - not_null
      - name: daily_rank
        description: "Song's rank on the given snapshot date."
        tests:
          - not_null
      - name: daily_movement
        description: "Change in rank compared to the previous day."
      - name: weekly_movement
        description: "Change in rank compared to the previous week."
      - name: country
        description: "Country of the ranking; 'Global' if null."
      - name: snapshot_date
        description: "Date of the ranking snapshot."
        tests:
          - not_null
      - name: popularity
        description: "Popularity score of the song."
      - name: is_explicit
        description: "Indicates whether the song contains explicit lyrics."
      - name: duration_ms
        description: "Duration of the song in milliseconds."
      - name: album_name
        description: "Name of the album the song belongs to."
      - name: album_release_date
        description: "Release date of the album."
      - name: danceability
        description: "A measure of how suitable the song is for dancing."
      - name: energy
        description: "A measure of the intensity of the song."
      - name: key
        description: "The key of the song."
      - name: loudness
        description: "The overall loudness of the song in decibels."
      - name: mode
        description: "Indicates whether the song is in a major or minor key."
      - name: speechiness
        description: "A measure of the presence of spoken words in the song."
      - name: acousticness
        description: "A measure of the acoustic quality of the song."
      - name: instrumentalness
        description: "A measure of the likelihood that the song does not contain vocals."
      - name: liveness
        description: "A measure of the presence of a live audience in the recording."
      - name: valence
        description: "A measure of the musical positiveness conveyed by the song."
      - name: tempo
        description: "The tempo of the song in beats per minute."
      - name: time_signature
        description: "The estimated overall time signature of the song."
```

Create a folder for **dim models**:
```bash
mkdir -p models/dim
```
Create a dim artists model:
```sql
{{ config(materialized='table') }}

WITH artists AS (
    SELECT DISTINCT
        artists,
        TO_HEX(MD5(artists)) AS artist_id
    FROM {{ ref('stg_spotify') }}
)

SELECT * FROM artists
```
Create a dim countries model:
```sql
{{ config(materialized='table') }}

WITH countries AS (
    SELECT DISTINCT
        COALESCE(country, 'Global') AS country_id
    FROM {{ ref('stg_spotify') }}
)

SELECT * FROM countries
```
Create a dim dates model:
```sql
{{ config(materialized='table') }}

WITH dates AS (
    SELECT DISTINCT
        snapshot_date AS date_id,
        EXTRACT(YEAR FROM snapshot_date) AS year,
        EXTRACT(MONTH FROM snapshot_date) AS month,
        EXTRACT(DAY FROM snapshot_date) AS day,
        FORMAT_DATE('%A', snapshot_date) AS day_of_week
    FROM {{ ref('stg_spotify') }}
)

SELECT * FROM dates
```
Create a dim songs model:
```sql
{{ config(materialized='table') }}

WITH ranked_songs AS (
    SELECT
        spotify_id,
        name AS song_name,
        album_name,
        album_release_date,
        danceability,
        energy,
        key,
        loudness,
        mode,
        speechiness,
        acousticness,
        instrumentalness,
        liveness,
        valence,
        tempo,
        time_signature,
        snapshot_date,
        ROW_NUMBER() OVER (PARTITION BY spotify_id ORDER BY snapshot_date DESC) AS row_num 
    FROM {{ ref('stg_spotify') }}
)

SELECT
    spotify_id,
    song_name,
    album_name,
    album_release_date,
    danceability,
    energy,
    key,
    loudness,
    mode,
    speechiness,
    acousticness,
    instrumentalness,
    liveness,
    valence,
    tempo,
    time_signature
FROM ranked_songs
WHERE row_num = 1  
```
Create a schema for dim models and add tests: 
```yaml
version: 2

models:
  - name: dim_songs
    description: "Contains unique songs with their metadata."
    columns:
      - name: spotify_id
        description: "Unique identifier for the song."
        tests:
          - unique
          - not_null
  - name: dim_artists
    description: "Contains unique artists with hashed IDs."
    columns:
      - name: artist_id
        description: "Hashed unique identifier for the artist."
        tests:
          - unique
          - not_null
  - name: dim_countries
    description: "Contains unique country names, with 'Global' as a fallback."
    columns:
      - name: country_id
        description: "Unique identifier for the country."
        tests:
          - unique
          - not_null
  - name: dim_dates
    description: "Contains date information for time-based queries."
    columns:
      - name: date_id
        description: "The date identifier."
        tests:
          - unique
          - not_null
```

Create a folder for **fact models**:
```bash
mkdir -p models/fact
```
Create a fact spotify rankings model:
```sql
{{ config(
    materialized='incremental',
    unique_key='spotify_id',
    partition_by={"field": "date_id", "data_type": "DATE"},
    cluster_by=["country_id"]
) }}

WITH rankings AS (
    SELECT
        s.spotify_id,
        a.artist_id,
        c.country_id,
        d.date_id,
        s.daily_rank,
        s.daily_movement,
        s.weekly_movement,
        s.popularity,
        s.is_explicit,
        s.duration_ms
    FROM {{ ref('stg_spotify') }} s
    LEFT JOIN {{ ref('dim_artists') }} a ON s.artists = a.artists
    LEFT JOIN {{ ref('dim_countries') }} c ON s.country = c.country_id
    LEFT JOIN {{ ref('dim_dates') }} d ON s.snapshot_date = d.date_id
    {% if is_incremental() %}
    WHERE s.snapshot_date > (SELECT MAX(date_id) FROM {{ this }})
    {% endif %}
)

SELECT * FROM rankings
```
Create a schema for fact models: 
```yaml
version: 2

models:
  - name: fact_spotify_rankings
    description: "Fact table containing daily Spotify rankings."
    columns:
      - name: spotify_id
        description: "Foreign key to dim_songs."
      - name: artist_id
        description: "Foreign key to dim_artists."
      - name: country_id
        description: "Foreign key to dim_countries."
      - name: date_id
        description: "Foreign key to dim_dates."
```

Run dbt to test it:
```bash
dbt run
```

### 5️⃣ Automate dbt Transformations
Now, let’s **schedule dbt to run transformations daily at 01:00 UTC**.

1. Create a new **Kestra flow** (`kestra/flows/spotify_transformation.yaml`) and add:

```yaml
id: spotify_transformation
namespace: spotify_pipeline
description: "Scheduled transformation for dims and fact tables"

triggers:
  - id: daily_schedule
    type: io.kestra.plugin.core.trigger.Schedule
    cron: "0 1 * * *"  

tasks:
  # Sync the latest DBT project from GitHub
  - id: sync_dbt_project
    type: io.kestra.plugin.git.SyncNamespaceFiles
    url: "https://github.com/Radu-Stroe/spotify_pipeline"
    branch: main
    namespace: "{{ flow.namespace }}"
    gitDirectory: "spotify_dbt"
    dryRun: false

  # Run DBT transformations
  - id: run_dbt_transformations
    type: io.kestra.plugin.dbt.cli.DbtCLI
    containerImage: google/cloud-sdk:latest  
    taskRunner:
      type: io.kestra.plugin.scripts.runner.docker.Docker
    namespaceFiles:
      enabled: true
    env:
      GOOGLE_APPLICATION_CREDENTIALS: "/tmp/gcp-key.json"
      GCP_PROJECT_ID: "spotify-sandbox-453505"  
    commands:
      # Install required dependencies
      - "apt-get update && apt-get install -y python3-venv python3-pip"

      # Create and activate a virtual environment
      - "python3 -m venv /tmp/dbt-venv"
      - "export PATH=/tmp/dbt-venv/bin:$PATH"  

      # Install DBT inside the virtual environment
      - "/tmp/dbt-venv/bin/pip install --upgrade pip"  
      - "/tmp/dbt-venv/bin/pip install --no-cache-dir dbt-core dbt-bigquery pandas"

      # Verify DBT installation
      - "/tmp/dbt-venv/bin/dbt --version || (echo 'DBT not installed!' && exit 1)" 

       # Authenticate with Google Cloud
      - "echo '{{ kv('GCP_SERVICE_ACCOUNT_BASE64') }}' | base64 -d > $GOOGLE_APPLICATION_CREDENTIALS"
      - "chmod 600 $GOOGLE_APPLICATION_CREDENTIALS"
      - "gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS"
      - "gcloud config set project $GCP_PROJECT_ID"
      - "gcloud auth list"

      # Debug Google Cloud Authentication
      - "gcloud config list --format=json"

      # Ensure DBT Recognizes profiles.yml
      - "echo '{{ kv('DBT_PROFILES_YML') }}' > /tmp/profiles.yml"
      - "export DBT_PROFILES_DIR='/tmp'"
      - "cat /tmp/profiles.yml"  # Debugging profiles.yml

      # Ensure BigQuery Keyfile Exists
      - "[ -f /tmp/gcp-key.json ] && echo 'Keyfile exists' || (echo 'Keyfile missing!' && exit 1)"

      # **Test BigQuery Connection Before Running DBT**
      - "bq --project_id=$GCP_PROJECT_ID query --use_legacy_sql=false 'SELECT 1'"

      # Run DBT Commands
      - "dbt deps"
      - "dbt debug"
      - "dbt run --select stg_spotify dim_songs dim_artists dim_dates dim_countries fact_spotify_rankings"

    storeManifest:
      key: manifest.json
      namespace: "{{ flow.namespace }}"
    profiles: |
      default:
        outputs:
          dev:
            type: bigquery
            method: service-account
            project: spotify-sandbox-453505 
            dataset: spotify_radu_dataset
            threads: 4
            keyfile: /tmp/gcp-key.json 
        target: dev
```

2. Deploy the flow:
   ```bash
   kestra flow deploy kestra/flows/dbt_transformations.yaml
   ```

## ✅ Summary
✅ Installed **dbt** and set up the **BigQuery connection**  
✅ Created **dbt models** to clean and transform data  
✅ Automated **dbt transformations to run daily at 01:00 UTC**

---

## **📌 Next Steps**  
- Implement **more advanced transformations** (e.g., clustering by genre or sentiment analysis).  
- Add **forecasting models** to predict future ranking trends.  
- Enhance **data enrichment** (e.g., incorporating social media trends or streaming statistics).

---

## **📜 License**  
This project is for educational purposes and follows Kaggle's data usage policies.