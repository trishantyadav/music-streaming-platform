import pandas as pd
import random
from faker import Faker
from datetime import timedelta

fake = Faker()
random.seed(42)
Faker.seed(42)

# ============================================================
# CONFIGURATION
# ============================================================

NUM_USERS = 1000
NUM_PLAYLISTS = 500
NUM_RATINGS = 10000
NUM_PLAYLIST_SONGS = 5000

# ============================================================
# LOAD REAL SONG DATA
# ============================================================

songs = pd.read_csv("data/songs.csv")

song_ids = songs["Song_id"].tolist()

print("Real songs loaded:", len(song_ids))

# ============================================================
# 1. USERS
# ============================================================

users = []

for user_id in range(1, NUM_USERS + 1):

    signup_date = fake.date_between(
        start_date="-5y",
        end_date="today"
    )

    users.append({
        "User_id": user_id,
        "Name": fake.name(),
        "Email": f"user{user_id}@musicapp.com",
        "Password": fake.password(length=12),
        "Signup_date": signup_date,
        "Country": fake.country()
    })

users_df = pd.DataFrame(users)

# ============================================================
# 2. PREMIUM USER / FREE USER
# ============================================================

premium_user_ids = random.sample(
    range(1, NUM_USERS + 1),
    600
)

premium_users = []

for user_id in premium_user_ids:

    premium_users.append({
        "User_id": user_id,
        "Offline_downloads": random.choice([50, 100, 200, 500]),
        "Audio_quality": random.choice([
            "High",
            "Very High",
            "Lossless"
        ]),
        "Ad_free": True
    })

premium_df = pd.DataFrame(premium_users)

premium_set = set(premium_user_ids)

free_users = []

for user_id in range(1, NUM_USERS + 1):

    if user_id not in premium_set:

        free_users.append({
            "User_id": user_id,
            "Skip_limit_per_hr": random.choice([3, 5, 6]),
            "Ads_enabled": True
        })

free_df = pd.DataFrame(free_users)

# ============================================================
# 3. SUBSCRIPTIONS
# ============================================================

subscriptions = []

subscription_id = 1

for user_id in premium_user_ids:

    start_date = fake.date_between(
        start_date="-3y",
        end_date="-30d"
    )

    end_date = start_date + timedelta(
        days=random.choice([30, 90, 180, 365])
    )

    subscriptions.append({
        "Subscription_id": subscription_id,
        "User_id": user_id,
        "Plan_type": random.choice([
            "Monthly",
            "Quarterly",
            "Annual"
        ]),
        "Start_date": start_date,
        "End_date": end_date
    })

    subscription_id += 1

subscriptions_df = pd.DataFrame(subscriptions)

# ============================================================
# 4. PAYMENTS
# ============================================================

payments = []

payment_id = 1

for _, sub in subscriptions_df.iterrows():

    start = pd.to_datetime(sub["Start_date"])
    end = pd.to_datetime(sub["End_date"])

    current_date = start

    while current_date <= end:

        plan = sub["Plan_type"]

        if plan == "Monthly":
            amount = random.choice([99, 119, 129])

            next_period = current_date + timedelta(days=30)

        elif plan == "Quarterly":
            amount = random.choice([299, 329, 349])

            next_period = current_date + timedelta(days=90)

        else:
            amount = random.choice([999, 1199, 1299])

            next_period = current_date + timedelta(days=365)

        payments.append({
            "Payment_id": payment_id,
            "Subscription_id": int(sub["Subscription_id"]),
            "Payment_date": current_date.date(),
            "Payment_method": random.choice([
                "UPI",
                "Credit Card",
                "Debit Card",
                "Net Banking"
            ]),
            "Amount": amount,
            "Status": random.choice([
                "Success",
                "Success",
                "Success",
                "Failed"
            ])
        })

        payment_id += 1

        current_date = next_period

payments_df = pd.DataFrame(payments)

