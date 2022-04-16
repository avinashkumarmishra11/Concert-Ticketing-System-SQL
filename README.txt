# Concert-Ticketing-System-SQL

Requirements Definition

Business Rules. 

1.  An ARTIST may have one or many CONCERTS. 

2. A CONCERT may have one or many TICKETS.

3. A CUSTOMER may have one or many ORDERS. 

4. An ORDER may have one or many TICKETS associated with it. 

5.  Every TICKET purchased must have an associated TICKET CATEGORY. 

Relationship and Cardinality Description. 

Relationship: (have) between ARTIST and CONCERT. 
Cardinality: 1:M between ARTIST and CONCERT. 
Business rule: An ARTIST may have one or many CONCERTS and 
each CONCERT held must have an associated and valid ARTIST. 


Relationship: (sells) between CONCERT and TICKETS. 
Cardinality: 1:M relationship between CONCERT and TICKETS. 
Business rule: A CONCERT may have one or many TICKETS sold but
each TICKET sold must be linked back to a particular CONCERT. 



Relationship: (has) between TICKET_CATEGORY and TICKETS. 
Cardinality: 1:1 between TICKET_CATEGORY and TICKETS. 
Business rule: Each TICKET sold must be associated with a TICKET_CATEGORY. 


Relationship: (includes) between ORDER_DETAILS and TICKETS. 
Cardinality: 1:M between ORDER_DETAILS and TICKETS. 
Business rule: An ORDER can have one or more TICKETS in it but each ticket must be associated with an ORDER from ORDER_DETAILS table. 


Relationship: (places) between CUSTOMER and ORDER_DETAILS. 
Cardinality: 1:M between CUSTOMER and ORDER_ DETAILS.
Business rule: A CUSTOMER can place one or many ORDERS but each ORDER places must be traced back to at least one CUSTOMER.


Entity and Attribute Description. 

Entities 

Entity Name: ARTIST

Entity Description: The ARTIST table describes the list of artists performing at the the customer’s venue. It is connected to the CONCERT entity

Main Attributes of ARTIST: 
artist_id: (Primary Key) A unique identifier for each artist performing in the concert. 
artist_name: A character type attribute that informs us about the name of the artist. 
genre: a descriptive category denoting the genre of an artist.
genre_id: an identifier that provides a numerical representation for the genre descriptive category.
artist_category: Provides information about the category to which the artist belongs, in regard to their age appropriateness.
artist_rating: Rating of the artist is used as a numerical representation of the popularity of said artist at the time, as represented by a numerical scale of 1-10
concert_id: (Foreign key) an attribute that references to CONCERT table.





Entity Name: CONCERT

Entity Description: Next entity of our database is CONCERT, and it stores details about all the concerts. It relates to both ARTIST and TICKETS tables.

Main Attributes of CONCERT: 
concert_id: (Primary Key) A unique ID for each concert.
stage_id: A numeric attribute to uniquely identify various stages in the concert. 
stage_name: Provides additional information about the stage.
concert_name: The name of the concert.
concert_venue: Information about the venue in the concert.
artist_id: (Foreign key) an attribute that references ARTIST table
concert_date: The data where the concert is being held.
concert_time: The time at which the concert is being held at.


Entity Name: TICKETS

Entity Description: TICKETS store information about tickets of the concert and is a critical table that connects to 3 other entities; CONCERT, TICKET_CATEGORY and ORDER_DETAILS.

Main Attributes of TICKETS: 
ticket_id: (Primary Key) A unique ID for each ticket.
serial_no: The ticket’s serial number, can be utilized as a secondary key for data entry purpose.
concert_id: (Foreign key) references the concert table.
purchase_date: The date when the ticket was purchased.
purchase_time: The date when the ticket was purchased.
seat_no: Identifier to uniquely recognize seats at the concert.
tkt_category_id: (Foreign key) an attribute that references ticket_category table.




Entity Name: TICKET_CATEGORY

Entity Description: This entity in our database provides information about the various categories of tickets available at the concert. It connects to only one table; TICKETS.

Main Attributes of TICKET_CATEGORY: 
tkt_category_id: (Primary Key) A unique ID for each category of the ticket.
ticket_id: (Foreign key) attribute to reference back to TICKETS table. 
description: A description of the ticket category which depends on various factors like price.(i.e. VIP tickets, General Admission, other special categories)
price: Stores information about the price of each ticket category.
start_date: The earliest number of days prior at which a ticket of the category can be purchased.
end_date: The maximum number of days prior to a show, which a ticket of the category can be purchased.


Entity Name: CUSTOMER

Entity Description: This table contains all the relevant information about all the customers attending concert. It connects to only one table; ORDER_DETAILS.

Main Attributes of CUSTOMER:
customer_id: (Primary Key) A unique ID for each customer who purchased a ticket.
customer_name: The customer’s full name. 
customer_email: The customer’s email address, it is a unique attribute and can be used as a secondary key.
customer_contact: Stores information about contact details of the customer.
customer_code: A confirmation code sent to customer while purchasing the ticket.
discount:  Discount given to customer (if any)




Entity Name: ORDER_DETAILS

Entity Description: Table that stores relevant information about the purchase details of the customer. It references back to 2 tables: TICKETS and CUSTOMER

Main Attributes of ORDER_DETAILS:
order_no: (Primary Key) A unique ID for each order placed by the customer.
address: Address at which customer wants the tickets to be delivered to. 
purchase_date: date at which order is placed by the customer.
purchase_time: time at which order is placed by the customer.
Discount:  Discount given to customer (if any)
customer_id: (Foreign key) attribute which references to CUSTOMER table.



Key Assumptions and Special Considerations
Assumptions
A key business assumption being implemented in the design of the database, is that there’ll be a minimum of one ticket being purchased per concert event, for the concert to occur. Therefore, our database design and ERD diagrams will reflect this assumption, rather than considering the option of using zero to many relationships. The reason for this, is that the business will not put on shows that do not sell any tickets, as it’s a far more inexpensive experience for the business to draw up an agreement to cancel the show with a small deposit fee, than pay the full price of a concert being played to an empty venue. 

Design Decisions
Key Factors Influencing Design decisions was that it was decided to keep the number of entities (tables) to a manageable number of 6. This was a decision made in part to ensure overcomplexity would not be a problem for this relatively small business venue, but also to help with the overall efficiency of the database. While some entities, such as genre and others were ruled out, other potential entities were combined. For example, the table named “Order Details” was created to take the place of both the “Order ticket” and “Customer Order” entities. Therefore, an imperative in our design process was to create something simple, manageable, effective, but overwhelmingly practical for this business to use for years to come. 

