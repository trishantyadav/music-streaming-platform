import pandas as pd
import random
from faker import Faker

fake = Faker()

random.seed(42)
Faker.seed(42)

# ============================================================
# LOAD EXISTING DATA
# ============================================================

artists = pd.read_csv("data/artists.csv")
albums = pd.read_csv("data/albums.csv")
songs = pd.read_csv("data/songs.csv")
history = pd.read_csv(
    "data/listening_history.csv",
    parse_dates=["Played_at"]
)

print("Artists loaded:", len(artists))
print("Albums loaded:", len(albums))
print("Songs loaded:", len(songs))
print("Listening records loaded:", len(history))

# ============================================================
# 1. ENRICH ARTIST
# ============================================================

countries = [
    "India",
    "United States",
    "United Kingdom",
    "Canada",
    "Australia",
    "Germany",
    "France",
    "Spain",
    "Italy",
    "Brazil",
    "Japan",
    "South Korea",
    "Sweden",
    "Ireland",
    "Netherlands"
]

award_names = [
    "Grammy Award",
    "Billboard Music Award",
    "MTV Music Award",
    "American Music Award",
    "Brit Award",
    "Juno Award",
    "None"
]

artists["Country"] = [
    random.choice(countries)
    for _ in range(len(artists))
]

artists["Bio"] = [
    fake.sentence(nb_words=12)
    for _ in range(len(artists))
]

artists["Awards"] = [
    random.choice(award_names)
    for _ in range(len(artists))
]

# ============================================================
# 2. ENRICH ALBUM
# ============================================================

# Find the earliest listening date associated with each song.
song_first_play = (
    history.groupby("Song_id")["Played_at"]
    .min()
)

# Map each song to its album.
song_album = songs[
    ["Song_id", "Album_id"]
]

song_dates = song_album.copy()

song_dates["First_play"] = song_dates["Song_id"].map(
    song_first_play
)

# Earliest play date for each album.
album_first_play = (
    song_dates
    .groupby("Album_id")["First_play"]
    .min()
)

release_dates = []

for album_id in albums["Album_id"]:

    first_play = album_first_play.get(album_id)

    # If there is no listening date available,
    # use a safe default date.
    if pd.isna(first_play):
        first_play = pd.Timestamp("2013-01-01")

    days_before = random.randint(30, 3650)

    release_date = first_play - pd.Timedelta(
        days=days_before
    )

    release_dates.append(
        release_date.strftime("%Y-%m-%d")
    )
albums["Release_date"] = release_dates

# Placeholder URLs rather than fake real websites.
albums["Cover_art_url"] = [
    f"https://example.com/covers/{album_id}.jpg"
    for album_id in albums["Album_id"]
]

# ============================================================
# 3. CREATE GENRE TABLE
# ============================================================

genres_list = [
    "Pop",
    "Rock",
    "Hip-Hop",
    "R&B",
    "Electronic",
    "Jazz",
    "Classical",
    "Country",
    "Indie",
    "Metal",
    "Alternative",
    "Folk",
    "Reggae",
    "Soul",
    "Blues",
    "Dance",
    "House",
    "Techno",
    "Punk",
    "Latin"
]

genres = pd.DataFrame({
    "Genre_id": range(1, len(genres_list) + 1),
    "Name": genres_list
})

# ============================================================
# 4. CREATE SONG_GENRE
# ============================================================

song_genres = set()

for song_id in songs["Song_id"]:

    # Each song gets 1-3 genres.
    number_of_genres = random.randint(1, 3)

    selected_genres = random.sample(
        range(1, len(genres_list) + 1),
        number_of_genres
    )

    for genre_id in selected_genres:

        song_genres.add(
            (song_id, genre_id)
        )

song_genre_df = pd.DataFrame(
    list(song_genres),
    columns=[
        "Song_id",
        "Genre_id"
    ]
)

song_genre_df = song_genre_df.sort_values(
    ["Song_id", "Genre_id"]
).reset_index(drop=True)

# ============================================================
# 5. SAVE ENRICHED DATA
# ============================================================

artists.to_csv(
    "data/artists.csv",
    index=False
)

albums.to_csv(
    "data/albums.csv",
    index=False
)

genres.to_csv(
    "data/genres.csv",
    index=False
)

song_genre_df.to_csv(
    "data/song_genre.csv",
    index=False
)

# ============================================================
# 6. REPORT
# ============================================================

print("\n========================================")
print("MUSIC DATA ENRICHMENT COMPLETE")
print("========================================")

print("Artists:", len(artists))
print("Albums:", len(albums))
print("Songs:", len(songs))
print("Genres:", len(genres))
print("Song-Genre mappings:", len(song_genre_df))
print("Listening records:", len(history))

print("\n===== SAMPLE ARTISTS =====")
print(
    artists.head(5).to_string(index=False)
)

print("\n===== SAMPLE ALBUMS =====")
print(
    albums.head(5).to_string(index=False)
)

print("\n===== SAMPLE GENRES =====")
print(
    genres.to_string(index=False)
)

print("\n===== SAMPLE SONG-GENRE =====")
print(
    song_genre_df.head(10).to_string(index=False)
)