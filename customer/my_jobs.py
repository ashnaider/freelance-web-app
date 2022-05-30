from db import get_db_cursor, close_cursor
from auth import *
#
# def get_customers_jobs(customer_id):
#     cursor = get_db_cursor()
#     cursor.execute(
#         "SELECT new_job.id as job_id, c.id as customer_id, c.first_name, c.is_blocked,"
#         "c.last_name, new_job.posted, new_job.description, new_job.price, new_job.status, "
#         "new_job.is_blocked, new_job.is_hourly_rate, new_job.header_ "
#         "FROM new_job INNER JOIN customer c on new_job.customer_id = c.id "
#         "WHERE c.id = (%s)",
#         (customer_id,)
#     )
#
#     jobs = cursor.fetchall()
#     close_cursor(cursor)
#
#     return render_template('jobs.html', jobs=jobs)