# ============================================================
# 5. PLAYLISTS
# ============================================================

playlist_names = [
    "My Favorites",
    "Chill Vibes",
    "Workout Mix",
    "Morning Energy",
    "Late Night",
    "Road Trip",
    "Study Focus",
    "Weekend Hits",
    "Party Mix",
    "Relaxing Songs"
]

playlists = []

for playlist_id in range(1, NUM_PLAYLISTS + 1):

    user_id = random.randint(1, NUM_USERS)

    playlists.append({
        "Playlist_id": playlist_id,
        "User_id": user_id,
        "Name": random.choice(playlist_names)
                + f" #{playlist_id}",
        "Created_date": fake.date_between(
            start_date="-3y",
            end_date="today"
        ),
        "Is_public": random.choice([True, False])
    })

playlists_df = pd.DataFrame(playlists)

# ============================================================
# 6. PLAYLIST_SONG
# ============================================================

playlist_songs = set()

while len(playlist_songs) < NUM_PLAYLIST_SONGS:

    playlist_id = random.randint(
        1,
        NUM_PLAYLISTS
    )

    song_id = random.choice(song_ids)

    playlist_songs.add(
        (playlist_id, song_id)
    )

playlist_song_df = pd.DataFrame(
    list(playlist_songs),
    columns=[
        "Playlist_id",
        "Song_id"
    ]
)

# ============================================================
# 7. RATINGS
# ============================================================

ratings = set()

while len(ratings) < NUM_RATINGS:

    user_id = random.randint(
        1,
        NUM_USERS
    )

    song_id = random.choice(song_ids)

    # One rating per user per song
    ratings.add(
        (user_id, song_id)
    )

rating_rows = []

rating_comments = [
    "Amazing song!",
    "Really love this track.",
    "Great music.",
    "One of my favorites.",
    "Very catchy.",
    "Good song.",
    "Nice track.",
    "Perfect!",
    "Worth listening to.",
    "Not bad."
]

rating_id = 1

for user_id, song_id in ratings:

    rating_rows.append({
        "Rating_id": rating_id,
        "User_id": user_id,
        "Song_id": song_id,
        "Rating": random.randint(1, 5),
        "Review_text": random.choice(
            rating_comments
        ),
        "Rated_at": fake.date_between(
            start_date="-2y",
            end_date="today"
        )
    })

    rating_id += 1

ratings_df = pd.DataFrame(rating_rows)

# ============================================================
# 8. SAVE ALL DATASETS
# ============================================================

users_df.to_csv(
    "data/users.csv",
    index=False
)

premium_df.to_csv(
    "data/premium_user.csv",
    index=False
)

free_df.to_csv(
    "data/free_user.csv",
    index=False
)

subscriptions_df.to_csv(
    "data/subscriptions.csv",
    index=False
)

payments_df.to_csv(
    "data/payments.csv",
    index=False
)

playlists_df.to_csv(
    "data/playlists.csv",
    index=False
)

playlist_song_df.to_csv(
    "data/playlist_song.csv",
    index=False
)

ratings_df.to_csv(
    "data/ratings.csv",
    index=False
)

# ============================================================
# FINAL REPORT
# ============================================================

print("\n====================================")
print("SUPPORTING DATA GENERATION COMPLETE")
print("====================================")

print("Users:", len(users_df))
print("Premium users:", len(premium_df))
print("Free users:", len(free_df))
print("Subscriptions:", len(subscriptions_df))
print("Payments:", len(payments_df))
print("Playlists:", len(playlists_df))
print("Playlist-Song mappings:", len(playlist_song_df))
print("Ratings:", len(ratings_df))

print("\nFiles created:")
print("users.csv")
print("premium_user.csv")
print("free_user.csv")
print("subscriptions.csv")
print("payments.csv")
print("playlists.csv")
print("playlist_song.csv")
print("ratings.csv")