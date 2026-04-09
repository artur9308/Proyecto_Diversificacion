from sqlalchemy import create_engine

USER = "root"
PASSWORD = "root123"
HOST = "localhost"
PORT = "3307"  
DB = "milpa_alta_agricola"

engine = create_engine(f"mysql+pymysql://{USER}:{PASSWORD}@{HOST}:{PORT}/{DB}")

def get_engine():
    return engine