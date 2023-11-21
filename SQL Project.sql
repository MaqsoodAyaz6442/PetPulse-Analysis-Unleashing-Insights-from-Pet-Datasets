#List the names of all pet owners along with the names of their pets

select po.OwnerID,po.Name,po.Surname,p.Name as Pet_Name,p.Kind
from petowners as po
join pets as p
on po.OwnerID=p.OwnerID;

#List all pets and their owner names, including pets that don't have recorded owners.
SELECT p.Name AS Pet_Name, p.Kind AS Pet_Kind,
    IFNULL(po.Name, 'Unknown') AS Owner_Name,
    IFNULL(po.Surname, '') AS Owner_Surname
FROM pets AS p
LEFT JOIN petowners AS po ON p.OwnerID = po.OwnerID
ORDER BY p.Name;

#Combine the information of pets and their owners, including those pets without owners and owners without pets.
(SELECT p.Name AS Pet_Name, p.Kind AS Pet_Kind,
    IFNULL(po.Name, 'Unknown') AS Owner_Name,
    IFNULL(po.Surname, '') AS Owner_Surname
FROM pets AS p
LEFT JOIN petowners AS po ON p.OwnerID = po.OwnerID)

UNION 
(select IFNULL(p.Name,'Unknown') as Pet_Name,p.Kind as Pet_Kind,po.Name as Owner_Name,po.Surname as Owner_Surname

from pets as p
right join petowners as po
on po.OwnerID=p.OwnerID
WHERE
    p.OwnerID IS NULL OR po.OwnerID IS NULL
)
Order by Owner_Name,Pet_Name;

#Find the names of pets along with their owners' names and the details of the procedures they have undergone.

select po.OwnerID,po.Name as Owner_Name,p.Name as Pet_Name,p.PetID,pd.ProcedureType,pd.Description
from petowners as po
join pets as p
on po.Ownerid=p.Ownerid
left join procedureshistory as ph
on ph.PetID=p.PetID
left join proceduresdetails as pd
on pd.ProcedureSubCode=ph.ProcedureSubCode
order by Owner_Name,Pet_Name,ProcedureType,Description;

#List all pet owners and the number of dogs they own.
select po.OwnerID,po.Name as Owner_Name,po.Surname as Owner_Surname,count(Case when p.Kind='Dog' then 1 else Null end) as Number_of_Dogs

from petowners as po
left join pets as p
on po.OwnerID=p.OwnerID
group by po.OwnerID,Owner_Name,Owner_Surname
Order by Number_of_Dogs desc;

#Identify pets that have not had any procedures.
Select p.PetID,p.Name
from pets as p
left join procedureshistory as ph
on ph.PetID=p.PetID
where ph.PetID is NULL
Order by p.PetID;

#Find the name of the oldest pet.

select p.Name as Pet_Name, MAX(p.Age) as Oldest_Pet
from pets as p
Group by p.Name,p.Age
Order by p.Age desc;

#List all pets who had procedures that cost more than the average cost of all procedures.
SELECT p.PetID,p.Name as Pet_Name, pd.Price
from pets as p
join procedureshistory as ph
on p.PetID=ph.PetID
join proceduresdetails as pd
on ph.ProcedureSubCode=pd.ProcedureSubCode
where pd.Price>(SELECT Avg(Price) from proceduresdetails)
Group by p.PetID,p.Name,pd.Price
Order by pd.price desc;

#Find the details of procedures performed on 'Cuddles'.
Select p.Name as Pet_Name,p.PetID as Pet_ID,pd.ProcedureType as Procedure_Type,pd.Description as Procedure_Description
from pets as p
join procedureshistory as ph
on ph.PetID=p.PetID
join proceduresdetails as pd
on pd.ProcedureSubCode=ph.ProcedureSubCode
where p.Name='Cuddles'
Group by Pet_ID,Procedure_Type,Procedure_Description
Order by Procedure_Type;

#Create a list of pet owners along with the total cost they have spent on
#procedures and display only those who have spent above the average
#spending.
Select po.OwnerID as Owner_ID,po.Name as Owner_Name,po.Surname as Owner_Surname,p.Name as Pet_Name,pd.Price as Procedure_Cost
from petowners as po
left join pets as p
on po.OwnerID=p.OwnerID
left join procedureshistory as ph
on p.PetID=ph.PetID
left join proceduresdetails as pd
on ph.ProcedureSubCode=pd.ProcedureSubCode
where pd.price>(SELECT avg(Price) from proceduresdetails)
Group by po.OwnerID, Owner_Name, Owner_Surname,Pet_Name,pd.price
Order by Procedure_Cost desc;

#List the pets who have undergone a procedure called 'VACCINATIONS'.

SELECT p.PetID as Pet_ID,p.Name as Pet_Name,pd.ProcedureType as Procedure_Type,pd.Description as Procedure_Description
from pets as p
left join procedureshistory as ph
on ph.PetID=p.PetID
left join proceduresdetails as pd
on pd.ProcedureSubCode=ph.ProcedureSubCode
WHERE pd.ProcedureType='VACCINATIONS'
Group by Pet_ID,Pet_Name,Procedure_Type,Procedure_Description;

