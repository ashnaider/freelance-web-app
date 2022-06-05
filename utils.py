def psql_money_to_dec(str_money):
    return str_money[:str_money.find(',')].replace(' ', '')

def crop_psql_error(psql_err):
    return psql_err[:psql_err.find('!')+1]