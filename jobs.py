from db import get_db_cursor, close_cursor
from auth import *

def get_jobs():
    cursor = get_db_cursor()
    cursor.execute(
        "SELECT * FROM new_job INNER JOIN customer c on new_job.customer_id = c.id"
    )
    jobs = cursor.fetchall()
    close_cursor(cursor)

    print("all jobs: ", jobs)
    if jobs:
        print(jobs[0]['price'])

    return render_template('jobs.html', jobs=jobs)



