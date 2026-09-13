import pandas as pd

# -------------------------------------------------
# 1. Load the original dataset
# -------------------------------------------------

input_file = "data/spotify_data.csv"
output_file = "data/spotify_cleaned.csv"

df = pd.read_csv(input_file, sep="\t")

print("Original rows:", len(df))

# -------------------------------------------------
# 2. Remove exact duplicate records
# -------------------------------------------------

duplicates = df.duplicated().sum()

df = df.drop_duplicates()

print("Duplicate rows removed:", duplicates)

# -------------------------------------------------
# 3. Handle missing values
# -------------------------------------------------

df["reason_start"] = df["reason_start"].fillna("unknown")
df["reason_end"] = df["reason_end"].fillna("unknown")

# -------------------------------------------------
# 4. Clean text fields
# -------------------------------------------------

text_columns = [
    "spotify_track_uri",
    "track_name",
    "artist_name",
    "album_name",
    "platform",
    "reason_start",
    "reason_end"
]

for column in text_columns:
    df[column] = df[column].astype(str).str.strip()

# -------------------------------------------------
# 5. Validate listening duration
# -------------------------------------------------

invalid_duration = (df["ms_played"] < 0).sum()

print("Invalid listening durations:", invalid_duration)

# Remove impossible negative durations
df = df[df["ms_played"] >= 0]

# -------------------------------------------------
# 6. Convert timestamp
# -------------------------------------------------

df["played_at"] = pd.to_datetime(
    df["ts"],
    format="%d-%m-%Y %H.%M",
    errors="coerce"
)

invalid_dates = df["played_at"].isna().sum()

print("Invalid timestamps:", invalid_dates)

# -------------------------------------------------
# 7. Remove records with invalid timestamps
# -------------------------------------------------

df = df.dropna(subset=["played_at"])

# -------------------------------------------------
# 8. Save cleaned dataset
# -------------------------------------------------

df.to_csv(output_file, index=False)

# -------------------------------------------------
# 9. Final report
# -------------------------------------------------

print("\n===== CLEANING COMPLETE =====")
print("Final rows:", len(df))
print("Final columns:", len(df.columns))
print("Saved to:", output_file)

print("\n===== FINAL MISSING VALUES =====")
print(df.isnull().sum())

print("\n===== FINAL DATA TYPES =====")
print(df.dtypes)

print("\n===== SAMPLE CLEANED DATA =====")
print(df.head(5).to_string())