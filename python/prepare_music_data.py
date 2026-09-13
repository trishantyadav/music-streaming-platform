import pandas as pd

# -------------------------------------------------
# 1. Load cleaned Spotify data
# -------------------------------------------------

input_file = "data/spotify_cleaned.csv"

df = pd.read_csv(input_file)

print("Loaded records:", len(df))

# -------------------------------------------------
# 2. Create ARTIST table
# -------------------------------------------------

artists = (
    df[["artist_name"]]
    .drop_duplicates()
    .sort_values("artist_name")
    .reset_index(drop=True)
)

artists.insert(0, "Artist_id", range(1, len(artists) + 1))

artists.rename(
    columns={"artist_name": "Name"},
    inplace=True
)

# Attributes not available in the real dataset.
# We will enrich these later if required.
artists["Country"] = "Unknown"
artists["Bio"] = "Not available"
artists["Awards"] = "Not available"

# -------------------------------------------------
# 3. Create ARTIST ID lookup
# -------------------------------------------------

artist_lookup = dict(
    zip(artists["Name"], artists["Artist_id"])
)

# -------------------------------------------------
# 4. Create ALBUM table
# -------------------------------------------------

albums = (
    df[["artist_name", "album_name"]]
    .drop_duplicates()
    .sort_values(["artist_name", "album_name"])
    .reset_index(drop=True)
)

albums.insert(0, "Album_id", range(1, len(albums) + 1))

albums["Artist_id"] = albums["artist_name"].map(artist_lookup)

albums.rename(
    columns={"album_name": "Title"},
    inplace=True
)

# We don't have release dates or cover URLs
# in this dataset, so these will be enriched later.
albums["Release_date"] = pd.NaT
albums["Cover_art_url"] = "Not available"

albums = albums[
    [
        "Album_id",
        "Artist_id",
        "Title",
        "Release_date",
        "Cover_art_url"
    ]
]

# -------------------------------------------------
# 5. Create SONG table
# -------------------------------------------------

# A song is identified using artist + album + track.
# This prevents same-named songs from different artists
# being incorrectly merged.

songs = (
    df[
        [
            "artist_name",
            "album_name",
            "track_name",
            "spotify_track_uri"
        ]
    ]
    .drop_duplicates()
    .sort_values(
        ["artist_name", "album_name", "track_name"]
    )
    .reset_index(drop=True)
)

songs.insert(0, "Song_id", range(1, len(songs) + 1))

# Map album using artist + album combination
album_lookup = {
    (row["Title"], row["Artist_id"]): row["Album_id"]
    for _, row in albums.iterrows()
}

songs["Artist_id"] = songs["artist_name"].map(artist_lookup)

songs["Album_id"] = [
    album_lookup.get((album, artist_id))
    for album, artist_id in zip(
        songs["album_name"],
        songs["Artist_id"]
    )
]

songs.rename(
    columns={"track_name": "Title"},
    inplace=True
)

# Duration will be derived from listening history later
songs["Duration"] = 0

songs = songs[
    [
        "Song_id",
        "Album_id",
        "Title",
        "Duration",
        "spotify_track_uri"
    ]
]

# -------------------------------------------------
# 6. Create song lookup
# -------------------------------------------------

song_lookup = dict(
    zip(
        df[
            [
                "spotify_track_uri"
            ]
        ]["spotify_track_uri"],
        df.index
    )
)

# -------------------------------------------------
# 7. Create LISTENING_HISTORY base dataset
# -------------------------------------------------

history = df[
    [
        "spotify_track_uri",
        "played_at",
        "ms_played"
    ]
].copy()

# Map Spotify track URI → Song_id
uri_to_song = dict(
    zip(
        songs["spotify_track_uri"],
        songs["Song_id"]
    )
)

history["Song_id"] = history["spotify_track_uri"].map(
    uri_to_song
)

history.rename(
    columns={
        "played_at": "Played_at",
        "ms_played": "Duration_played"
    },
    inplace=True
)

# History_id is the partial key of the weak entity
history.insert(
    0,
    "History_id",
    range(1, len(history) + 1)
)

history = history[
    [
        "Song_id",
        "History_id",
        "Played_at",
        "Duration_played"
    ]
]

# -------------------------------------------------
# 8. Derive song duration
# -------------------------------------------------

# Use the maximum observed listening duration as an
# approximate duration for each song.

duration_lookup = (
    history.groupby("Song_id")["Duration_played"]
    .max()
)

songs["Duration"] = songs["Song_id"].map(
    duration_lookup
).fillna(0).astype(int)

# -------------------------------------------------
# 9. Save datasets
# -------------------------------------------------

artists.to_csv(
    "data/artists.csv",
    index=False
)

albums.to_csv(
    "data/albums.csv",
    index=False
)

songs.to_csv(
    "data/songs.csv",
    index=False
)

history.to_csv(
    "data/listening_history.csv",
    index=False
)

# -------------------------------------------------
# 10. Print summary
# -------------------------------------------------

print("\n===== DATA PREPARATION COMPLETE =====")

print("Artists:", len(artists))
print("Albums:", len(albums))
print("Songs:", len(songs))
print("Listening records:", len(history))

print("\n===== FILES CREATED =====")

print("data/artists.csv")
print("data/albums.csv")
print("data/songs.csv")
print("data/listening_history.csv")

print("\n===== SAMPLE ARTISTS =====")
print(artists.head(5).to_string(index=False))

print("\n===== SAMPLE ALBUMS =====")
print(albums.head(5).to_string(index=False))

print("\n===== SAMPLE SONGS =====")
print(songs.head(5).to_string(index=False))

print("\n===== SAMPLE LISTENING HISTORY =====")
print(history.head(5).to_string(index=False))