import psycopg2


def test():
    conn = None
    try:
        conn = psycopg2.connect(
            dbname='freelancer-db',
            user='customer_user',
            password='customer',
            host='localhost'
        )

        cur = conn.cursor()
        # insert a new part
        cur.execute(
            """ SELECT * from new_job; """
        )
        # get the part id
        jobs = cur.fetchall()

        # commit changes
        conn.commit()
        # assign parts provided by vendors
        print(jobs)

        while True:
            pass


    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
