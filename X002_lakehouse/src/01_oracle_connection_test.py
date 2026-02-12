from pyspark.sql import SparkSession
from config.oracle_config import JDBC_URL, OJDBC_JAR, ORACLE_USER, ORACLE_PASSWORD

spark = (
    SparkSession.builder
    .appName("Oracle JDBC Test")
    .config("spark.jars", OJDBC_JAR)
    .getOrCreate()
)

props = {
    "user": ORACLE_USER,
    "password": ORACLE_PASSWORD,
    "driver": "oracle.jdbc.OracleDriver"
}

df = spark.read.jdbc(
    url=JDBC_URL,
    table="(SELECT 1 AS test_col FROM dual)",
    properties=props
)

df.show()
spark.stop()
