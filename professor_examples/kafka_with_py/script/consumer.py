from kafka import KafkaConsumer
from json import loads

def main():
    # configure the Kafka consumer
    consumer = KafkaConsumer(
        'test-topic',                      # replace with the correct topic name    
        bootstrap_servers=['localhost:9092'],
        auto_offset_reset='earliest',     # read from the beginning
        enable_auto_commit=True,
        group_id='python-consumer-group',
        value_deserializer=lambda x: loads(x.decode('utf-8'))
    )

    print("Listening on topic 'test-topic'...")
    for message in consumer:
        print(f"Received: topic={message.topic}  partition={message.partition} offset={message.offset} value={message.value}")

if __name__ == '__main__':
    main()
