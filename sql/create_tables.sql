-- ============================================================
-- MUSIC STREAMING PLATFORM
-- CREATE TABLES
-- ============================================================

-- 1. USERS
CREATE TABLE USERS (
    User_id       NUMBER PRIMARY KEY,
    Name          VARCHAR2(150) NOT NULL,
    Email         VARCHAR2(150) NOT NULL UNIQUE,
    Password      VARCHAR2(100) NOT NULL,
    Signup_date   DATE NOT NULL,
    Country       VARCHAR2(100)
);

-- 2. ARTIST
CREATE TABLE ARTIST (
    Artist_id     NUMBER PRIMARY KEY,
    Name          VARCHAR2(150) NOT NULL,
    Country       VARCHAR2(100),
    Bio           VARCHAR2(500),
    Awards        VARCHAR2(200)
);

-- 3. GENRE
CREATE TABLE GENRE (
    Genre_id      NUMBER PRIMARY KEY,
    Name          VARCHAR2(100) NOT NULL UNIQUE
);

-- 4. SINGLE
CREATE TABLE SINGLE (
    Artist_id     NUMBER PRIMARY KEY,
    Age           NUMBER NOT NULL,
    CONSTRAINT FK_SINGLE_ARTIST
        FOREIGN KEY (Artist_id)
        REFERENCES ARTIST(Artist_id),
    CONSTRAINT CHK_SINGLE_AGE
        CHECK (Age >= 13 AND Age <= 100)
);

-- 5. ARTIST_GROUP
CREATE TABLE ARTIST_GROUP (
    Artist_id       NUMBER PRIMARY KEY,
    Total_members   NUMBER NOT NULL,
    CONSTRAINT FK_GROUP_ARTIST
        FOREIGN KEY (Artist_id)
        REFERENCES ARTIST(Artist_id),
    CONSTRAINT CHK_GROUP_MEMBERS
        CHECK (Total_members >= 2)
);

-- 6. ALBUM
CREATE TABLE ALBUM (
    Album_id       NUMBER PRIMARY KEY,
    Artist_id      NUMBER NOT NULL,
    Title          VARCHAR2(200) NOT NULL,
    Release_date   DATE NOT NULL,
    Cover_art_url  VARCHAR2(500),

    CONSTRAINT FK_ALBUM_ARTIST
        FOREIGN KEY (Artist_id)
        REFERENCES ARTIST(Artist_id)
);

-- 7. SONG
CREATE TABLE SONG (
    Song_id           NUMBER PRIMARY KEY,
    Album_id          NUMBER NOT NULL,
    Title             VARCHAR2(300) NOT NULL,
    Duration          NUMBER NOT NULL,
    Spotify_track_uri VARCHAR2(200),

    CONSTRAINT FK_SONG_ALBUM
        FOREIGN KEY (Album_id)
        REFERENCES ALBUM(Album_id),

    CONSTRAINT CHK_SONG_DURATION
        CHECK (Duration > 0)
);

-- 8. SONG_GENRE
CREATE TABLE SONG_GENRE (
    Song_id     NUMBER,
    Genre_id    NUMBER,

    CONSTRAINT PK_SONG_GENRE
        PRIMARY KEY (Song_id, Genre_id),

    CONSTRAINT FK_SG_SONG
        FOREIGN KEY (Song_id)
        REFERENCES SONG(Song_id),

    CONSTRAINT FK_SG_GENRE
        FOREIGN KEY (Genre_id)
        REFERENCES GENRE(Genre_id)
);

-- 9. PREMIUM_USER
CREATE TABLE PREMIUM_USER (
    User_id           NUMBER PRIMARY KEY,
    Offline_downloads NUMBER NOT NULL,
    Audio_quality     VARCHAR2(30) NOT NULL,
    Ad_free           NUMBER(1) NOT NULL,

    CONSTRAINT FK_PREMIUM_USER
        FOREIGN KEY (User_id)
        REFERENCES USERS(User_id),

    CONSTRAINT CHK_PREMIUM_ADFREE
        CHECK (Ad_free IN (0,1))
);

-- 10. FREE_USER
CREATE TABLE FREE_USER (
    User_id           NUMBER PRIMARY KEY,
    Skip_limit_per_hr NUMBER NOT NULL,
    Ads_enabled       NUMBER(1) NOT NULL,

    CONSTRAINT FK_FREE_USER
        FOREIGN KEY (User_id)
        REFERENCES USERS(User_id),

    CONSTRAINT CHK_FREE_ADS
        CHECK (Ads_enabled IN (0,1))
);

