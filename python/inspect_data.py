import pandas as pd

file_path = "data/spotify_data.csv"

df = pd.read_csv(file_path, sep="\t")

print("\n===== DATASET SHAPE =====")
print("Rows:", df.shape[0])
print("Columns:", df.shape[1])

print("\n===== COLUMN NAMES =====")
print(df.columns.tolist())

print("\n===== FIRST 10 ROWS =====")
print(df.head(10).to_string())

print("\n===== DATA TYPES =====")
print(df.dtypes)

print("\n===== MISSING VALUES =====")
print(df.isnull().sum())

print("\n===== UNIQUE VALUES =====")
print("Unique tracks:", df["spotify_track_uri"].nunique())
print("Unique artists:", df["artist_name"].nunique())
print("Unique albums:", df["album_name"].nunique())

print("\n===== DUPLICATE ROWS =====")
print("Duplicates:", df.duplicated().sum())

print("\n===== PLATFORM VALUES =====")
print(df["platform"].value_counts())

print("\n===== SHUFFLE =====")
print(df["shuffle"].value_counts())

print("\n===== SKIPPED =====")
print(df["skipped"].value_counts())

print("\n===== LISTENING TIME =====")
print("Total minutes played:",
      df["ms_played"].sum() / 60000)

print("Average minutes per play:",
      df["ms_played"].mean() / 60000)

print("\n===== TIMESTAMP SAMPLE =====")
print(df["ts"].head(10).to_string(index=False))

print("\n===== TRACK PLAY COUNTS =====")
print(df["track_name"].value_counts().head(10))

print("\n===== ARTIST PLAY COUNTS =====")
print(df["artist_name"].value_counts().head(10))