CREATE DATABASE ArtGallery;
USE ArtGallery;


CREATE TABLE Artists (
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100));

CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);

CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);

CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

 -- Insert sample data into the Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

-- Insert sample data into the Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');

-- Insert sample data into the Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picassos powerful anti-war mural.', 'guernica.jpg');

-- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

-- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2);


 SELECT*FROM Artists;
 SELECT*FROM Artworks;
 SELECT*FROM Categories;
 SELECT*FROM Exhibitions;
 SELECT*FROM ExhibitionArtworks;

 --1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and  list them in descending order of the number of artworks.
 SELECT A.Name,COUNT(Ar.ArtworkID) AS NumberOfArtworks
 FROM Artists A
 LEFT JOIN Artworks Ar
 ON Ar.ArtistID=A.ArtistID
 GROUP BY A.Name
 ORDER BY NumberOfArtworks DESC;

 --2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order  them by the year in ascending order.
 SELECT Ar.Title,Ar.Year
 FROM Artworks Ar
 JOIN Artists A
 ON A.ArtistID=Ar.ArtistID
 WHERE Nationality IN ('Spanish','Dutch')
 ORDER BY Year ASC;
  
 --3. Find the names of all artists who have artworks in the 'Painting' category, and the number of  artworks they have in this category.
 SELECT A.Name,COUNT(Ar.ArtworkID) AS ArtworkCount
 FROM Artists A
 JOIN Artworks Ar
 ON Ar.ArtistID=A.ArtistID
 JOIN Categories C
 ON C.CategoryID=Ar.CategoryID
 WHERE C.Name='Painting'
 GROUP BY A.Name;

 --4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their  artists and categories.
 SELECT Ar.Title,A.Name,C.Name
 FROM Artworks Ar
 JOIN Artists A ON A.ArtistID=Ar.ArtistID
 JOIN Categories C ON C.CategoryID=Ar.CategoryID
 JOIN ExhibitionArtworks EA ON EA.ArtworkID = Ar.ArtworkID
 JOIN Exhibitions E ON E.ExhibitionID = EA.ExhibitionID
 WHERE E.Title='Modern Art Masterpieces';

 --5. Find the artists who have more than two artworks in the gallery.
 SELECT A.Name, COUNT(Ar.ArtistID) AS ArtworkCount
 FROM Artists A
 JOIN Artworks Ar
 ON Ar.ArtistID=A.ArtistID
 GROUP BY A.Name
 HAVING COUNT(Ar.ArtistID)>2;
 --(NO SUCH DATA AVIALABLE)

--6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and  'Renaissance Art' exhibitions
SELECT Ar.Title
FROM Artworks Ar
JOIN ExhibitionArtworks EA ON EA.ArtworkID=Ar.ArtworkID
JOIN Exhibitions E ON E.ExhibitionID=EA.ExhibitionID
WHERE (E.Title) IN ('Modern Art Masterpieces','Renaissance Art')
GROUP BY Ar.Title
HAVING COUNT(DISTINCT E.ExhibitionID)=2;

--7. Find the total number of artworks in each category
SELECT C.Name, COUNT(Ar.ArtworkID) AS ArtworkCount
FROM Categories C
LEFT JOIN Artworks Ar
ON Ar.CategoryID=C.CategoryID
GROUP BY C.Name;

 --8. List artists who have more than 3 artworks in the gallery.
 SELECT A.Name, COUNT(Ar.ArtistID) AS ArtworkCount 
 FROM Artists A
 JOIN Artworks Ar
 ON Ar.ArtistID=A.ArtistID
 GROUP BY A.Name
 HAVING COUNT(Ar.ArtistID)>3;
 --(NO SUCH DATA AVILABLE)

 --9. Find the artworks created by artists from a specific nationality (e.g., Spanish).
 SELECT Ar.Title
 FROM Artworks Ar
 JOIN Artists A
 ON A.ArtistID=Ar.ArtistID
 WHERE Nationality='Spanish';

 --10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.
 SELECT E.Title
 FROM Exhibitions E
 JOIN ExhibitionArtworks EA ON EA.ExhibitionID=E.ExhibitionID
 JOIN Artworks Ar ON Ar.ArtworkID=EA.ArtworkID
 JOIN Artists A ON A.ArtistID=Ar.ArtistID
 WHERE (A.Name) IN ('Vincent van Gogh','Leonardo da Vinci')
 GROUP BY E.Title
 HAVING COUNT(DISTINCT(A.Name)) =2;

 --11. Find all the artworks that have not been included in any exhibition.
 SELECT Ar.Title
 FROM Artworks Ar
 WHERE (Ar.ArtworkID) NOT IN (SELECT EA.ArtworkID FROM ExhibitionArtworks EA);
 --(NO SUCH DATA AVIALABLE)

 --12. List artists who have created artworks in all available categories.
