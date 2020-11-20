#######################################################################
# SQL with Python
#######################################################################
##########################################
 # Connecting to a DB with Python and INSERTING
##########################################
import sqlite3

# create a new database (my_friends.db) that we will store the information into. or connect to a DB if theres already one there.
conn = sqlite3.connect('my_friends.db')

#----- create cursor object -----
c = conn.cursor() # this will allow us to execute commands

#----- execute some sql -----
#--- create a new table ---
#c.execute('CREATE TABLE friends (first_name TEXT, last_name TEXT, closeness INTEGER)') #make a new table with this information in.

#insert info/friend into the table..
insert_query = '''INSERT INTO friends
                    VALUES ('James', 'Rover', 6)'''

# execute the inesrt_query..
c.execute(insert_query)

#----- commit changes -----
conn.commit()
# we have to close the connection after we have finished.
conn.close()

###################################################### INSERTING ######################################################

# BAD EXAMPLE DO NOT DO THIS
# form_first = 'Dana'
# query = f"INSERT INTO friends (first_name) VALUES ('{form_first}')"
# c.execute(query)

# BETTER WAY!!! just inserting the first name
form_first = 'Mary-Todd'
query = "INSERT INTO friends (first_name) VALUES (?)" # insert into just the first name column (we only have the first name..)
c.execute(query, (form_first,)) # the '?' will be replaced with anything that is in form_first. (has to be in a tuple though!!)

# BETTER WAY with more DATA first, last and closeness
data = ("Steve", "Irwin", 9)
query = "INSERT INTO friends VALUES (?,?,?)" # 3 '?' for 3 different bits of info in data
c.execute(query, data)
conn.commmit()
conn.close()
###################################################### BULK INSERTING ######################################################

people = [ # list tuples, with friend data in..
    ('Roland', 'Amundsen', 5),
    ('Rosa', 'Parks', 8),
    ('Henry', 'Hudson', 7),
    ('Micheal', 'Peters', 6),
    ('David', 'Lisdale', 8)]

# One way of adding all that data in people to our table 'friends'
# This is better for just adding to the database/table
c.exectuemany('INSERT INTO friends VALUES (?,?,?)', people)

# Another way of adding
# This is better if you want to do something else with the data while it is being added to the database/table
for person in people:
    c.execute('INSERT INTO friends VALUES (?,?,?)', person)
    print('Inserting now!!')
    # you could also get 1 bit of data and add it to a different table, or something along them lines.
conn. commit()

###################################################### SELECTING WITH PYTHON ######################################################

#one way of printing /selecting with python..
c.execute('SELECT * FROM friends')

# Iterate over cursor
for result in c:
    print(result)

# Fetch One result (we hve 2 'Rosa' so this will only give us the first)
c.execute("SELECT * FROM friends WHERE first_name IS 'Rosa'")
print(c.fetchone())

# Fetch all results as a list
print(c.fetchall())

# A bit more of a harder query (order by will put it in order low to high )
c.execute('SELECT * FROM friends WHERE closeness > 5 ORDER BY closeness')