-- 11. PLAYLIST
CREATE TABLE PLAYLIST (
    Playlist_id  NUMBER PRIMARY KEY,
    User_id      NUMBER NOT NULL,
    Name         VARCHAR2(150) NOT NULL,
    Created_date DATE NOT NULL,
    Is_public    NUMBER(1) NOT NULL,

    CONSTRAINT FK_PLAYLIST_USER
        FOREIGN KEY (User_id)
        REFERENCES USERS(User_id),

    CONSTRAINT CHK_PLAYLIST_PUBLIC
        CHECK (Is_public IN (0,1))
);

-- 12. PLAYLIST_SONG
CREATE TABLE PLAYLIST_SONG (
    Playlist_id  NUMBER,
    Song_id      NUMBER,

    CONSTRAINT PK_PLAYLIST_SONG
        PRIMARY KEY (Playlist_id, Song_id),

    CONSTRAINT FK_PS_PLAYLIST
        FOREIGN KEY (Playlist_id)
        REFERENCES PLAYLIST(Playlist_id),

    CONSTRAINT FK_PS_SONG
        FOREIGN KEY (Song_id)
        REFERENCES SONG(Song_id)
);

-- 13. SUBSCRIPTION
CREATE TABLE SUBSCRIPTION (
    Subscription_id NUMBER PRIMARY KEY,
    User_id         NUMBER NOT NULL UNIQUE,
    Plan_type       VARCHAR2(30) NOT NULL,
    Start_date      DATE NOT NULL,
    End_date        DATE NOT NULL,

    CONSTRAINT FK_SUBSCRIPTION_USER
        FOREIGN KEY (User_id)
        REFERENCES PREMIUM_USER(User_id),

    CONSTRAINT CHK_SUBSCRIPTION_PLAN
        CHECK (Plan_type IN ('Monthly','Yearly')),

    CONSTRAINT CHK_SUBSCRIPTION_DATES
        CHECK (End_date >= Start_date)
);

-- 14. PAYMENT
CREATE TABLE PAYMENT (
    Payment_id       NUMBER PRIMARY KEY,
    Subscription_id  NUMBER NOT NULL,
    Payment_date     DATE NOT NULL,
    Payment_method   VARCHAR2(30) NOT NULL,
    Amount           NUMBER(10,2) NOT NULL,
    Status           VARCHAR2(20) NOT NULL,

    CONSTRAINT FK_PAYMENT_SUBSCRIPTION
        FOREIGN KEY (Subscription_id)
        REFERENCES SUBSCRIPTION(Subscription_id),

    CONSTRAINT CHK_PAYMENT_AMOUNT
        CHECK (Amount > 0),

    CONSTRAINT CHK_PAYMENT_STATUS
        CHECK (Status IN ('Success','Failed','Pending'))
);

-- 15. RATING
CREATE TABLE RATING (
    Rating_id    NUMBER PRIMARY KEY,
    User_id      NUMBER NOT NULL,
    Song_id      NUMBER NOT NULL,
    Rating       NUMBER NOT NULL,
    Review_text  VARCHAR2(500),
    Rated_at     DATE NOT NULL,

    CONSTRAINT FK_RATING_USER
        FOREIGN KEY (User_id)
        REFERENCES USERS(User_id),

    CONSTRAINT FK_RATING_SONG
        FOREIGN KEY (Song_id)
        REFERENCES SONG(Song_id),

    CONSTRAINT CHK_RATING_VALUE
        CHECK (Rating BETWEEN 1 AND 5),

    CONSTRAINT UQ_USER_SONG_RATING
        UNIQUE (User_id, Song_id)
);

-- 16. LISTENING_HISTORY
CREATE TABLE LISTENING_HISTORY (
    Song_id          NUMBER,
    History_id       NUMBER,
    User_id          NUMBER NOT NULL,
    Played_at        DATE NOT NULL,
    Duration_played  NUMBER NOT NULL,

    CONSTRAINT PK_LISTENING_HISTORY
        PRIMARY KEY (Song_id, History_id),

    CONSTRAINT FK_HISTORY_SONG
        FOREIGN KEY (Song_id)
        REFERENCES SONG(Song_id),

    CONSTRAINT FK_HISTORY_USER
        FOREIGN KEY (User_id)
        REFERENCES USERS(User_id),

    CONSTRAINT CHK_HISTORY_DURATION
        CHECK (Duration_played >= 0)
);

-- ============================================================
-- VERIFY
-- ============================================================

SELECT table_name
FROM user_tables
ORDER BY table_name;

PROMPT ============================================================
PROMPT ALL 16 TABLES CREATED SUCCESSFULLY
PROMPT ============================================================