SELECT A.Name
FROM Artists A
JOIN Artworks Ar ON Ar.ArtistID = A.ArtistID
JOIN Categories C ON C.CategoryID = Ar.CategoryID
GROUP BY A.Name
HAVING COUNT(DISTINCT C.CategoryID) = (SELECT COUNT(DISTINCT CategoryID) FROM Categories);
 --(NO SUCH DATA AVIALABLE)

 --13. List the total number of artworks in each category.
 SELECT C.Name,COUNT(Ar.ArtworkID) AS ArtworkCount
 FROM Categories C
 LEFT JOIN Artworks Ar
 ON Ar.CategoryID=C.CategoryID
 GROUP BY C.Name;

 --14. Find the artists who have more than 2 artworks in the gallery.
 SELECT A.Name, COUNT(Ar.ArtworkID) AS ArtworkCount
FROM Artists A
JOIN Artworks Ar ON Ar.ArtistID = A.ArtistID
GROUP BY A.Name
HAVING COUNT(Ar.ArtworkID) > 2;
--(NO SUCH DATA AVIALABLE)

--15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork.
SELECT C.CategoryID, C.Name, AVG(Ar.Year) AS AverageYear
FROM Categories C
JOIN Artworks Ar
ON Ar.CategoryID=C.CategoryID
GROUP BY C.CategoryID,C.Name
HAVING COUNT(Ar.ArtworkID)>1;

--16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.
SELECT Ar.ArtworkID,Ar.Title
FROM Artworks Ar
JOIN ExhibitionArtworks EA ON EA.ArtworkID=Ar.ArtworkID
JOIN Exhibitions E ON E.ExhibitionID=EA.ExhibitionID
WHERE E.Title='Modern Art Masterpieces';

--17. Find the categories where the average year of artworks is greater than the average year of all artworks.
SELECT C.CategoryID,C.Name,AVG(Ar.Year) AS AverageCategoryYear 
FROM Categories C
JOIN Artworks Ar ON Ar.CategoryID=C.CategoryID
GROUP BY C.CategoryID,C.Name
HAVING AVG(Ar.Year) >(SELECT AVG(Ar.Year) FROM Artworks Ar);
--(NO SUCH DATA AVAILABLE)

--18. List the artworks that were not exhibited in any exhibition.
SELECT Ar.Title
FROM Artworks Ar
WHERE Ar.ArtworkID NOT IN (SELECT EA.ArtworkID FROM ExhibitionArtworks EA);

--19. Show artists who have artworks in the same category as "Mona Lisa."
SELECT A.ArtistID,A.Name
FROM Artists A
JOIN Artworks Ar ON Ar.ArtistID=A.ArtistID
JOIN Categories C ON C.CategoryID=Ar.CategoryID
WHERE C.CategoryID IN (SELECT C.CategoryID FROM Artworks Ar WHERE Ar.Title='Mona Lisa');

--20. List the names of artists and the number of artworks they have in the gallery
SELECT A.Name, COUNT(Ar.ArtworkID) AS ArtworkCount
FROM Artists A
LEFT JOIN Artworks Ar
ON Ar.ArtistID=A.ArtistID
GROUP BY A.Name;