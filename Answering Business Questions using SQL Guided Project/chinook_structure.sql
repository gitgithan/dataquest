CREATE TABLE [album]
(
    [album_id] INTEGER PRIMARY KEY NOT NULL,
    [title] NVARCHAR(160)  NOT NULL,
    [artist_id] INTEGER  NOT NULL,
    FOREIGN KEY ([artist_id]) REFERENCES [artist] ([artist_id]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE [artist]
(
    [artist_id] INTEGER PRIMARY KEY NOT NULL,
    [name] NVARCHAR(120)
);
CREATE TABLE [customer]
(
    [customer_id] INTEGER PRIMARY KEY NOT NULL,
    [first_name] NVARCHAR(40)  NOT NULL,
    [last_name] NVARCHAR(20)  NOT NULL,
    [company] NVARCHAR(80),
    [address] NVARCHAR(70),
    [city] NVARCHAR(40),
    [state] NVARCHAR(40),
    [country] NVARCHAR(40),
    [postal_code] NVARCHAR(10),
    [phone] NVARCHAR(24),
    [fax] NVARCHAR(24),
    [email] NVARCHAR(60)  NOT NULL,
    [support_rep_id] INTEGER,
    FOREIGN KEY ([support_rep_id]) REFERENCES [employee] ([employee_id]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE [employee]
(
    [employee_id] INTEGER PRIMARY KEY NOT NULL,
    [last_name] NVARCHAR(20)  NOT NULL,
    [first_name] NVARCHAR(20)  NOT NULL,
    [title] NVARCHAR(30),
    [reports_to] INTEGER,
    [birthdate] DATETIME,
    [hire_date] DATETIME,
    [address] NVARCHAR(70),
    [city] NVARCHAR(40),
    [state] NVARCHAR(40),
    [country] NVARCHAR(40),
    [postal_code] NVARCHAR(10),
    [phone] NVARCHAR(24),
    [fax] NVARCHAR(24),
    [email] NVARCHAR(60),
    FOREIGN KEY ([reports_to]) REFERENCES [employee] ([employee_id]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE [genre]
(
    [genre_id] INTEGER PRIMARY KEY NOT NULL,
    [name] NVARCHAR(120)
);
CREATE TABLE [invoice]
(
    [invoice_id] INTEGER PRIMARY KEY NOT NULL,
    [customer_id] INTEGER  NOT NULL,
    [invoice_date] DATETIME  NOT NULL,
    [billing_address] NVARCHAR(70),
    [billing_city] NVARCHAR(40),
    [billing_state] NVARCHAR(40),
    [billing_country] NVARCHAR(40),
    [billing_postal_code] NVARCHAR(10),
    [total] NUMERIC(10,2)  NOT NULL,
    FOREIGN KEY ([customer_id]) REFERENCES [customer] ([customer_id]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE [invoice_line]
(
    [invoice_line_id] INTEGER PRIMARY KEY NOT NULL,
    [invoice_id] INTEGER  NOT NULL,
    [track_id] INTEGER  NOT NULL,
    [unit_price] NUMERIC(10,2)  NOT NULL,
    [quantity] INTEGER  NOT NULL,
    FOREIGN KEY ([invoice_id]) REFERENCES [invoice] ([invoice_id]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ([track_id]) REFERENCES [track] ([track_id]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE [media_type]
(
    [media_type_id] INTEGER PRIMARY KEY NOT NULL,
    [name] NVARCHAR(120)
);
CREATE TABLE [playlist]
(
    [playlist_id] INTEGER PRIMARY KEY NOT NULL,
    [name] NVARCHAR(120)
);
CREATE TABLE [playlist_track]
(
    [playlist_id] INTEGER  NOT NULL,
    [track_id] INTEGER  NOT NULL,
    CONSTRAINT [pk_playlist_track] PRIMARY KEY  ([playlist_id], [track_id]),
    FOREIGN KEY ([playlist_id]) REFERENCES [playlist] ([playlist_id]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ([track_id]) REFERENCES [track] ([track_id]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE [track]
(
    [track_id] INTEGER PRIMARY KEY NOT NULL,
    [name] NVARCHAR(200)  NOT NULL,
    [album_id] INTEGER,
    [media_type_id] INTEGER  NOT NULL,
    [genre_id] INTEGER,
    [composer] NVARCHAR(220),
    [milliseconds] INTEGER  NOT NULL,
    [bytes] INTEGER,
    [unit_price] NUMERIC(10,2)  NOT NULL,
    FOREIGN KEY ([album_id]) REFERENCES [album] ([album_id]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ([genre_id]) REFERENCES [genre] ([genre_id]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ([media_type_id]) REFERENCES [media_type] ([media_type_id]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX [ifk_albumartist_id] ON [album] ([artist_id]);
CREATE INDEX [ifk_customersupport_rep_id] ON [customer] ([support_rep_id]);
CREATE INDEX [ifk_employeereports_to] ON [employee] ([reports_to]);
CREATE INDEX [ifk_invoicecustomer_id] ON [invoice] ([customer_id]);
CREATE INDEX [ifk_invoice_lineinvoice_id] ON [invoice_line] ([invoice_id]);
CREATE INDEX [ifk_invoice_linetrack_id] ON [invoice_line] ([track_id]);
CREATE INDEX [ifk_playlist_tracktrack_id] ON [playlist_track] ([track_id]);
CREATE INDEX [ifk_trackalbum_id] ON [track] ([album_id]);
CREATE INDEX [ifk_trackgenre_id] ON [track] ([genre_id]);
CREATE INDEX [ifk_trackmedia_type_id] ON [track] ([media_type_id]);
CREATE VIEW rep_performance AS
        SELECT 
             c.support_rep_id,
             SUM(i.total) sales
        FROM customer c
        INNER JOIN invoice i ON c.customer_id = i.customer_id    
        GROUP BY 1
/* rep_performance(support_rep_id,sales) */;
current output mode: list
