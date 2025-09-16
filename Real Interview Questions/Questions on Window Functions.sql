<p align ='center'>Quesition on Window Functions</p>

Question 1:Imagine you work with Youtube data and have access to a table containing one row per video and each column provides some additional information such as the total number of views and channel. Your stakeholder asks Can you find me the top 5 videos (based on their total views) for every channel?

-- Create the table
CREATE TABLE youtube_videos (
    channel_id VARCHAR(50) NOT NULL,
    video_id VARCHAR(50) NOT NULL,
    view_count BIGINT
);

-- Insert all sample data
INSERT INTO youtube_videos (channel_id, video_id, view_count) VALUES
('02ea5750bca81c9', '3389bba412ddf3626c5a45c1', 20611),
('02ea5750bca81c9', 'a448b6084ce42607c805a268', 22229),
('02ea5750bca81c9', '42cb4240a000ab8e665d535c', 29129),
('02ea5750bca81c9', 'ee69bacc234567c4342eeb46', 66342),
('02ea5750bca81c9', 'a9b8a8728210b08010b70497', 78954),
('02ea5750bca81c9', '41a9b8a8728210b08010e8b4', 5385),
('02ea5750bca81c9', 'e2b27ef23b07dae88025a0b7', 309439),
('02ea5750bca81c9', 'abcde12345', 50000),
('02ea5750bca81c9', 'fghij67890', 15000),
('02ea5750bca81c9', 'klmno11223', 25000),
('0ec9149edad51cb', '4f5214881aab8d5a6117b0ec', 4),
('0ec9149edad51cb', '7323811a4551a88bb424dd71', 76),
('0ec9149edad51cb', 'pqrst44556', 50),
('0ec9149edad51cb', 'uvwxy77889', 100),
('new_channel_1', 'z12345', 100000),
('new_channel_1', 'a45678', 200000),
('new_channel_1', 'b78901', 300000),
('new_channel_1', 'c01234', 400000),
('new_channel_1', 'd98765', 500000),
('new_channel_1', 'e54321', 50000),
('new_channel_2', 'f98765', 10),
('new_channel_2', 'g54321', 20),
('new_channel_2', 'h23456', 30);