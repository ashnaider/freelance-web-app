def psql_money_to_dec(str_money):
    return str_money[:str_money.find(',')].replace(' ', '')