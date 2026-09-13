import pandas as pd

print("=" * 70)
print("FINAL DATA VALIDATION BEFORE ORACLE")
print("=" * 70)

# Load key files
users = pd.read_csv("data/users.csv")
premium = pd.read_csv("data/premium_user.csv")
free = pd.read_csv("data/free_user.csv")

artists = pd.read_csv("data/artists.csv")
single = pd.read_csv("data/single.csv")
groups = pd.read_csv("data/artist_group.csv")

albums = pd.read_csv("data/albums.csv")
songs = pd.read_csv("data/songs.csv")

genres = pd.read_csv("data/genres.csv")
song_genre = pd.read_csv("data/song_genre.csv")

playlists = pd.read_csv("data/playlists.csv")
playlist_song = pd.read_csv("data/playlist_song.csv")

subscriptions = pd.read_csv("data/subscriptions.csv")
payments = pd.read_csv("data/payments.csv")

ratings = pd.read_csv("data/ratings.csv")
history = pd.read_csv("data/listening_history.csv")


# ============================================================
# 1. PRIMARY KEY CHECKS
# ============================================================

print("\n[1] PRIMARY KEY CHECKS")

checks = {
    "USERS.User_id": users["User_id"].is_unique,
    "ARTIST.Artist_id": artists["Artist_id"].is_unique,
    "ALBUM.Album_id": albums["Album_id"].is_unique,
    "SONG.Song_id": songs["Song_id"].is_unique,
    "GENRE.Genre_id": genres["Genre_id"].is_unique,
    "PLAYLIST.Playlist_id": playlists["Playlist_id"].is_unique,
    "SUBSCRIPTION.Subscription_id": subscriptions["Subscription_id"].is_unique,
    "PAYMENT.Payment_id": payments["Payment_id"].is_unique,
    "RATING.Rating_id": ratings["Rating_id"].is_unique,
}

for name, result in checks.items():
    print(f"{name}: {'OK' if result else 'DUPLICATE FOUND'}")


# ============================================================
# 2. USER SPECIALIZATION
# ============================================================

print("\n[2] USER SPECIALIZATION")

premium_ids = set(premium["User_id"])
free_ids = set(free["User_id"])
user_ids = set(users["User_id"])

print("Premium users:", len(premium_ids))
print("Free users:", len(free_ids))

print(
    "Users in both Premium and Free:",
    len(premium_ids & free_ids)
)

print(
    "Users without subtype:",
    len(user_ids - premium_ids - free_ids)
)


# ============================================================
# 3. ARTIST SPECIALIZATION
# ============================================================

print("\n[3] ARTIST SPECIALIZATION")

single_ids = set(single["Artist_id"])
group_ids = set(groups["Artist_id"])
artist_ids = set(artists["Artist_id"])

print("Single artists:", len(single_ids))
print("Artist groups:", len(group_ids))

print(
    "Artists in both:",
    len(single_ids & group_ids)
)

print(
    "Artists without subtype:",
    len(artist_ids - single_ids - group_ids)
)


# ============================================================
# 4. FOREIGN KEY CHECKS
# ============================================================

print("\n[4] FOREIGN KEY CHECKS")

print(
    "Albums with invalid Artist_id:",
    (~albums["Artist_id"].isin(artist_ids)).sum()
)

print(
    "Songs with invalid Album_id:",
    (~songs["Album_id"].isin(set(albums["Album_id"]))).sum()
)

print(
    "Song-Genre with invalid Song_id:",
    (~song_genre["Song_id"].isin(set(songs["Song_id"]))).sum()
)

print(
    "Song-Genre with invalid Genre_id:",
    (~song_genre["Genre_id"].isin(set(genres["Genre_id"]))).sum()
)

print(
    "Playlist with invalid User_id:",
    (~playlists["User_id"].isin(user_ids)).sum()
)

print(
    "Playlist-Song with invalid Playlist_id:",
    (~playlist_song["Playlist_id"].isin(set(playlists["Playlist_id"]))).sum()
)

print(
    "Playlist-Song with invalid Song_id:",
    (~playlist_song["Song_id"].isin(set(songs["Song_id"]))).sum()
)

print(
    "History with invalid Song_id:",
    (~history["Song_id"].isin(set(songs["Song_id"]))).sum()
)

print(
    "History with invalid User_id:",
    (~history["User_id"].isin(user_ids)).sum()
)


# ============================================================
# 5. RATING UNIQUE CONSTRAINT
# ============================================================

print("\n[5] RATING UNIQUE CHECK")

duplicate_ratings = ratings.duplicated(
    subset=["User_id", "Song_id"]
).sum()

print(
    "Duplicate User + Song ratings:",
    duplicate_ratings
)

print(
    "Ratings outside 1-5:",
    ((ratings["Rating"] < 1) | (ratings["Rating"] > 5)).sum()
)


# ============================================================
# 6. LISTENING HISTORY PRIMARY KEY
# ============================================================

print("\n[6] LISTENING HISTORY CHECK")

duplicate_history = history.duplicated(
    subset=["Song_id", "History_id"]
).sum()

print(
    "Duplicate (Song_id, History_id):",
    duplicate_history
)

print(
    "Listening records:",
    len(history)
)


# ============================================================
# FINAL RESULT
# ============================================================

print("\n" + "=" * 70)
print("VALIDATION COMPLETE")
print("=" * 70)