#Find the owners of pets who have had a procedure called 'EMERGENCY'.
Select pd.procedureType as Procedure_Type, pd.Description as Procedure_Description, ph.PetID as Pet_ID,p.Name as Pet_Owner_Name
from proceduresdetails as pd
left join procedureshistory as ph
on pd.ProcedureSubCode=ph.ProcedureSubCode
left join pets as p
on p.PetID=ph.PetID
left join petowners as po
on po.OwnerID=p.OwnerID
Where pd.Description='Emergency'
Group by  Pet_Owner_Name,Pet_ID,Procedure_Type,Procedure_Description;

#Calculate the total cost spent by each pet owner on procedures.

SELECT po.Name as Pet_Owner_Name,po.Surname as Pet_Owner_surname,p.Name as Pet_Name, sum(pd.Price) as Total_Expenditure_On_Procedures
from petowners as po
join pets as p
on po.OwnerID=p.OwnerID
join procedureshistory as ph
on ph.PetID=p.PetID
join proceduresdetails as pd
on pd.ProcedureSubCode=ph.ProcedureSubCode
Group by Pet_Owner_Name,Pet_Owner_surname,Pet_Name
Order by Total_Expenditure_On_Procedures desc;

#Count the number of pets of each kind.

SELECT Kind, COUNT(*) as Number_of_Pets
FROM pets
GROUP BY Kind;

#Group pets by their kind and gender and count the number of pets in each
#group.
Select Kind, Gender, Count(Kind) as Number_of_pets
from pets
Group by Kind,Gender
order by count(Kind) desc;

#Show the average age of pets for each kind, but only for kinds that have more
#than 5 pets

Select Kind, Avg(Age) as Avg_Age, Count(Kind) as Number_of_pets
from pets
Group by Kind
Having Count(Kind)>5
Order by Number_of_pets desc;

#Find the types of procedures that have an average cost greater than $50.
Select ProcedureType, Avg(Price) as Avg_Price
from proceduresdetails
Group by procedureType
Having Avg_Price>50
Order by Avg_Price;

#Classify pets as 'Young', 'Adult', or 'Senior' based on their age. Age less then
#3 Young, Age between 3and 8 Adult, else Senior.

SELECT `Name` as Pet_Name,Age,
Case 
when Age<=3 then 'Young'
when Age >3 and Age<=8 then 'Adult'
Else 'Mature'
End as Age_Group
from pets
Group by Pet_Name,Age,Age_Group;

#Calculate the total spending of each pet owner on procedures, labeling them
#as 'Low Spender' for spending under $100, 'Moderate Spender' for spending
#between $100 and $500, and 'High Spender' for spending over $500.

Select po.OwnerID,po.Name as Owner_Name,po.Surname as Owner_Surname,Sum(coalesce(pd.Price,0)) as Total_Spending,
case 
when Sum(coalesce(pd.Price,0))<100 then 'Low Spender'
when Sum(coalesce(pd.Price,0))>=100 and Sum(coalesce(pd.Price,0))<500 then 'Moderate Spender'
Else 'High Spender'
End as Expenditure_Category
from petowners as po 
left join pets as p
on po.OwnerID=p.OwnerID
left join procedureshistory as ph
on ph.PetID=p.PetID
left join proceduresdetails as pd
on pd.ProcedureSubCode=ph.ProcedureSubCode
Group by po.OwnerID, Owner_Name,Owner_Surname
Order by Total_Spending desc,Expenditure_Category;

#Show the gender of pets with a custom label ('Boy' for male, 'Girl' for female).

select `Name`, Gender,
Case
	when Gender='male' then 'Boy'
    Else 'female'
    End as Gender_G
from pets
Order by Gender_G;

#For each pet, display the pet's name, the number of procedures they've had,
#and a status label: 'Regular' for pets with 1 to 3 procedures, 'Frequent' for 4 to
#7 procedures, and 'Super User' for more than 7 procedures.

Select p.Name as Pet_Name,Count(ph.ProcedureType) as Number_of_Procedures,
Case
when Count(ph.ProcedureType)>=1 and Count(ph.ProcedureType)<=3 then 'Regular'
when Count(ph.ProcedureType)>=4 and Count(ph.ProcedureType)<=7 then 'Frequent'
when Count(ph.ProcedureType)>=8 then 'Super User'
Else null
End as Procedure_Frequency
from pets as p
left join procedureshistory as ph
on p.PetID=ph.PetID
Group by Pet_Name
Order by Number_of_Procedures desc, Procedure_frequency;


#Rank pets by age within each kind.

Select `Name`,Kind,
Rank() over(Order by Kind desc) as Rank_Kind
from pets;

#Assign a dense rank to pets based on their age, regardless of kind.

Select Age,
dense_rank() over(order by Age desc) as Age_Rank
from pets;

#For each pet, show the name of the next and previous pet in alphabetical order.

select PetID,`Name`,
Lag(`Name`) over(order by `Name`) as preceeding_pet,
Lead(`Name`) over(order by `Name`) as  succeeding_pet
from pets
order by `Name`;

#Show the average age of pets, partitioned by their kind.

Select Kind,Age,Avg(Age) 
over(partition by Kind) as Avg_Age
from pets;

#Create a CTE that lists all pets, then select pets older than 5 years from the
#CTE.

With pets_All as(
Select PetID,Age
from pets
Where Age>=5
)
Select p.PetID,p.`Name`,p.Age,pa.Age as Older_Than_Five
from pets as p
Left join pets_All as pa
on p.PetID=pa.PetID;






