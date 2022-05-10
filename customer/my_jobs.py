from db import get_db_cursor, close_cursor
from auth import *

def get_customers_jobs(customer_id):
    cursor = get_db_cursor()
    cursor.execute(
        "SELECT * FROM new_job INNER JOIN customer c on new_job.customer_id = c.id WHERE c.id = (%s)",
        (customer_id,)
    )
    jobs = cursor.fetchall()
    close_cursor(cursor)

    return render_template('jobs.html', jobs=jobs)



