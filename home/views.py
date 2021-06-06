from django.shortcuts import render
# from .models import Article

from background_task import background
from django.contrib.auth.models import User

res = []

# Create your views here.
def index(request):
    return render(request, 'home.html', {'objects': res[-1]})

def mqtt(request):
    return render(request, 'mqtt.html')

def about(request):
    import paho.mqtt.client as mqtt
    BROKER = 'io.adafruit.com'
    USER = 'CSE_BBC1'
    PASSWORD = 'aio_VhCE38mvogdpc353vHMQl684Emfs'
    TOPIC = 'CSE_BBC1/feeds/bk-iot-light'

    def on_connect(client, userdata, flags, rc):
        print("Connected with result code "+str(rc))
        if rc == 0:
            print('good')
        else:
            print('no good')

    def on_message(client, userdata, msg):
        print(msg.topic+" "+str(msg.payload))

    def on_log(client, userdata, level, buf):
        print("log: " + buf)


    def on_disconnect(client, userdata, flags, rc=0):
        print("Disconnected result code " + str(rc))

    def on_message(client, userdata, message):
        message = str(message.payload.decode("utf-8"))
        print(message)
        res.append(message)


    client = mqtt.Client('user1')
    client.username_pw_set(username=USER,password=PASSWORD)
    client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_message = on_message


    client.connect(BROKER, 1883, 60)
    client.subscribe(TOPIC)
    # client.publish("khanhdk0000/feeds/light", "123456779")
    client.loop_forever()
    return render(request, 'about.html')


    