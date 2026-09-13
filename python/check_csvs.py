import pandas as pd
import os

files = [
    "artists.csv",
    "single.csv",
    "artist_group.csv",
    "albums.csv",
    "songs.csv",
    "genres.csv",
    "song_genre.csv",
    "users.csv",
    "premium_user.csv",
    "free_user.csv",
    "subscriptions.csv",
    "payments.csv",
    "playlists.csv",
    "playlist_song.csv",
    "ratings.csv",
    "listening_history.csv"
]

print("=" * 70)
print("CSV STRUCTURE CHECK")
print("=" * 70)

total_rows = 0

for filename in files:

    path = os.path.join("data", filename)

    if not os.path.exists(path):
        print(f"\n❌ MISSING: {filename}")
        continue

    df = pd.read_csv(path)

    print(f"\n--- {filename} ---")
    print(f"Rows: {len(df)}")
    print(f"Columns: {list(df.columns)}")

    total_rows += len(df)

print("\n" + "=" * 70)
print(f"TOTAL CSV DATA ROWS: {total_rows}")
print("=" * 70)