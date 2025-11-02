from time import sleep
from json import dumps
from kafka import KafkaProducer

producer = KafkaProducer(
    bootstrap_servers=['kafka:9092'],
    value_serializer=lambda v: dumps(v).encode('utf-8')
)

for i in range(10):
    data = {'number': i}
    producer.send('numtest', value=data)
    print(f"Messaggio inviato: {data}")
    sleep(2)
